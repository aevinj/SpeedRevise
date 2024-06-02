//
//  SpeedReviseApp.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 28/05/2024.
//

import SwiftUI
import Firebase

@main
struct SpeedReviseApp: App {
    @StateObject var authViewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
