//
//  ProfileView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 02/06/2024.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text("My Account")
                .font(.system(size: 24))
            
            Button(action: {
                authViewModel.signOut()
            }, label: {
                Text("Sign Out")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .frame(width: UIScreen.main.bounds.width-96, height: 60)
                    .background(Color.red)
                    .cornerRadius(20)
            })
        }
    }
}

#Preview {
    ProfileView()
}
