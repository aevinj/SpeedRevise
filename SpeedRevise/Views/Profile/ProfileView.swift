//
//  ProfileView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 02/06/2024.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var rotationAngle: Double = 0
    @State private var showSettings: Bool = false
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            Image("leaves")
                .renderingMode(.template)
                .foregroundStyle(colorScheme == .dark ? Color(hex: "34373B") : Color(hex: "E6E6E6"))
            
            VStack{
                HStack {
                    Text("My Account")
                        .font(.system(size: 32, weight: .regular))
                        .padding(EdgeInsets(top: 32, leading: 50, bottom: 0, trailing: 0))
                    
                    Spacer()
                    
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
                            .padding(EdgeInsets(top: 32, leading: 0, bottom: 0, trailing: 50))
                    }
                    .popover(isPresented: $showSettings, content: {
                        AccountSettingsMenuView()
                    })
                }
                
                Spacer()
                
                HStack {
                    Text("First Name: ")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.primary)
                        .padding()
                        .onAppear(perform: {
                            firstName = authViewModel.currentUser?.firstName ?? "None"
                            lastName = authViewModel.currentUser?.lastName ?? "None"
                        })
                    
                    TextField("", text: $firstName, prompt: Text("")
                        .foregroundStyle(Color(.systemGray)))
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .fontWeight(.medium)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width-200, height: 60)
                        .background(.thickMaterial)
                        .cornerRadius(10)

                }
                
                HStack {
                    Text("Last Name: ")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.primary)
                        .padding()
                    
                    TextField("", text: $lastName, prompt: Text("")
                        .foregroundStyle(Color(.systemGray)))
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .fontWeight(.medium)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width-200, height: 60)
                        .background(.thickMaterial)
                        .cornerRadius(10)

                }
                
                Spacer()
                
                Button(action: {
                    authViewModel.signOut()
                }, label: {
                    Text("Sign Out")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.white)
                        .frame(width: UIScreen.main.bounds.width-96, height: 60)
                        .background(Color.red)
                        .cornerRadius(20)
                        .padding(.bottom, 100)
                })
            }
        }
    }
}

#Preview {
    ProfileView()
}
