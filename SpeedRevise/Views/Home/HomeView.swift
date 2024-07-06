import SwiftUI

struct QuizViewArguments: Hashable {
    let quizName: String
    var tempQuiz: Bool = false
    let disableTempChoice: Bool
    var currSubjectID: String? = nil
    var currTopicID: String? = nil
    var useOnAppear: Bool = false
}

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var openAIViewModel: OpenAIViewModel
    @EnvironmentObject private var navigationPathManager: NavigationPathManager
    @EnvironmentObject private var navBarController: NavBarController
    @State private var notificationCount: Int = 1
    @State private var tempQuizEntry: String = ""
    
    var body: some View {
        NavigationStack(path: $navigationPathManager.path) {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        VStack {
                            Text("Hello,")
                                .font(.system(size: 30, weight: .regular))
                                .foregroundStyle(.gray)
                            
                            Text(authViewModel.currentUser?.firstName.capitalizedFirst ?? "None")
                                .font(.system(size: 32, weight: .regular))
                                .foregroundStyle(Color.primary)
                                .padding(.leading, 72)
                        }
                        .padding()
                        
                        Spacer()
                        
                        Button(action: {}, label: {
                            Image(systemName: notificationCount > 0 ? "bell.badge.fill" : "bell.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color.blue, colorScheme == .dark ? Color.white : Color.black)
                                .font(.system(size: 24))
                                .foregroundStyle(Color.primary)
                                .shadow(radius: 70)
                                .frame(width: 64, height: 64)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.trailing, 32)
                        })
                    }
                    
                    Spacer()
                    
                }
                .padding(.top, 50)
                .ignoresSafeArea()
                
                ZStack {
                    VStack {
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 50.0)
                            .fill(.ultraThinMaterial)
                            .frame(width: UIScreen.main.bounds.width, height: 575)
                    }
                    .ignoresSafeArea()
                    
                    VStack {
                        HStack {
                            Text("Overview")
                                .font(.system(size: 30, weight: .regular))
                                .foregroundStyle(Color("BGCFlipped"))
                                .padding(EdgeInsets(top: 0, leading: 45, bottom: 10, trailing: 0))
                            
                            Spacer()
                        }
                        
                        HStack {
                            HStack {
                                Image(systemName: "square.and.pencil")
                                    .foregroundStyle(Color.blue)
                                    .font(.system(size: 22, weight: .bold))
                                    .padding(.leading, 25)
                                
                                TextField("", text: $tempQuizEntry, prompt: Text("Enter topic...").font(.system(size: 20)).foregroundStyle(Color(.systemGray)))
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                                    .fontWeight(.medium)
                                    .padding(.leading, 5)
                            }
                            .frame(width: UIScreen.main.bounds.width-120, height: 60)
//                            .background(colorScheme == .dark ? Color(hex: "34373B") : Color(hex: "E6E6E6"))
                            .background {
                                Group {
                                    if colorScheme == .dark {
                                        Color.clear.background(Material.ultraThinMaterial)
                                    } else {
                                        Color(hex: "E6E6E6")
                                    }
                                }
                            }
                            .cornerRadius(10)
                            
                            Button {
                                let quizViewArguments = QuizViewArguments(quizName: tempQuizEntry, tempQuiz: true, disableTempChoice: true)
                                navigationPathManager.path.append(quizViewArguments)
                            } label: {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(Color(.systemGray))
                                    .shadow(radius: 50)
                                    .frame(width: 60, height: 60)
                                    .background {
                                        Group {
                                            if colorScheme == .dark {
                                                Color.clear.background(Material.ultraThinMaterial)
                                            } else {
                                                Color(hex: "E6E6E6")
                                            }
                                        }
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .padding(.bottom, 10)
                        
                        Group {}
                            .padding(.bottom, 100)
                    }
                }
                .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    NavBarView(selectedTab: $navBarController.selectedTab)
                }
                .padding(.bottom, 30)
                .ignoresSafeArea()
            }
            .navigationDestination(for: QuizViewArguments.self) { quizViewArguments in
                QuizView(quizName: quizViewArguments.quizName, tempQuiz: quizViewArguments.tempQuiz, disableTempChoice: quizViewArguments.disableTempChoice)
                    .navigationBarBackButtonHidden(true)
                    .onAppear {
                        openAIViewModel.initialiseQuiz(difficulty: .medium, desiredTopic: quizViewArguments.quizName)
                        tempQuizEntry = ""
                        
                        openAIViewModel.generateQuestion {
                            openAIViewModel.filteredMessages.append(FilteredMessage(from: openAIViewModel.messages.last!, isQuestion: true))
                            openAIViewModel.userResponse = ""
                        }
                    }
            }
        }
    }
}
