//
//  AuthViewModel.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 01/06/2024.
//

import Foundation
import Firebase

class AuthViewModel : ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        
    }
    
    
    func signIn(email: String, password: String) async throws {
        print("sign in...")
    }
    
    func createUser(email: String, password: String, tempNameAevin: String) async throws {
        print("creating user...")
    }
    
    func signOut() {
        
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
        
    }
}
