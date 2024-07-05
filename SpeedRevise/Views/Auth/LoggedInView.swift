//
//  LoggedInView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 23/06/2024.
//

import SwiftUI

struct LoggedInView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @StateObject private var homePathManager: NavigationPathManager = NavigationPathManager()
    @StateObject private var subjectPathManager: NavigationPathManager = NavigationPathManager()
//    @StateObject private var profilePathManager: NavigationPathManager = NavigationPathManager()
    @EnvironmentObject private var navBarController: NavBarController
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    //TODO: tidy this up - unnecesarry zstack and possibly vstack
    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $navBarController.selectedTab) {
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
        }
    }
}
