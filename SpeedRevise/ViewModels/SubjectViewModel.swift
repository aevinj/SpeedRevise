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
    @Published var quizzes: [Quiz] = []
    @Published var note: Note?
    
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
    
    func addQuiz(newQuiz: Quiz, subjectID: String, topicID: String) async {
        do {
            let encodedQuiz = try Firestore.Encoder().encode(newQuiz)
            try await db.collection("users").document(userID!).collection("subjects").document(subjectID).collection("topics").document(topicID).collection("quizzes").document(newQuiz.id).setData(encodedQuiz)
            self.quizzes.append(newQuiz)
        } catch {
            print("Error adding quiz: \(error.localizedDescription)")
        }
    }
    
    func fetchQuizzes(subjectID: String, topicID: String) {
        db.collection("users").document(userID!).collection("subjects").document(subjectID).collection("topics").document(topicID).collection("quizzes").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching quizzes: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            self.quizzes = documents.compactMap { try? $0.data(as: Quiz.self) }
        }
    }
    
    func deleteQuiz(subjectID: String, topicID: String, quizID: String) async {
        do {
            try await db.collection("users").document(userID!).collection("subjects").document(subjectID).collection("topics").document(topicID).collection("quizzes").document(quizID).delete()
            self.quizzes.removeAll {$0.id == quizID}
        } catch {
            print("Error deleting quiz: \(error.localizedDescription)")
        }
    }
    
    func addNote(noteContent: String, subjectID: String, topicID: String, quizID: String, quizName: String) async {
        do {
            let newNote = Note(name: quizName + "'s Note", content: noteContent)
            let encodedNote = try Firestore.Encoder().encode(newNote)
            
            try await db.collection("users").document(userID!).collection("subjects").document(subjectID).collection("topics").document(topicID).collection("quizzes").document(quizID).collection("notes").document(newNote.id).setData(encodedNote)
            self.note = newNote
        } catch {
            print("Error adding note: \(error.localizedDescription)")
        }
    }
    
    func setHasNote(value: Bool, subjectID: String, topicID: String, quizID: String) async {
        do {
            let quizRef = db.collection("users")
                .document(userID!)
                .collection("subjects")
                .document(subjectID)
                .collection("topics")
                .document(topicID)
                .collection("quizzes")
                .document(quizID)
            
            try await quizRef.updateData(["hasNote": value])
        } catch {
            print("Error updating hasNote value: \(error.localizedDescription)")
        }
    }

    func fetchNote(subjectID: String, topicID: String, quizID: String) async {
        do {
            let noteRef = db.collection("users").document(userID!).collection("subjects").document(subjectID).collection("topics").document(topicID).collection("quizzes").document(quizID).collection("notes").limit(to: 1)
            
            let snapshot = try await noteRef.getDocuments()
            guard let document = snapshot.documents.first else {
                print("No notes found")
                return
            }
            
            let note = try document.data(as: Note.self)
            self.note = note
        } catch {
            print("Error fetching note: \(error.localizedDescription)")
        }
    }
    
    func deleteNote(subjectID: String, topicID: String, quizID: String) async {
        do {
            try await db.collection("users").document(userID!).collection("subjects").document(subjectID).collection("topics").document(topicID).collection("quizzes").document(quizID).collection("notes").document(self.note!.id).delete()
            self.note = nil
        } catch {
            print("Error deleting note: \(error.localizedDescription)")
        }
        
        await setHasNote(value: false, subjectID: subjectID, topicID: topicID, quizID: quizID)
        
        let quizIndex = self.quizzes.firstIndex(where: {$0.id == quizID})!
        var mutableQuiz = self.quizzes[quizIndex]
        mutableQuiz.hasNote = false
        self.quizzes[quizIndex] = mutableQuiz
    }
}
