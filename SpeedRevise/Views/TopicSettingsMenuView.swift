//
//  TopicSettingsMenuView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 11/06/2024.
//

import SwiftUI

struct TopicSettingsMenuView: View {
    @Binding var tempQuiz: Bool
    @State var disableTempQuiz: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: "ellipsis.message")
                .foregroundStyle(disableTempQuiz ? .gray : Color("BGCFlipped"))
                .font(.system(size: 20, weight: .medium))
            
            Text("Temporary Quiz")
                .foregroundStyle(disableTempQuiz ? .gray : Color("BGCFlipped"))
            
            Spacer()
            
            Toggle(isOn: $tempQuiz) {
                Text("")
            }
            .labelsHidden()
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            .disabled(disableTempQuiz)
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 70, height: 70)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onTapGesture {
            guard !disableTempQuiz else {
                return
            }
            tempQuiz.toggle()
        }
        .presentationCompactAdaptation(.popover)
    }
}
