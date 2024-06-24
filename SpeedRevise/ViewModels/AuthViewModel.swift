//
//  AuthViewModel.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 01/06/2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel : ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("Failed to log in with error: \(error.localizedDescription)")
        }
    }
    
    func createUser(email: String, password: String, firstName: String, lastName: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, firstName: firstName, lastName: lastName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("ERROR: Failed to create a new user. Error: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("Failed to signout with error: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async -> Bool {
        guard let user = userSession else { return false }
        
        // Delete Firestore user document
        do {
            try await Firestore.firestore().collection("users").document(user.uid).delete()
        } catch {
            print("Failed to delete user data with error: \(error.localizedDescription)")
            return false
        }
        
        // Delete user authentication
        do {
            try await user.delete()
            return true
        } catch {
            print("Failed to delete user account with error: \(error.localizedDescription)")
            return false
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
    }
}
