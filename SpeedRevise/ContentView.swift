//
//  ContentView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 28/05/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var subjectViewModel: SubjectViewModel
    
    var body: some View {
        if authViewModel.userSession != nil {
            LoggedInView()
                .onAppear {
                    subjectViewModel.updateUserID()
                    subjectViewModel.fetchSubjects()
                    subjectViewModel.topics = []
                    subjectViewModel.quizzes = []
                }
        } else {
            LogInView()
                .onAppear {
                    authViewModel.userSession = nil
                    authViewModel.currentUser = nil
                }
        }
    }
}
