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
    @State private var tempQuiz = true
    @State private var currQuiz = "New topic"
    @State private var showSettings = false
    @State private var rotationAngle: Double = 0
    @State private var difficulty: Difficulty = .medium
    @State private var filteredMessages: [OpenAIMessage] = []
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.primary)
                            .shadow(radius: 50)
                            .frame(width: 55, height: 55)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 2))
                    }
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            rotationAngle += 90
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showSettings.toggle()
                        }
                    } label: {
                        Image(systemName: showSettings ? "gearshape.fill" : "gearshape")
                            .rotationEffect(.degrees(rotationAngle))
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.primary)
                            .shadow(radius: 50)
                            .frame(width: 55, height: 55)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .popover(isPresented: $showSettings, content: {
                        TopicSettingsMenuView(tempQuiz: $tempQuiz)
                    })
                    
                    Spacer()
                    
                    Text(currQuiz)
                        .font(.system(size: 32, weight: .medium))
                        .padding(.trailing, 16)
                }
                .padding(.top, 32)
                
                Spacer()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(filteredMessages, id: \.content) { message in
                            Text(message.content)
                                .frame(width: UIScreen.main.bounds.width - 70)
                                .padding()
                                .background(message.role == .user ? Color(hex: "34373B") : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .foregroundStyle(Color("BGCFlipped"))
                        }
                    }
                }
                .padding(.bottom, 2)
                
                if openAIViewModel.isNotIntialised() {
                    Picker("Difficulty", selection: $difficulty) {
                        ForEach(Difficulty.allCases) { diff in
                            Text(diff.rawValue.capitalizedFirst)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
                
                HStack {
                    Group {
                        if openAIViewModel.isNotIntialised() {
                            TextInputView(textInput: $openAIViewModel.userResponse, prompt: "Enter a topic to revise...")
                        } else {
                            TextInputView(textInput: $openAIViewModel.userResponse, prompt: "Enter your answer...")
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 2))
                                        
                    Button {
                        if openAIViewModel.isNotIntialised() {
                            currQuiz = openAIViewModel.userResponse.lowercased().capitalizedFirst
                            openAIViewModel.initialiseQuiz(difficulty: difficulty)

                            openAIViewModel.generateQuestion {
                                openAIViewModel.userResponse = ""
                                filteredMessages.append(openAIViewModel.messages.last!)
                            }
                            
                        } else {
                            // add user's answer to previous question to view
                            let userMessage = OpenAIMessage(role: .user, content: openAIViewModel.userResponse)
                            filteredMessages.append(userMessage)
                            
                            // add AI analysis on previous question to view
                            openAIViewModel.performAnalysisOnUserResponse {
                                filteredMessages.append(openAIViewModel.messages.last!)
                                openAIViewModel.userResponse = ""
                                
                                // generate new question and add to view
                                openAIViewModel.generateQuestion {
                                    filteredMessages.append(openAIViewModel.messages.last!)
                                }
                            }
                        }
                        
                    } label: {
                        if openAIViewModel.isLoading {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(Color.white)
                                .shadow(radius: 50)
                                .frame(width: 55, height: 55)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.trailing, 16)
                        } else {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(Color.white)
                                .shadow(radius: 50)
                                .frame(width: 55, height: 55)
                                .background(.teal)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.trailing, 16)
                        }
                    }
                    .disabled(openAIViewModel.isLoading)
                }
                .padding(.bottom, 100)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

