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

struct LoggedInView: View {
    @State private var selectedTab: Tab = .house
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tag(Tab.house)
                    
                    SubjectsView()
                        .tag(Tab.folder)
                    
                    ProfileView()
                        .tag(Tab.person)
                }
            }
            VStack {
                Spacer()
                NavBarView(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    ContentView()
}
