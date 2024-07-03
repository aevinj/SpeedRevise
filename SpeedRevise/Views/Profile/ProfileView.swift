//
//  ProfileView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 02/06/2024.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var rotationAngle: Double = 0
    @State private var showSettings: Bool = false
    @State var firstName: String = ""
    @State var lastName: String = ""
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
                .onAppear {
                    firstName = authViewModel.currentUser?.firstName ?? "None"
                    lastName = authViewModel.currentUser?.lastName ?? "None"
                }
            
            VStack{
                HStack {
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
                        AccountSettingsMenuView()
                    })
                    
                    Spacer()
                    
                    Text("My Account")
                        .font(.system(size: 40, weight: .medium))
                        .padding(.trailing, 20)
                }
                .padding(EdgeInsets(top: 32, leading: 20, bottom: 0, trailing: 0))
                
                Spacer()
                
                HStack {
                    Text("First Name: ")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.primary)
                        .padding()
                        .onDisappear {
                            Task {
                                if firstName.count > 0 && lastName.count > 0 {
                                    await authViewModel.updateUserDetails(firstName: firstName, lastName: lastName)
                                } else {
                                    firstName = authViewModel.currentUser?.firstName ?? "None"
                                    lastName = authViewModel.currentUser?.lastName ?? "None"
                                }
                            }
                        }
                    
                    TextField("", text: $firstName, prompt: Text("Enter First Name")
                        .foregroundStyle(Color(.systemGray)))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .fontWeight(.medium)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width-200, height: 60)
                    .background(.thickMaterial)
                    .cornerRadius(10)
                    .overlay {
                        if firstName.count == 0 {
                            HStack {
                                Spacer()
                                
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.red)
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                }
                
                HStack {
                    Text("Last Name: ")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.primary)
                        .padding()
                    
                    TextField("", text: $lastName, prompt: Text("Enter Last Name")
                        .foregroundStyle(Color(.systemGray)))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .fontWeight(.medium)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width-200, height: 60)
                    .background(.thickMaterial)
                    .cornerRadius(10)
                    .overlay {
                        if lastName.count == 0 {
                            HStack {
                                Spacer()
                                
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.red)
                                    .padding(.trailing, 10)
                            }
                        }
                    }
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
    ProfileView(firstName: "Aevin", lastName: "Jais")
}
