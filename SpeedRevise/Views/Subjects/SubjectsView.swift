//
//  SubjectsExistingView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 08/06/2024.
//

import SwiftUI

struct SubjectsView: View {
    @EnvironmentObject private var subjectViewModel: SubjectViewModel
    @EnvironmentObject private var openAIViewModel: OpenAIViewModel
    @EnvironmentObject private var navigationPathManager: NavigationPathManager
    @EnvironmentObject private var navBarController: NavBarController
    @State private var showAddSubject: Bool = false
    @State private var slideAnimationOffset: CGFloat = 1000
    @State private var darkenBGAnimationOffset: Double = 0
    @State private var subjectName: String = ""
    
    var body: some View {
        NavigationStack(path: $navigationPathManager.path) {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("My Subjects")
                            .font(.system(size: 32, weight: .regular))
                            .padding(.leading, 20)
                        
                        Spacer()
                        
                        Button {
                            showAddSubject = true
                        } label: {
                            Image(systemName: "plus.square.dashed")
                                .foregroundStyle(.green)
                                .font(.system(size: 45))
                                .padding(.trailing, 20)
                        }
                    }
                    .padding(.top, 32)
                    
                    if !subjectViewModel.subjects.isEmpty {
                        List {
                            ForEach(subjectViewModel.subjects) { subject in
                                HStack {
                                    Image(systemName: "folder.fill")
                                        .font(.system(size: 40, weight: .medium))
                                        .foregroundStyle(Color("BGCFlipped"))
                                        .padding()
                                    
                                    VStack(alignment: .leading) {
                                        Text(subject.name.capitalizedFirst)
                                            .font(.system(size: 20))
                                            .foregroundStyle(Color("BGCFlipped"))
                                        
                                        Text("Implement last accessed")
                                            .font(.system(size: 14))
                                            .foregroundStyle(Color(.systemGray))
                                    }
                                    
                                    Spacer()
                                }
                                .overlay {
                                    Button {
                                        navigationPathManager.path.append(subject)
                                    } label: {
                                        EmptyView()
                                    }.opacity(0)
                                }
                                .listRowBackground(
                                    Rectangle()
                                        .background(.ultraThinMaterial)
                                        .opacity(0.1)
                                )
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    let currSubject = subjectViewModel.subjects[index]
                                    
                                    Task {
                                        await subjectViewModel.deleteSubject(subjectID: currSubject.id)
                                    }
                                    
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                    } else {
                        ContentUnavailableView {
                            Label("No Subjects", systemImage: "questionmark.folder")
                        } description: {
                            Text("When you add new subjects, they will appear here.")
                        }
                        .padding(.bottom, 100)
                    }
                    
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    
                    NavBarView(selectedTab: $navBarController.selectedTab)
                }
                .padding(.bottom, 30)
                .ignoresSafeArea()
                
                if showAddSubject {
                    ZStack {
                        Color(.black)
                            .ignoresSafeArea()
                            .opacity(darkenBGAnimationOffset)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.5)) {
                                    slideAnimationOffset = 1000
                                    darkenBGAnimationOffset = 0
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    showAddSubject = false
                                }
                                subjectName = ""
                            }
                        
                        VStack {
                            Text("New Subject")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundStyle(Color("BGCFlipped"))
                                .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                            
                            TextInputView(textInput: $subjectName, prompt: "Maths")
                                .padding(.bottom, 32)
                            
                            Button {
                                Task {
                                    await subjectViewModel.addSubject(name: subjectName)
                                    subjectName = ""
                                }
                                withAnimation(.spring(response: 0.5)) {
                                    slideAnimationOffset = 1000
                                    darkenBGAnimationOffset = 0
                                    
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    showAddSubject = false
                                }
                            } label: {
                                Text("Add Subject")
                                    .font(.system(size: 20, weight: .medium))
                                    .frame(width: 200, height: 60)
                                    .foregroundStyle(Color("BackgroundColor"))
                                    .background(subjectName.count == 0 ? Color.gray : Color("BGCFlipped"))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .disabled(subjectName.count == 0)
                        }
                        .frame(width: UIScreen.main.bounds.width - 50, height: 275)
                        .background(Color("BackgroundColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay {
                            VStack{
                                HStack {
                                    Spacer()
                                    
                                    Button {
                                        withAnimation(.spring(response: 0.5)) {
                                            slideAnimationOffset = 1000
                                            darkenBGAnimationOffset = 0
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                            showAddSubject = false
                                        }
                                        subjectName = ""
                                    } label: {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 25, weight: .bold))
                                            .foregroundStyle(Color("BGCFlipped"))
                                            .padding(EdgeInsets(top: 25, leading: 0, bottom: 0, trailing: 25))
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                        .shadow(radius: 20)
                        .offset(x: 0, y: slideAnimationOffset)
                        .onAppear {
                            withAnimation(.spring()) {
                                slideAnimationOffset = 0
                                darkenBGAnimationOffset = 0.5
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: Subject.self) { subject in
                SubjectDetailView(currSubject: subject)
                    .onAppear {
                        subjectViewModel.fetchTopics(subjectID: subject.id)
                    }
                    .navigationBarBackButtonHidden(true)
            }
            .navigationDestination(for: TopicDetailViewArguments.self) { topicDetailViewArguments in
                TopicDetailView(currTopic: topicDetailViewArguments.currTopic, currSubjectID: topicDetailViewArguments.currSubjectID)
                    .navigationBarBackButtonHidden(true)
                    .onAppear {
                        subjectViewModel.fetchQuizzes(subjectID: topicDetailViewArguments.currSubjectID, topicID: topicDetailViewArguments.currTopic.id)
                    }
                    .onDisappear {
                        openAIViewModel.reset()
                    }
            }
            .navigationDestination(for: QuizViewArguments.self) { quizViewArguments in
                QuizView(quizName: quizViewArguments.quizName, disableTempChoice: quizViewArguments.disableTempChoice, currSubjectID: quizViewArguments.currSubjectID, currTopicID: quizViewArguments.currTopicID, useOnAppear: quizViewArguments.useOnAppear)
                    .navigationBarBackButtonHidden(true)
            }
            .navigationDestination(for: QuizDetailViewArguments.self) { quizDetailViewArguments in
                QuizDetailView(currQuiz: quizDetailViewArguments.currQuiz, currTopicID: quizDetailViewArguments.currTopicID, currSubjectID: quizDetailViewArguments.currSubjectID)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}
