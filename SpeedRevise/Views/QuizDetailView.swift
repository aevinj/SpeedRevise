//
//  QuizDetailView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 21/06/2024.
//

import SwiftUI

struct QuizDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Text("Quiz detail view!")
            .onTapGesture {
                dismiss()
            }
    }
}

#Preview {
    QuizDetailView()
}
