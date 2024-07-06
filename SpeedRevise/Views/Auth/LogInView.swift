//
//  LogInView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 31/05/2024.
//

import SwiftUI

struct LogInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack{
                ContainerRelativeShape()
                    .fill(Color(.systemGray5))
                    .ignoresSafeArea()
                
//                AngularGradient(colors: [.red, .teal, .blue, .black, .indigo, .red], center: .center)
//                    .ignoresSafeArea()
//                    .blur(radius: 80, opaque: true)
                
                VStack {
                    VStack {
                        Text("SpeedRevise")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundStyle(Color.gray)
                            .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                        
                        HStack {
                            Spacer()
                            
                            Text("Development version")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(.gray)
                                .padding(.trailing, 16)
                        }
                    }
                    
                    Spacer()
                    
                    TextInputView(textInput: $email, prompt: "jane.doe@example.com")
                        .padding(.bottom)
                    
                    TextInputView(textInput: $password, prompt: "Enter password", isSecure: true)
                        .padding(.bottom)
                    
                    HStack {
                        
                        Spacer()
                        
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            
                            Text("Forgot password?")
                                .font(.system(size: 14, weight: .bold))
                            
                        })
                        .padding(.trailing, 50)
                        .padding(.top, 5)
                        
                    }
                    
                    Spacer()
                    
                    VStack {
                        
                            NavigationLink {
                                SignUpView()
                                    .navigationBarBackButtonHidden(true)
                            } label: {
                                HStack{
                                    Text("Don't have an account?")
                                    Text("Create one")
                                        .fontWeight(.bold)
                                }
                                .font(.system(size: 14, weight: .medium))
                            }
        
                        Button(action: {
                            Task {
                                try await authViewModel.signIn(email: email, password: password)
                            }
                        }, label: {
                            Text("Log in")
                                .frame(width: 300, height: 60)
                                .background(Color.teal.gradient)
                                .foregroundStyle(Color.white)
                                .font(.system(size: 16, weight: .bold))
                                .cornerRadius(50)
                        })
                        .padding(.bottom, 5)
                        .padding(.top, 5)
                        .disabled(!formIsValid)
                        .opacity(formIsValid ? 1.0 : 0.5)
                    }
                }
                
            }
        }
    }
}

extension LogInView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return email.contains("@")
        && email.count > 2
        && !password.isEmpty
        && password.count > 5
    }
}

#Preview {
    LogInView()
}
