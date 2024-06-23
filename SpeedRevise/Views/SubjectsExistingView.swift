//
//  SubjectsExistingView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 08/06/2024.
//

import SwiftUI

struct SubjectsExistingView: View {
    @EnvironmentObject private var subjectViewModel: SubjectViewModel
    
    var body: some View {
        VStack {
            List(subjectViewModel.subjects) { subject in
                NavigationLink(destination: SubjectDetailView(currSubject: subject).onAppear(perform: {
                    subjectViewModel.fetchTopics(subjectID: subject.id)
                }).navigationBarBackButtonHidden(true)) {
                    HStack {
                        VStack (alignment: .leading) {
                            Text(subject.name.capitalizedFirst)
                                .font(.system(size: 20))
                                .foregroundStyle(Color.background)
                            
                            Text("IMPLEMENT last accessed:")
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
            
            NavigationLink(destination: AddSubjectView().navigationBarBackButtonHidden(true)) {
                Text("Add a new subject")
                    .frame(width: UIScreen.main.bounds.width - 70, height: 70)
                    .background(Color.primary)
                    .foregroundStyle(Color.background)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .padding(.bottom, 100)
        }
    }
}

#Preview {
    SubjectsExistingView()
}
