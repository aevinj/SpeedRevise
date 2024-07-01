//
//  NoSubjectsView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 08/06/2024.
//

import SwiftUI

struct NoSubjectsView: View {
    @EnvironmentObject private var subjectViewModel: SubjectViewModel
    @State private var showAddSubject: Bool = false
    @State private var subjectName: String = ""
    @State private var animationOffset: CGFloat = 1000
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("My Subjects")
                        .font(.system(size: 32, weight: .regular))
                        .padding(EdgeInsets(top: 32, leading: 32, bottom: 0, trailing: 0))
                    
                    Spacer()
                }
                
                Spacer()
                
                ContentUnavailableView {
                    Label("No Subjects", systemImage: "questionmark.folder")
                } description: {
                    Text("When you add new subjects, they will appear here.")
                }
                
                Spacer()
                
                Button {
                    showAddSubject = true
                } label: {
                    Text("Add a new subject")
                        .frame(width: UIScreen.main.bounds.width - 70, height: 70)
                        .background(Color.primary)
                        .foregroundStyle(Color.background)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .padding(.bottom, 100)
                }
            }
            
            if showAddSubject {
                ZStack {
                    Color(.black)
                        .ignoresSafeArea()
                        .opacity(0.5)
                    
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
                            }
                            withAnimation(.spring(response: 0.5)) {
                                animationOffset = 1000
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
                                        animationOffset = 1000
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                        showAddSubject = false
                                    }
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
                    .offset(x: 0, y: animationOffset)
                    .onAppear {
                        withAnimation(.spring()) {
                            animationOffset = 0
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NoSubjectsView()
}
