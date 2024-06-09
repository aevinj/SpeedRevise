//
//  AddTopicView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 09/06/2024.
//

import SwiftUI

struct AddTopicView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Button {
                dismiss()
            } label: {
                Text("Take me back")
            }

        }
    }
}

#Preview {
    AddTopicView()
}
