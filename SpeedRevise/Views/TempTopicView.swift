//
//  TempTopicView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 13/06/2024.
//

import SwiftUI

struct TempTopicView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var openAIViewModel: OpenAIViewModel
    @State var quizName: String
    @State private var tempQuiz: Bool = true
    @State private var showSettings: Bool = false
    @State private var rotationAngle: Double = 0
    @State private var difficulty: Difficulty = .medium
    @State private var quizFinished: Bool = false
    @State private var questionCountLimit: Int = 3
    
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
                        showSettings.toggle()
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
                        QuizSettingsMenuView(tempQuiz: .constant(true), disableTempQuiz: true, openAIViewModel: openAIViewModel)
                    })
                    
                    Spacer()
                    
                    Text(quizName)
                        .font(.system(size: 32, weight: .medium))
                        .padding(.trailing, 16)
                }
                .padding(.top, 32)
                
                Spacer()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(openAIViewModel.filteredMessages, id: \.id) { message in
                            Text(message.content)
                                .frame(width: UIScreen.main.bounds.width - 70)
                                .padding()
                                .background(message.role == .user ? Color(hex: "34373B") : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .foregroundStyle(Color("BGCFlipped"))
                        }
                    }
                }
                .padding(.bottom, 5)
                
                if quizFinished {
                        Button {
                            dismiss()
                        } label: {
                            Text("Discard")
                                .foregroundStyle(Color("BGCFlipped"))
                                .font(.system(size: 20, weight: .medium))
                                .frame(width: UIScreen.main.bounds.width - 70, height: 50)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.bottom, 100)
                        }
                } else {
                    Button {
                        openAIViewModel.filteredMessages.append(FilteredMessage(role: .user, content: "I'm not sure."))
                        openAIViewModel.userUnsureOfAnswer {
                            let answer = openAIViewModel.messages.last!.content
                            openAIViewModel.userResponse = ""
                            
                            if openAIViewModel.filteredMessages.filter({!($0.isQuestion)}).count >= questionCountLimit {
                                openAIViewModel.filteredMessages.append(FilteredMessage(role: .assistant, content: answer))
                                quizFinished = true
                                return
                            }
                            
                            openAIViewModel.generateQuestion {
                                let newQuestion = openAIViewModel.messages.last!.content
                                openAIViewModel.filteredMessages.append(FilteredMessage(role: .assistant, content: "\(answer)\n\n\(newQuestion)", isQuestion: true))
                            }
                        }
                    } label: {
                        Text("I'm not sure")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color("BGCFlipped"))
                            .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 2, trailing: 16))
                    }
                    
                    HStack {
                        TextInputView(textInput: $openAIViewModel.userResponse, prompt: "Enter your answer...")
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 2))
                                            
                        Button {
                            // add user's answer to previous question to view
                            openAIViewModel.filteredMessages.append(FilteredMessage(role: .user, content: openAIViewModel.userResponse))
                            
                            // add AI analysis on previous question to view
                            openAIViewModel.performAnalysisOnUserResponse {
                                let analysis = openAIViewModel.messages.last!.content
                                openAIViewModel.userResponse = ""
                                
                                if openAIViewModel.filteredMessages.filter({!($0.isQuestion)}).count >= questionCountLimit {
                                    openAIViewModel.filteredMessages.append(FilteredMessage(role: .assistant, content: analysis))
                                    quizFinished = true
                                    return
                                }
                                
                                // generate new question and add to view
                                openAIViewModel.generateQuestion {
                                    let newQuestion = openAIViewModel.messages.last!.content
                                    openAIViewModel.filteredMessages.append(FilteredMessage(role: .assistant, content: "\(analysis)\n\n\(newQuestion)", isQuestion: true))
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
        }
    }
}
