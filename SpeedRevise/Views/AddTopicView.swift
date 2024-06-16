//
//  AddTopicView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 16/06/2024.
//

import SwiftUI

struct AddTopicView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var subjectViewModel: SubjectViewModel
    @State var currSubjectID: String
    @State private var topicName: String = ""
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            Image("leaves")
                .renderingMode(.template)
                .foregroundStyle(colorScheme == .dark ? Color(hex: "34373B") : Color(hex: "E6E6E6"))
            
            VStack {
                Spacer()
                
                TextInputView(textInput: $topicName, prompt: "Topic name")
                
                Spacer()
                
                Button {
                    Task {
                        await subjectViewModel.addTopic(subjectID: currSubjectID, topicName: topicName)
                        dismiss()
                    }
                } label: {
                    Text("Add topic")
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
