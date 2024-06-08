//
//  AddSubjectView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 08/06/2024.
//

import SwiftUI

struct AddSubjectView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var subjectViewModel: SubjectViewModel
    @State private var subjectName: String = ""

    var body: some View {
        VStack {
            TextField("Enter subject name", text: $subjectName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                Task {
                    await subjectViewModel.addSubject(name: subjectName)
                    presentationMode.wrappedValue.dismiss()
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
