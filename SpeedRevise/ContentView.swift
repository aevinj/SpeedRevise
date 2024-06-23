//
//  ContentView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 28/05/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var subjectViewModel: SubjectViewModel = SubjectViewModel()
    
    var body: some View {
        Group {
            if authViewModel.userSession != nil {
                LoggedInView()
                    .environmentObject(subjectViewModel)
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
}
