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
    var subject: Subject
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text(subject.name)
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
                            .padding(.trailing, 2)
                    }
                    
                    Button {
                        Task {
                            await subjectViewModel.deleteSubject(subject: subject)
                        }
                        dismiss()
                    } label: {
                        Image(systemName: "trash.fill")
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
                
                if subjectViewModel.topics.isEmpty {
                    NoTopicsView(currSubjectID: subject.id)
                } else {
                    ExistingTopicsView(currSubjectID: subject.id)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct TopicDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    var topic: Topic
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            Image("leaves")
                .renderingMode(.template)
                .foregroundStyle(colorScheme == .dark ? Color(hex: "34373B") : Color(hex: "E6E6E6"))
            
            VStack {
                Text(topic.name)
                    .font(.title)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Text("return")
                        .frame(width: UIScreen.main.bounds.width - 70, height: 60)
                        .background(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.bottom, 100)
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
                NavigationLink(destination: TopicDetailView(topic: topic)) {
                    HStack {
                        VStack (alignment: .leading) {
                            Text(topic.name)
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
            .padding(.top, 20)
            
            Spacer()
            
            Button {
                
            } label: {
                NavigationLink(destination: AddTopicView(currSubjectID: currSubjectID)) {
                    Text("Add a new topic")
                        .frame(width: UIScreen.main.bounds.width - 70, height: 70)
                        .background(Color.primary)
                        .foregroundStyle(Color.background)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
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
            
            Button {
                
            } label: {
                NavigationLink(destination: AddTopicView(currSubjectID: currSubjectID)) {
                    Text("Add a new topic")
                        .frame(width: UIScreen.main.bounds.width - 70, height: 70)
                        .background(Color.primary)
                        .foregroundStyle(Color.background)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
            }
            .padding(.bottom, 100)
        }
    }
}
