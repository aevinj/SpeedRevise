//
//  FirstView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 30/05/2024.
//

import SwiftUI

struct FirstView: View {
    var body: some View {
        ZStack {
            
//            ContainerRelativeShape()
//                .fill(Color(.systemGray6))
//                .ignoresSafeArea()
            
            AngularGradient(colors: [.red, .teal, .blue, .black, .indigo, .red], center: .center)
                .ignoresSafeArea()
                .blur(radius: 60, opaque: true)
            
            VStack{
                
                Spacer()
                
                Image(systemName: "graduationcap.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundStyle(Color.teal.gradient)
                    
                HStack {
                    
                    Text("For when you need to speedrun your revision ✌️")
                        .font(.system(size: 35, weight: .heavy))
                        .foregroundStyle(Color.white)
                        .frame(width: 300)
                        .padding(.leading, 30)
                    
                    Spacer()
                }
                
                Spacer()
                
                VStack{

                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Log in with email")
                            .frame(width: 300, height: 60)
                            .background(Color.teal.gradient)
                            .foregroundStyle(Color.white)
                            .font(.system(size: 16, weight: .bold))
                            .cornerRadius(50)
                            .shadow(radius: 25)
                    })
                    .padding(.bottom, 10)
                    
                    HStack {
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Text("Google")
                                .frame(width: 150, height: 60)
                                .background(.ultraThinMaterial)
                                .foregroundStyle(Color.white)
                                .font(.system(size: 16, weight: .bold))
                                .cornerRadius(50)
                        })
                        
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Text("Apple ID")
                                .frame(width: 150, height: 60)
                                .background(.ultraThinMaterial)
                                .foregroundStyle(Color.white)
                                .font(.system(size: 16, weight: .bold))
                                .cornerRadius(50)
                        })
                    }

                    Text("By continuing you agree to the Terms & Conditions")
                        .font(.footnote)
                        .foregroundStyle(Color.white)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    FirstView()
}
