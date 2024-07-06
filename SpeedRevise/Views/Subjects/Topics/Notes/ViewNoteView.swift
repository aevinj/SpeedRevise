//
//  SwiftUIView.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 06/07/2024.
//

import SwiftUI

struct ViewNoteView: View {
    var body: some View {
        ZStack{
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                Text("This is where you view the generated notes")
                    .font(.title)
            }
        }
    }
}
