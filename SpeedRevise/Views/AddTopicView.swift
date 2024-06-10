//
//  AddTopicView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 09/06/2024.
//

import SwiftUI

struct AddTopicView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var openAIViewModel = OpenAIViewModel()
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
    
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(openAIViewModel.messages, id: \.content) { message in
                                HStack {
                                    if message.role == "assistant" {
                                        Spacer()
                                    }
                                    
                                    Text(message.role == "user" ? "You: \(message.content)" : "Assistant: \(message.content)")
                                        .padding()
                                        .background(message.role == "user" ? Color.blue.opacity(0.2) : Color.green.opacity(0.2))
                                        .cornerRadius(10)
                                    
                                    if message.role == "user" {
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
    
                    HStack {
                        TextInputView(textInput: $openAIViewModel.userResponse, prompt: "Enter a topic to revise...")
                            .padding(.trailing, 2)
    
                        Button {
                            openAIViewModel.sendMessage(content: openAIViewModel.userResponse)
                            openAIViewModel.userResponse = ""
                        } label: {
                            Image(systemName: "chevron.right")
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
                    .padding(.bottom, 100)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
}

#Preview {
    AddTopicView()
}
