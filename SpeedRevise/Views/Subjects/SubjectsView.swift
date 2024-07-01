//
//  SubjectsView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 06/06/2024.
//

import SwiftUI

struct SubjectsView: View {
    @EnvironmentObject private var subjectViewModel: SubjectViewModel
//    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
//                Image("leaves")
//                    .renderingMode(.template)
//                    .foregroundStyle(colorScheme == .dark ? Color(hex: "34373B") : Color(hex: "E6E6E6"))
                
                if subjectViewModel.subjects.isEmpty {
                    NoSubjectsView()
                } else {
                    SubjectsExistingView()
                }
            }
        }
    }
}

#Preview {
    SubjectsView()
}
