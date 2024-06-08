//
//  SubjectDetailView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 08/06/2024.
//

import SwiftUI

struct SubjectDetailView: View {
    @EnvironmentObject var subjectViewModel: SubjectViewModel
    @Environment(\.presentationMode) var presentationMode
    var subject: Subject
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                Text(subject.name)
                    .font(.system(size: 32))
                
                Spacer()
                
                Button {
                    Task {
                        await subjectViewModel.deleteSubject(subject: subject)
                        subjectViewModel.fetchSubjects()
                    }
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Delete this subject")
                        .frame(width: UIScreen.main.bounds.width - 70, height: 70)
                        .background(.red)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
                .padding(.bottom, 16)

                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Go back")
                        .frame(width: UIScreen.main.bounds.width - 70, height: 70)
                        .background(Color("BGCFlipped"))
                        .foregroundStyle(Color("BackgroundColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
                .padding(.bottom, 100)
                
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
