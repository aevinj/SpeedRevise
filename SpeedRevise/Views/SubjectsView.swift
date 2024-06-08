//
//  SubjectsView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 06/06/2024.
//

import SwiftUI

struct SubjectsView: View {
    private var subjectCount: Int = 0
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("My Subjects")
                        .font(.system(size: 32, weight: .regular))
                        .padding(EdgeInsets(top: 32, leading: 32, bottom: 0, trailing: 0))
                    
                    Spacer()
                }
                
                if subjectCount > 0 {
                    Group {
                        Text("To be implemented")
                    }
                } else {
                    NavigationStack {
                        EmptyView()
                    }
                }
            }
        }
    }
}

struct EmptyView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Group {
            HStack {
                Image("cobweb")
                    .renderingMode(.template)
                    .rotationEffect(.degrees(180))
                    .foregroundStyle(colorScheme == .dark ? Color(hex: "34373B") : Color(hex: "E6E6E6"))
                
                Spacer()
            }
            
            Spacer()
            
            Text("Seems a bit empty here...")
                .font(.system(size: 28, weight: .regular))
                .frame(maxWidth: 200)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            ZStack {
                NavigationLink(destination: AddSubjectView()) {
                    Text("Add a new subject")
                        .frame(width: UIScreen.main.bounds.width - 70, height: 70)
                        .background(Color.primary)
                        .foregroundStyle(Color.background)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
                
                HStack {
                    Spacer()
                    
                    Image("cobweb")
                        .renderingMode(.template)
                        .foregroundStyle(colorScheme == .dark ? Color(hex: "34373B") : Color(hex: "E6E6E6"))
                }
            }
        }
    }
}


#Preview {
    SubjectsView()
}
