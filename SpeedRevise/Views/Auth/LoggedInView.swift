//
//  LoggedInView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 23/06/2024.
//

import SwiftUI

struct LoggedInView: View {
    @State private var selectedTab: Tab = .house
    @EnvironmentObject private var authViewModel: AuthViewModel
    @StateObject private var homePathManager: NavigationPathManager = NavigationPathManager()
    @StateObject private var subjectPathManager: NavigationPathManager = NavigationPathManager()
//    @StateObject private var profilePathManager: NavigationPathManager = NavigationPathManager()
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .environmentObject(homePathManager)
                        .tag(Tab.house)
                    
                    SubjectsView()
                        .environmentObject(subjectPathManager)
                        .tag(Tab.folder)
                    
                    ProfileView()
//                        .environmentObject(profilePathManager)
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
