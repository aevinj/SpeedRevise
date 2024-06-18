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
    @Published var topics: [Topic] = []
    
    private let db = Firestore.firestore()
    private var userID = Auth.auth().currentUser?.uid ?? nil
    
    func updateUserID() {
        userID = Auth.auth().currentUser!.uid
    }
    
    func fetchSubjects() {
        db.collection("users").document(userID!).collection("subjects").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching subjects: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            self.subjects = documents.compactMap { try? $0.data(as: Subject.self) }
        }
    }
    
    func addSubject(name: String) async {
        let newSubject = Subject(name: name)
        do {
            let encodedSubject = try Firestore.Encoder().encode(newSubject)
            try await db.collection("users").document(userID!).collection("subjects").document(newSubject.id).setData(encodedSubject)
            self.subjects.append(newSubject)
        } catch {
            print("Error adding subject: \(error.localizedDescription)")
        }
    }
    
    func deleteSubject(subjectID: String) async {
        do {
            try await db.collection("users").document(userID!).collection("subjects").document(subjectID).delete()
            self.subjects.removeAll { $0.id == subjectID }
        } catch {
            print("Error deleting subject: \(error.localizedDescription)")
        }
    }
    
    func fetchTopics(subjectID: String) {
        db.collection("users").document(userID!).collection("subjects").document(subjectID).collection("topics").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching topics: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            self.topics = documents.compactMap { try? $0.data(as: Topic.self) }
        }
    }
    
    func addTopic(subjectID: String, topicName: String) async {
        let newTopic = Topic(name: topicName)
        do {
            let encodedTopic = try Firestore.Encoder().encode(newTopic)
            try await db.collection("users").document(userID!).collection("subjects").document(subjectID).collection("topics").document(newTopic.id).setData(encodedTopic)
            self.topics.append(newTopic)
        } catch {
            print("Error adding subject: \(error.localizedDescription)")
        }
    }
    
    func deleteTopic(subjectID: String, topicID: String) async {
        do {
            try await db.collection("users").document(userID!).collection("subjects").document(subjectID).collection("topics").document(topicID).delete()
            self.topics.removeAll {$0.id == topicID}
        } catch {
            print("Error deleting topic: \(error.localizedDescription)")
        }
    }
}











