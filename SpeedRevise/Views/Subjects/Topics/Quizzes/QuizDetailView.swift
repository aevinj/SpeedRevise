//
//  QuizDetailView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 21/06/2024.
//

import SwiftUI

struct QuizDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    var currQuiz: Quiz
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                Image("leaves")
                    .renderingMode(.template)
                    .foregroundStyle(colorScheme == .dark ? Color(hex: "34373B") : Color(hex: "E6E6E6"))
                
                Spacer()
            }
            
            
        }
    }
}
