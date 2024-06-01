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
                        TextInputView(textInput: $confirm, prompt: "Confirm Password", isSecure: true)
                    } else {
                        TextInputView(textInput: $password, prompt: "Password")
                        TextInputView(textInput: $confirm, prompt: "Confirm Password")
                    }
                    HStack{
                        Toggle("Show Password", isOn: $showPasswords)
                            .toggleStyle(CheckboxToggleStyle())
                        
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
                        try await authViewModel.createUser(email: email, password: password, tempNameAevin: firstName)
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

#Preview {
    SignUpView()
}
