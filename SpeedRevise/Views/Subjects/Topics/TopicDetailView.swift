//
//  TopicDetailView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 23/06/2024.
//

import SwiftUI

struct TopicDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
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
                        TopicSettingsMenuView(topicDeleted: $topicDeleted, currTopic: currTopic, currSubjectID: currSubjectID)
                            .onDisappear {
                                if topicDeleted {
                                    dismiss()
                                }
                            }
                    })
                }
                .padding(EdgeInsets(top: 32, leading: 32, bottom: 5, trailing: 0))
                
                HStack {
                    NavigationLink {
                        QuizView(quizName: currTopic.name.capitalizedFirst, disableTempChoice: false, currSubject: currSubjectID, currTopic: currTopic.id, useOnAppear: true)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("New Quiz")
                            .frame(width: 120, height: 120)
                            .background(Color.primary)
                            .foregroundStyle(Color.background)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.trailing, 10)
                    }
                    
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
            
            VStack {
                Spacer()
                
                RoundedRectangle(cornerRadius: 50.0)
                    .fill(Color("BGCFlipped"))
                    .frame(width: UIScreen.main.bounds.width, height: 550)
            }
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack {
                    HStack {
                        Text("Saved Quizzes")
                            .font(.system(size: 30, weight: .regular))
                            .foregroundStyle(Color("BackgroundColor"))
                            .padding(EdgeInsets(top: 32, leading: 45, bottom: 10, trailing: 0))
                        
                        Spacer()
                    }
                    
                    List(subjectViewModel.quizzes) { quiz in
                        NavigationLink(destination: QuizDetailView()
                            .navigationBarBackButtonHidden(true)) {
                            HStack {
                                VStack (alignment: .leading) {
                                    Text(quiz.name.capitalizedFirst)
                                        .font(.system(size: 20))
                                        .foregroundStyle(Color(.black))
                                    
                                    Text("Created: \(dateFormatter.string(from: quiz.creationDate))")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color(.systemGray))
                                }
                                
                                Spacer()
                                
                                if colorScheme == .dark {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(.black))
                                }
                            }
                        }
                        .listRowBackground(Color(hex: "E6E6E6"))
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(InsetGroupedListStyle())
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    
                    //TODO: saved notes
                    
                    Spacer()
                }
                .frame(width: nil, height: 550)
            }
            .ignoresSafeArea()
        }
    }
}