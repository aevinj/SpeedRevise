//
//  AccountSettingsMenuView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 14/06/2024.
//

import SwiftUI

struct AccountSettingsMenuView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var showLoading: Bool = false
    @Binding var showSettings: Bool
    
    var body: some View {
        HStack {
            if !showLoading {
                Image(systemName: "trash")
                    .foregroundStyle(Color.red)
                    .font(.system(size: 20, weight: .medium))
                
                Text("Delete my account")
                    .foregroundStyle(Color.red)
            } else {
                ProgressView(label: {
                    Text("")
                    }
                ).progressViewStyle(.circular)
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 70, height: 70)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onTapGesture {
            Task {
                showLoading = true
                let deleteSuccessful = await authViewModel.deleteAccount()
                if deleteSuccessful {
                    showLoading = false
                    showSettings = false
                    
                    authViewModel.currentUser = nil
                    authViewModel.userSession = nil
                }
            }
        }
        .presentationCompactAdaptation(.popover)
    }
}

