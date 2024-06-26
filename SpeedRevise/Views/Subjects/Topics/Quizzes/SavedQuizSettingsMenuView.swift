//
//  SavedQuizSettingsMenuView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 26/06/2024.
//

import SwiftUI

struct SavedQuizSettingsMenuView: View {
    @EnvironmentObject private var subjectViewModel: SubjectViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showLoading: Bool = false
    @Binding var quizDeleted: Bool
    
    let currTopicID: String
    let currSubjectID: String
    let currQuiz: Quiz
    
    var body: some View {
        HStack {
            if !showLoading {
                Image(systemName: "trash")
                    .foregroundStyle(Color.red)
                    .font(.system(size: 20, weight: .medium))
                
                Text("Delete \(currQuiz.name.capitalizedFirst)?")
                    .foregroundStyle(Color.red)
            } else {
                ProgressView(label: {
                    Text("")
                    }
                ).progressViewStyle(.circular)
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 70, height: 70)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onTapGesture {
            Task {
                showLoading = true
                await subjectViewModel.deleteQuiz(subjectID: currSubjectID, topicID: currTopicID, quizID: currQuiz.id)
                showLoading = false
                quizDeleted = true
                dismiss()
            }
        }
        .presentationCompactAdaptation(.popover)
    }
}

