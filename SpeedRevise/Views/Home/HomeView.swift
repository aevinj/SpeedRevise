//
//  HomeView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 29/05/2024.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var notificationCount: Int = 1
    @State private var tempQuizEntry: String = ""
    @State private var shouldNavigate: Bool = false
    @EnvironmentObject private var openAIViewModel: OpenAIViewModel
    @State private var filteredMessages: [FilteredMessage] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                VStack {
                    Image("leaves")
                        .renderingMode(.template)
                        .foregroundStyle(colorScheme == .dark ? Color(hex: "34373B") : Color(hex: "E6E6E6"))
                    
                    Spacer()
                }
                .padding(.top, 50)
                .ignoresSafeArea()
                
                VStack {
                    HStack {
                        VStack {
                            Text("Hello,")
                                .font(.system(size: 30, weight: .regular))
                                .foregroundStyle(.gray)
                            
                            Text(authViewModel.currentUser?.firstName.capitalizedFirst ?? "None")
                                .font(.system(size: 32, weight: .regular))
                                .foregroundStyle(Color.primary)
                                .padding(.leading, 72)
                        }
                        .padding()
                        
                        Spacer()
                        
                        Button(action: {}, label: {
                            Image(systemName: notificationCount > 0 ? "bell.badge.fill" : "bell.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color.blue, colorScheme == .dark ? Color.white : Color.black)
                                .font(.system(size: 24))
                                .foregroundStyle(Color.primary)
                                .shadow(radius: 70)
                                .frame(width: 64, height: 64)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.trailing, 32)
                        })
                    }
                    
                    Spacer()
                    
                }
                
                ZStack {
                    VStack {
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 50.0)
                            .fill(.ultraThinMaterial)
                            .frame(width: UIScreen.main.bounds.width, height: 575)
                    }
                    .ignoresSafeArea()
                    
                    VStack {
                        HStack {
                            Text("Overview")
                                .font(.system(size: 30, weight: .regular))
                                .foregroundStyle(Color("BGCFlipped"))
                                .padding(EdgeInsets(top: 0, leading: 45, bottom: 10, trailing: 0))
                            
                            Spacer()
                        }
                        
                        HStack {
                            HStack {
                                Image(systemName: "square.and.pencil")
                                    .foregroundStyle(Color.blue)
                                    .font(.system(size: 22, weight: .bold))
                                    .padding(.leading, 25)
                                
                                TextField("", text: $tempQuizEntry, prompt: Text("Enter topic...").font(.system(size: 20)).foregroundStyle(Color(.systemGray)))
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                                    .fontWeight(.medium)
                                    .padding(.leading, 5)
                            }
                            .frame(width: UIScreen.main.bounds.width-120, height: 60)
                            .background(colorScheme == .dark ? Color(hex: "34373B") : Color(hex: "E6E6E6"))
                            .cornerRadius(10)
                            
                            NavigationLink {
                                QuizView(quizName: tempQuizEntry, tempQuiz: true, disableTempChoice: true)
                                    .navigationBarBackButtonHidden(true)
                                    .onAppear {
                                        openAIViewModel.initialiseQuiz(difficulty: .medium, desiredTopic: tempQuizEntry)
                                        tempQuizEntry = ""
                                        
                                        openAIViewModel.generateQuestion {
                                            openAIViewModel.filteredMessages.append(FilteredMessage(from: openAIViewModel.messages.last!, isQuestion: true))
                                            openAIViewModel.userResponse = ""
                                        }
                                    }
                            } label: {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(Color(.systemGray))
                                    .shadow(radius: 50)
                                    .frame(width: 60, height: 60)
                                    .background(colorScheme == .dark ? Color(hex: "34373B") : Color(hex: "E6E6E6"))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .padding(.bottom, 10)
                        
                        Group {}
                            .padding(.bottom, 100)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
