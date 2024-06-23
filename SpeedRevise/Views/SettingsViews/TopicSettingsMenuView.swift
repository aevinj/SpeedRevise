//
//  TopicSettingsMenuView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 17/06/2024.
//

import SwiftUI

struct TopicSettingsMenuView: View {
    @EnvironmentObject private var subjectViewModel: SubjectViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showLoading: Bool = false
    @Binding var topicDeleted: Bool
    var currTopic: Topic
    let currSubjectID: String
    
    var body: some View {
        HStack {
            if !showLoading {
                Image(systemName: "trash")
                    .foregroundStyle(Color.red)
                    .font(.system(size: 20, weight: .medium))
                
                Text("Delete \(currTopic.name.capitalizedFirst)?")
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
                await subjectViewModel.deleteTopic(subjectID: currSubjectID, topicID: currTopic.id)
                showLoading = false
                topicDeleted = true
                dismiss()
            }
        }
        .presentationCompactAdaptation(.popover)
    }
}
