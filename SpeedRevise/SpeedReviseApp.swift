//
//  SpeedReviseApp.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 28/05/2024.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
}

/// authViewModel - used for controlling user authentication & logging in/out
/// openAIViewModel - used for controlling GPT message generations
/// subjectViewModel  - used for accessing saved data subjects on backend
@main
struct SpeedReviseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel: AuthViewModel = AuthViewModel()
    @StateObject var openAIViewModel: OpenAIViewModel = OpenAIViewModel()
    @StateObject var subjectViewModel: SubjectViewModel = SubjectViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(openAIViewModel)
                .environmentObject(subjectViewModel)
        }
    }
}
