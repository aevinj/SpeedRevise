//
//  ContentView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 28/05/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var subjectViewModel: SubjectViewModel
    @StateObject private var navBarController: NavBarController = NavBarController()
    
    var body: some View {
        if authViewModel.userSession != nil {
            LoggedInView()
                .onAppear {
                    subjectViewModel.updateUserID()
                    subjectViewModel.fetchSubjects()
                    subjectViewModel.topics = []
                    subjectViewModel.quizzes = []
                }
                .environmentObject(navBarController)
        } else {
            LogInView()
                .onAppear {
                    authViewModel.userSession = nil
                    authViewModel.currentUser = nil
                }
        }
    }
}
