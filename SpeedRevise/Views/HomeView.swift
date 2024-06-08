//
//  HomeView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 29/05/2024.
//

import SwiftUI

struct HomeView: View {
    // TODO: change to use user environment variable
    @State private var firstName: String = "Aevin"
    @State private var notificationCount: Int = 1
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                Image("leaves")
                    .renderingMode(.template)
                    .foregroundStyle(colorScheme == .dark ? Color(hex: "34373B") : Color(hex: "E6E6E6"))
                
                Spacer()
            }
            .padding(.top, 50)
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    VStack {
                        Text("Hello,")
                            .font(.system(size: 30, weight: .regular))
                            .foregroundStyle(.gray)
                        
                        Text(firstName)
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
                            .font(.system(size: 30))
                            .foregroundStyle(Color.primary)
                            .shadow(radius: 70)
                            .frame(width: 75, height: 75)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .padding(.trailing, 30)
                    })
                }
                
                Spacer()
                
            }
            
            VStack {
                Spacer()
                
                RoundedRectangle(cornerRadius: 50.0)
                    .fill(Color("BGCFlipped"))
                    .ignoresSafeArea()
                    .padding()
                    .frame(width: nil, height: 575)
            }
            .ignoresSafeArea()
            
        }
    }
}

#Preview {
    HomeView()
}
