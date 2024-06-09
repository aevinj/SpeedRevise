//
//  NoSubjectsView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 08/06/2024.
//

import SwiftUI

struct NoSubjectsView: View {
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
            
            NavigationLink(destination: AddSubjectView()) {
                Text("Add a new subject")
                    .frame(width: UIScreen.main.bounds.width - 70, height: 70)
                    .background(Color.primary)
                    .foregroundStyle(Color.background)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .padding(.bottom, 100)
        }
    }
}

#Preview {
    NoSubjectsView()
}
