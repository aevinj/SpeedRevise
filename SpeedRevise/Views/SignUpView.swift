//
//  SignUpView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 31/05/2024.
//

import SwiftUI

struct SignUpView: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirm: String = ""
    @State var showPasswords: Bool = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack{
            
            ContainerRelativeShape()
                .fill(Color(.systemGray5))
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                VStack{
                    TextInputView(textInput: $firstName, prompt: "Jane")
                    TextInputView(textInput: $lastName, prompt: "Doe")
                    TextInputView(textInput: $email, prompt: "jane.doe@example.com")
                    if !showPasswords {
                        TextInputView(textInput: $password, prompt: "Password", isSecure: true)
                        
                        ZStack (alignment: .trailing) {
                            TextInputView(textInput: $confirm, prompt: "Confirm Password", isSecure: true)
                            
                            if !password.isEmpty && !confirm.isEmpty {
                                if password == confirm {
                                    Image(systemName: "checkmark.circle.fill")
                                        .imageScale(.large)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.green)
                                        .padding(.trailing, 5)
                                } else {
                                    Image(systemName: "xmark.circle.fill")
                                        .imageScale(.large)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.red)
                                        .padding(.trailing, 5)
                                }
                            }
                        }
                    } else {
                        TextInputView(textInput: $password, prompt: "Password")
                        
                        ZStack (alignment: .trailing) {
                            TextInputView(textInput: $confirm, prompt: "Confirm Password")
    
                            if !password.isEmpty && !confirm.isEmpty {
                                if password == confirm {
                                    Image(systemName: "checkmark.circle.fill")
                                        .imageScale(.large)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.green)
                                        .padding(.trailing, 5)
                                } else {
                                    Image(systemName: "xmark.circle.fill")
                                        .imageScale(.large)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.red)
                                        .padding(.trailing, 5)
                                }
                            }
                        }
                    }
                    HStack{
                        Toggle("Show Password", isOn: $showPasswords)
                            .toggleStyle(CheckboxToggleStyle())
                            .disabled(password.isEmpty)
                            .opacity(!password.isEmpty ? 1.0 : 0.5)
                        
                        Spacer()
                    }
                    .padding()
                    .padding(.leading, 45)
                }
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    HStack{
                        Text("Already have an account?")
                        Text("Log in")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14, weight: .medium))
                }

                
                Button(action: {
                    Task {
                        try await authViewModel.createUser(email: email, password: password, firstName: firstName.lowercased(), lastName: lastName.lowercased())
                    }
                }, label: {
                    Text("Create account")
                        .frame(width: 300, height: 60)
                        .background(Color.teal.gradient)
                        .foregroundStyle(Color.white)
                        .font(.system(size: 16, weight: .bold))
                        .cornerRadius(50)
                })
                .padding(.bottom, 5)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
            }
            
        }
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 20, height: 20)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
}

extension SignUpView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !firstName.isEmpty
        && !lastName.isEmpty
        && email.contains("@")
        && email.count > 2
        && password.count > 5
        && confirm == password
    }
}

#Preview {
    SignUpView()
}
