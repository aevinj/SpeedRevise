//
//  HomeView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 29/05/2024.
//

import SwiftUI

struct HomeView: View {
    @State private var name: String = "Aevin"
    
    var body: some View {
        ZStack {
            
            AngularGradient(colors: [.red, .teal, .blue, .black, .indigo, .red], center: .center)
                .ignoresSafeArea()
                .blur(radius: 100, opaque: true)
            
            VStack {
                HStack {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .foregroundColor(.teal)
                        .frame(width: 50, height: 50)
                        .padding(EdgeInsets(top: 16, leading: 25, bottom: 16, trailing: 5))
                    
                    VStack {
                        Text("Welcome back")
                            .foregroundStyle(.white)
                            .font(.system(size: 16, weight: .medium))
                        
                        Text(name)
                            .font(.system(size: 20, weight: .heavy))
                    }
                    
                    Spacer()
                    
                    // TODO: when this is shown, i want to animate a wave
                    Text("👋")
                        .font(.system(size: 40))
                        .bold()
                        .padding()
                    
                    Spacer()
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                
                HStack {
                    Text("Upcoming Exams")
                        .font(.system(size: 30, weight: .bold))
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        Text("See all")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 20))
                    })
                }
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .padding()
                    
                
                Spacer()
            }
        }
    }
}

#Preview {
    HomeView()
}
