//
//  SubjectViewModel.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 08/06/2024.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

@MainActor
class SubjectViewModel : ObservableObject {
    @Published var subjects: [Subject] = []
    
    private let db = Firestore.firestore()
    
    init() {
        fetchSubjects()
    }
    
    func fetchSubjects() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userId).collection("subjects").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching subjects: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            self.subjects = documents.compactMap { try? $0.data(as: Subject.self) }
        }
    }
    
    func addSubject(name: String) async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let newSubject = Subject(id: UUID().uuidString, name: name, topics: [])
        do {
            let encodedSubject = try Firestore.Encoder().encode(newSubject)
            try await db.collection("users").document(userId).collection("subjects").document(newSubject.id).setData(encodedSubject)
            self.subjects.append(newSubject)
        } catch {
            print("Error adding subject: \(error.localizedDescription)")
        }
    }
    
    func deleteSubject(subject: Subject) async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        do {
            try await db.collection("users").document(userId).collection("subjects").document(subject.id).delete()
            self.subjects.removeAll { $0.id == subject.id }
        } catch {
            print("Error deleting subject: \(error.localizedDescription)")
        }
    }
    
}
