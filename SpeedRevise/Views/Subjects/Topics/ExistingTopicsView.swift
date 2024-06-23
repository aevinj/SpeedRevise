//
//  ExistingTopicsView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 23/06/2024.
//

import SwiftUI

struct ExistingTopicsView: View {
    @EnvironmentObject private var subjectViewModel: SubjectViewModel
    @EnvironmentObject private var openAIViewModel: OpenAIViewModel
    let currSubjectID: String
    
    var body: some View {
        VStack {
            List(subjectViewModel.topics) { topic in
                NavigationLink(destination: TopicDetailView(currTopic: topic, currSubjectID: currSubjectID)
                    .navigationBarBackButtonHidden(true)
                    .onAppear {
                        subjectViewModel.fetchQuizzes(subjectID: currSubjectID, topicID: topic.id)
                    }
                    .onDisappear {
                        openAIViewModel.reset()
                    }
                ){
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
