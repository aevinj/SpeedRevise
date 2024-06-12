//
//  AddSubjectView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 08/06/2024.
//

import SwiftUI

struct AddSubjectView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var subjectViewModel: SubjectViewModel
    @State private var subjectName: String = ""

    var body: some View {
        VStack {
            TextField("Enter subject name", text: $subjectName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button {
                dismiss()
            } label: {
                Text("Take me back")
                    .frame(width: UIScreen.main.bounds.width - 70, height: 70)
                    .background(.gray)
                    .foregroundStyle(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            
            Button(action: {
                Task {
                    await subjectViewModel.addSubject(name: subjectName)
                    dismiss()
                }
            }, label: {
                Text("Save Subject")
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            })

            Spacer()
        }
        .navigationTitle("Add New Subject")
        .padding()
    }
}

#Preview {
    AddSubjectView()
}
