//
//  TopicDetailView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 23/06/2024.
//

import SwiftUI

struct QuizDetailViewArguments: Hashable {
    let currQuiz: Quiz
    let currTopicID: String
    let currSubjectID: String
}

struct TopicDetailView: View {
    @EnvironmentObject private var navigationPathManager: NavigationPathManager
    @EnvironmentObject private var subjectViewModel: SubjectViewModel
    @EnvironmentObject private var openAIViewModel: OpenAIViewModel
    @State private var rotationAngle: Double = 0
    @State private var showSettings: Bool = false
    @State private var topicDeleted = false
    
    var currTopic: Topic
    let currSubjectID: String
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        navigationPathManager.path.removeLast()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.primary)
                            .shadow(radius: 50)
                            .frame(width: 55, height: 55)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 2))
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
                        TopicSettingsMenuView(topicDeleted: $topicDeleted, currTopic: currTopic, currSubjectID: currSubjectID)
                            .onDisappear {
                                if topicDeleted {
                                    navigationPathManager.path.removeLast()
                                }
                            }
                    })
                    
                    Spacer()
                    
                    Text(currTopic.name.capitalizedFirst)
                        .font(.system(size: 40, weight: .medium))
                        .padding(.trailing, 16)
                }
                .padding(.top, 32)
                
                HStack {
                    Text("My Quizzes")
                        .font(.system(size: 30, weight: .regular))
                        .foregroundStyle(Color("BGCFlipped"))
                        .padding(EdgeInsets(top: 24, leading: 24, bottom: 10, trailing: 0))
                    
                    Spacer()
                    
                    Button {
                        let quizViewArguments = QuizViewArguments(quizName: "Quiz " + String(subjectViewModel.quizzes.count + 1), disableTempChoice: false, currSubjectID: currSubjectID, currTopicID: currTopic.id, useOnAppear: true)
                        navigationPathManager.path.append(quizViewArguments)
                    } label: {
                        Image(systemName: "plus.square.dashed")
                            .foregroundStyle(.green)
                            .font(.system(size: 45))
                            .padding(.trailing, 20)
                    }
                }
                
                if subjectViewModel.quizzes.count > 0 {
                    List {
                        ForEach(subjectViewModel.quizzes) { quiz in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(quiz.name.capitalizedFirst)
                                        .font(.system(size: 20))
                                        .foregroundStyle(Color("BGCFlipped"))
                                    
                                    Text("Created: \(dateFormatter.string(from: quiz.creationDate))")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color(.systemGray))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "note.text")
                                    .font(.system(size: 30, weight: .medium))
                                    .foregroundStyle(Color("BGCFlipped"))
                                    .frame(width: 75, height: 75)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .overlay(content: {
                                Button {
                                    let quizDetailViewArguments = QuizDetailViewArguments(currQuiz: quiz, currTopicID: currTopic.id, currSubjectID: currSubjectID)
                                    navigationPathManager.path.append(quizDetailViewArguments)
                                } label: {
                                    EmptyView()
                                }.opacity(0)
                            })
                            .listRowBackground(
                                Rectangle()
                                    .background(.ultraThinMaterial)
                                    .opacity(0.1)
                            )
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let currQuiz = subjectViewModel.quizzes[index]
                                
                                Task {
                                    await subjectViewModel.deleteQuiz(subjectID: currSubjectID, topicID: currTopic.id, quizID: currQuiz.id)
                                }
                                
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                } else {
                    ContentUnavailableView {
                        Label("No Quizzes", systemImage: "questionmark.folder")
                    } description: {
                        Text("When you generate new quizzes, they will appear here.")
                    }
                    .padding(.bottom, 100)
                }
                
                Spacer()
            }
        }
    }
}
