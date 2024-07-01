//
//  TextInputView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 31/05/2024.
//

import SwiftUI

struct TextInputView: View {
    @Binding var textInput: String
    var prompt: String
    var isSecure: Bool = false
    
    var body: some View {
        if !isSecure {
            
            TextField("", text: $textInput, prompt: Text(prompt).foregroundStyle(Color(.systemGray)))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .fontWeight(.medium)
                .padding()
                .frame(width: UIScreen.main.bounds.width-96, height: 60)
                .background(.thickMaterial)
                .cornerRadius(10)
            
        } else {
            
            SecureField("", text: $textInput, prompt: Text(prompt).foregroundStyle(Color(.systemGray)))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .fontWeight(.medium)
                .padding()
                .frame(width: UIScreen.main.bounds.width-96, height: 60)
                .background(.thickMaterial)
                .cornerRadius(10)

        }
    }
}

#Preview {
    TextInputView(textInput: .constant(""), prompt: "jane.doe@example.com")
}
