//
//  SwiftUIView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 06/07/2024.
//

import SwiftUI

struct ViewNoteViewArguments: Hashable {
    let currTopicID: String
    let currSubjectID: String
    let currQuiz: Quiz
}

struct ViewNoteView: View {
    @EnvironmentObject private var navigationPathManager: NavigationPathManager
    @EnvironmentObject private var navBarController: NavBarController
    @EnvironmentObject private var subjectViewModel: SubjectViewModel
    @State private var rotationAngle: Double = 0
    @State private var showSettings: Bool = false
    @State private var noteDeleted: Bool = false
    let currTopicID: String
    let currSubjectID: String
    let currQuiz: Quiz
    
    var body: some View {
        ZStack{
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                
                HStack {
                    Button {
                        navigationPathManager.path.removeLast()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.primary)
                            .shadow(radius: 50)
                            .frame(width: 55, height: 55)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 2))
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
                        ViewNoteViewSettingsMenuView(noteDeleted: $noteDeleted, currTopicID: currTopicID, currSubjectID: currSubjectID, currQuiz: currQuiz)
                            .onDisappear {
                                if noteDeleted {
                                    navigationPathManager.path.removeLast()
                                }
                            }
                    })
                    
                    Spacer()
                    
                    Text(subjectViewModel.note?.name ?? "Missing")
                        .font(.system(size: 30, weight: .bold))
                        .padding()
                }
                .padding(.bottom, 20)
                
                ScrollView {
                    Text(subjectViewModel.note?.content ?? "Not found")
                        .font(.system(size: 18))
                        .foregroundStyle(Color("BGCFlipped"))
                        .padding()
                        .padding(.bottom, 50)
                }
                .frame(maxHeight: UIScreen.main.bounds.height - 275)
                
                Spacer()
            }
            
            VStack {
                Spacer()
                
                NavBarView(selectedTab: $navBarController.selectedTab)
            }
            .padding(.bottom, 30)
            .ignoresSafeArea()
        }
    }
}
