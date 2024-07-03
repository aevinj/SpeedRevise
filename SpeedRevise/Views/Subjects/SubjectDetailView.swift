//
//  SubjectDetailView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 08/06/2024.
//

import SwiftUI

struct TopicDetailViewArguments: Hashable {
    let currTopic: Topic
    let currSubjectID: String
}

struct SubjectDetailView: View {
    @EnvironmentObject private var subjectViewModel: SubjectViewModel
    @EnvironmentObject private var openAIViewModel: OpenAIViewModel
    @EnvironmentObject private var navigationPathManager: NavigationPathManager
    @State private var rotationAngle: Double = 0
    @State private var showSettings: Bool = false
    @State private var subjectDeleted: Bool = false
    @State private var showAddTopic: Bool = false
    @State private var darkenBGAnimationOffset: Double = 0
    @State private var slideAnimationOffset: CGFloat = 1000
    @State private var topicName: String = ""
    let currSubject: Subject
    
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
                            .foregroundStyle(Color("BGCFlipped"))
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.primary)
                            .shadow(radius: 50)
                            .frame(width: 55, height: 55)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.trailing, 2)
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
                        SubjectSettingsMenuView(subjectDeleted: $subjectDeleted, currSubject: currSubject)
                            .onDisappear {
                                if subjectDeleted {
                                    navigationPathManager.path.removeLast()
                                }
                            }
                    })
                    
                    Spacer()
                    
                    Text(currSubject.name.capitalizedFirst)
                        .font(.system(size: 40, weight: .medium))
                        .padding(.trailing, 20)
                }
                .padding(EdgeInsets(top: 32, leading: 20, bottom: 0, trailing: 0))
                
                HStack {
                    Text("My Topics")
                        .font(.system(size: 30, weight: .regular))
                        .foregroundStyle(Color("BGCFlipped"))
                        .padding(EdgeInsets(top: 24, leading: 24, bottom: 10, trailing: 0))
                    
                    Spacer()
                    
                    Button {
                        showAddTopic = true
                    } label: {
                        Image(systemName: "plus.square.dashed")
                            .foregroundStyle(.green)
                            .font(.system(size: 45))
                            .padding(.trailing, 20)
                    }
                }
                
                if subjectViewModel.topics.isEmpty {
                    ContentUnavailableView {
                        Label("No Topics", systemImage: "questionmark.folder")
                    } description: {
                        Text("When you add new topics, they will appear here.")
                    }
                    .padding(.bottom, 100)
                } else {
                    List {
                        ForEach(subjectViewModel.topics) { topic in
                            HStack {
                                Image(systemName: "folder.fill")
                                    .font(.system(size: 40, weight: .medium))
                                    .foregroundStyle(Color("BGCFlipped"))
                                    .padding()
                                
                                VStack(alignment: .leading) {
                                    Text(topic.name.capitalizedFirst)
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
                                    let topicDetailViewArguments = TopicDetailViewArguments(currTopic: topic, currSubjectID: currSubject.id)
                                    navigationPathManager.path.append(topicDetailViewArguments)
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
                                let currTopicID = subjectViewModel.topics[index].id
                                
                                Task {
                                    await subjectViewModel.deleteTopic(subjectID: currSubject.id, topicID: currTopicID)
                                }
                                
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .padding(.bottom, 100)
                }
            }
            
            if showAddTopic {
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
                                showAddTopic = false
                            }
                            topicName = ""
                        }
                    
                    VStack {
                        Text("New Topic")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundStyle(Color("BGCFlipped"))
                            .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                        
                        TextInputView(textInput: $topicName, prompt: "Pythagorean Theorem")
                            .padding(.bottom, 32)
                        
                        Button {
                            Task {
                                await subjectViewModel.addTopic(subjectID: currSubject.id, topicName: topicName)
                                topicName = ""
                            }
                            withAnimation(.spring(response: 0.5)) {
                                slideAnimationOffset = 1000
                                darkenBGAnimationOffset = 0
                                
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                showAddTopic = false
                            }
                        } label: {
                            Text("Add Topic")
                                .font(.system(size: 20, weight: .medium))
                                .frame(width: 200, height: 60)
                                .foregroundStyle(Color("BackgroundColor"))
                                .background(topicName.count == 0 ? Color.gray : Color("BGCFlipped"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .disabled(topicName.count == 0)
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
                                        showAddTopic = false
                                    }
                                    topicName = ""
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
    }
}
