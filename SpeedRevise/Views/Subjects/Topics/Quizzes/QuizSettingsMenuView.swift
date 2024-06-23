//
//  TopicSettingsMenuView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 11/06/2024.
//

import SwiftUI

struct QuizSettingsMenuView: View {
    @Binding var tempQuiz: Bool
    @State var disableTempQuiz: Bool
    @EnvironmentObject private var openAIViewModel: OpenAIViewModel
    
    var body: some View {
        VStack {
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
            
            if !tempQuiz {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundStyle(openAIViewModel.filteredMessages.count < 2 ? .gray : Color("BGCFlipped"))
                        .font(.system(size: 20, weight: .medium))
                    
                    Text("Save and exit")
                        .foregroundStyle(openAIViewModel.filteredMessages.count < 2 ? .gray : Color("BGCFlipped"))
                    
                    Spacer()
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width - 70, height: 70)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onTapGesture {
                    guard openAIViewModel.filteredMessages.count >= 2 else {
                        return
                    }
                    
                    // code to save and exit here right now
                    return
                }
            }
        }
        .presentationCompactAdaptation(.popover)
    }
}
