//
//  ContentView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 28/05/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var subjectViewModel: SubjectViewModel? = nil
    
    var body: some View {
        Group {
            if authViewModel.userSession != nil {
                LoggedInView()
                    .environmentObject(subjectViewModel ?? SubjectViewModel())
                    .onAppear {
                        if subjectViewModel == nil {
                            subjectViewModel = SubjectViewModel()
                        }
                    }
            } else {
                LogInView()
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
