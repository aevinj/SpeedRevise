//
//  ContentView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 28/05/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.userSession != nil {
                LoggedInView()
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
                    
                    FolderView()
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

struct FolderView: View {
    var body: some View {
        Text("Folder View")
            .font(.largeTitle)
            .foregroundColor(.primary)
    }
}

#Preview {
    ContentView()
}
