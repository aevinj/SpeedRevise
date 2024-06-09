//
//  AddTopicView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 09/06/2024.
//

import SwiftUI

struct AddTopicView: View {
    @Environment(\.dismiss) var dismiss
    @State var prompt: String = ""
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("New topic")
                        .font(.system(size: 32, weight: .medium))
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color("BGCFlipped"))
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.primary)
                            .shadow(radius: 50)
                            .frame(width: 55, height: 55)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.trailing, 16)
                    }
                }
                .padding(EdgeInsets(top: 32, leading: 32, bottom: 0, trailing: 0))
                
                Spacer()
                
                TextInputView(textInput: $prompt, prompt: "Enter a topic to revise...")
                    .padding(.bottom, 100)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AddTopicView()
}
