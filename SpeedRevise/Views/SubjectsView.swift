//
//  SubjectsView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 06/06/2024.
//

import SwiftUI

struct SubjectsView: View {
    private var subjectCount: Int = 0
    @EnvironmentObject var subjectViewModel: SubjectViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                Image("leaves")
                    .renderingMode(.template)
                    .foregroundStyle(colorScheme == .dark ? Color(hex: "34373B") : Color(hex: "E6E6E6"))
                
                VStack {
                    HStack {
                        Text("My Subjects")
                            .font(.system(size: 32, weight: .regular))
                            .padding(EdgeInsets(top: 32, leading: 32, bottom: 0, trailing: 0))
                        
                        Spacer()
                    }	
                    
                    if subjectViewModel.subjects.isEmpty {
                        NoSubjectsView()
                    } else {
                        SubjectsExistingView()
                    }
                }
            }
        }
    }
}

#Preview {
    SubjectsView()
}
