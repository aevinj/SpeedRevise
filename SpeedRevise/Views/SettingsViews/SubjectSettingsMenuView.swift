//
//  SubjectSettingsMenuView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 17/06/2024.
//

import SwiftUI

struct SubjectSettingsMenuView: View {
    @EnvironmentObject private var subjectViewModel: SubjectViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showLoading: Bool = false
    var currSubject: Subject
    
    var body: some View {
        HStack {
            if !showLoading {
                Image(systemName: "trash")
                    .foregroundStyle(Color.red)
                    .font(.system(size: 20, weight: .medium))
                
                Text("Delete \(currSubject.name.capitalizedFirst)?")
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
                await subjectViewModel.deleteSubject(subjectID: currSubject.id)
                showLoading = false
                dismiss()
            }
        }
        .presentationCompactAdaptation(.popover)
    }
}

