//
//  QuizDetailView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 21/06/2024.
//

import SwiftUI

struct QuizDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var showSettings: Bool = false
    @State private var rotationAngle: Double = 0
    @State private var quizDeleted: Bool = false
    
    let currQuiz: Quiz
    let currTopicID: String
    let currSubjectID: String
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.primary)
                            .shadow(radius: 50)
                            .frame(width: 55, height: 55)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 2))
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
                        SavedQuizSettingsMenuView(quizDeleted: $quizDeleted, currTopicID: currTopicID, currSubjectID: currSubjectID, currQuiz: currQuiz)
                            .onDisappear {
                                if quizDeleted {
                                    dismiss()
                                }
                            }
                    })
                    
                    Spacer()
                    
                    Text(currQuiz.name.capitalizedFirst)
                        .font(.system(size: 32, weight: .medium))
                        .padding(.trailing, 16)
                }
                .padding(.top, 32)
                
                Spacer()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(currQuiz.filteredContent, id: \.id) { message in
                            Text(message.content)
                                .frame(width: UIScreen.main.bounds.width - 70)
                                .padding()
                                .background(message.role == .user ? Color(hex: "34373B") : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .foregroundStyle(Color("BGCFlipped"))
                        }
                    }
                }
                .padding(.bottom, 100)
            }
        }
    }
}
