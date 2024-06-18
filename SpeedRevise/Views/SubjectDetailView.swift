//
//  SubjectDetailView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 08/06/2024.
//

import SwiftUI

struct SubjectDetailView: View {
    @EnvironmentObject var subjectViewModel: SubjectViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var rotationAngle: Double = 0
    @State private var showSettings: Bool = false
    var currSubject: Subject
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            Image("leaves")
                .renderingMode(.template)
                .foregroundStyle(colorScheme == .dark ? Color(hex: "34373B") : Color(hex: "E6E6E6"))
            
            VStack {
                HStack {
                    Text(currSubject.name.capitalizedFirst)
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
                            .padding(.trailing, 35)
                    }
                    .popover(isPresented: $showSettings, content: {
                        SubjectSettingsMenuView(currSubject: currSubject)
                    })
                }
                .padding(EdgeInsets(top: 32, leading: 32, bottom: 0, trailing: 0))
                
                if subjectViewModel.topics.isEmpty {
                    NoTopicsView(currSubjectID: currSubject.id)
                } else {
                    ExistingTopicsView(currSubjectID: currSubject.id)
                }
            }
        }
    }
}

struct TopicDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var rotationAngle: Double = 0
    @State private var showSettings: Bool = false
    var currTopic: Topic
    var currSubjectID: String
    
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                Image("leaves")
                    .renderingMode(.template)
                    .foregroundStyle(colorScheme == .dark ? Color(hex: "34373B") : Color(hex: "E6E6E6"))
                
                Spacer()
            }
            
            VStack {
                HStack {
                    Text(currTopic.name.capitalizedFirst)
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
                            .padding(.trailing, 35)
                    }
                    .popover(isPresented: $showSettings, content: {
                        TopicSettingsMenuView(currTopic: currTopic, currSubjectID: currSubjectID)
                    })
                }
                .padding(EdgeInsets(top: 32, leading: 32, bottom: 5, trailing: 0))
                
                HStack {
                    NavigationLink {
                        NewQuizView()
                    } label: {
                        Text("New Quiz")
                            .frame(width: 120, height: 120)
                            .background(Color.primary)
                            .foregroundStyle(Color.background)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.trailing, 10)
                    
                    Button {
                        
                    } label: {
                        Text("New Note")
                            .frame(width: 120, height: 120)
                            .background(Color.primary)
                            .foregroundStyle(Color.background)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding()
                
                Spacer()
            }
            
            ZStack {
                VStack {
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 50.0)
                        .fill(Color("BGCFlipped"))
                        .ignoresSafeArea()
                        .padding()
                        .frame(width: nil, height: 550)
                }
                .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Saved Quizzes")
                            .font(.system(size: 30, weight: .regular))
    //                        .foregroundStyle(Color("BackgroundColor"))
                            .foregroundStyle(.red)
                            .padding(EdgeInsets(top: 0, leading: 45, bottom: 10, trailing: 0))
                        
                        Spacer()
                    }
                    
                    //TODO: saved quizzes
//                    Spacer()
                }
            }
        }
    }
}

struct ExistingTopicsView: View {
    @EnvironmentObject private var subjectViewModel: SubjectViewModel
    @State var currSubjectID: String
    
    var body: some View {
        VStack {
            List(subjectViewModel.topics) { topic in
                NavigationLink(destination: TopicDetailView(currTopic: topic, currSubjectID: currSubjectID).navigationBarBackButtonHidden(true)) {
                    HStack {
                        VStack (alignment: .leading) {
                            Text(topic.name.capitalizedFirst)
                                .font(.system(size: 20))
                                .foregroundStyle(Color.background)
                            
                            Text("IMPLEMENT last accessed")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.gray)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.background)
                    }
                }
                .listRowBackground(Color("BGCFlipped"))
            }
            .scrollContentBackground(.hidden)
            .listStyle(InsetGroupedListStyle())
            .padding()
            
            Spacer()
            
            NavigationLink(destination: AddTopicView(currSubjectID: currSubjectID).navigationBarBackButtonHidden(true)) {
                Text("Add a new topic")
                    .frame(width: UIScreen.main.bounds.width - 70, height: 70)
                    .background(Color.primary)
                    .foregroundStyle(Color.background)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .padding(.bottom, 100)
        }
    }
}

struct NoTopicsView: View {
    @State var currSubjectID: String
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Seems a bit empty here...")
                .font(.system(size: 28, weight: .regular))
                .frame(maxWidth: 200)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            NavigationLink(destination: AddTopicView(currSubjectID: currSubjectID).navigationBarBackButtonHidden(true)) {
                Text("Add a new topic")
                    .frame(width: UIScreen.main.bounds.width - 70, height: 70)
                    .background(Color.primary)
                    .foregroundStyle(Color.background)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .padding(.bottom, 100)
        }
    }
}
