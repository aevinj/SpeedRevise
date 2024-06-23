//
//  AddSubjectView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 08/06/2024.
//

import SwiftUI

struct AddSubjectView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var subjectViewModel: SubjectViewModel
    @State private var subjectName: String = ""

    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            Image("leaves")
                .renderingMode(.template)
                .foregroundStyle(colorScheme == .dark ? Color(hex: "34373B") : Color(hex: "E6E6E6"))
            
            VStack {
                Spacer()
                
                TextInputView(textInput: $subjectName, prompt: "Subject name")
                
                Spacer()
                
                Button {
                    Task {
                        await subjectViewModel.addSubject(name: subjectName)
                        dismiss()
                    }
                } label: {
                    Text("Add subject")
                        .frame(width: UIScreen.main.bounds.width - 70, height: 70)
                        .background(Color.primary)
                        .foregroundStyle(Color.background)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
                .padding(.bottom, 100)
            }
        }
        
    }
}

#Preview {
    AddSubjectView()
}
