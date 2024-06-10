//
//  ChatViewModel.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 10/06/2024.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var currentInput: String = ""
    private let openAIService = OpenAIService()
    
    func sendMessage() {
        let newMessage = Message(id: UUID(), role: .user, content: currentInput, createAt: Date())
        messages.append(newMessage)
        currentInput = ""
        
        Task {
            let response = await openAIService.sendMessage(message: messages)
            print(response)
            guard let recievedOpenAIMessage = response?.choices.first?.message else {
                print("Did not recieve any message")
                return
            }
            let recievedMessage = Message(id: UUID(), role: recievedOpenAIMessage.role, content: recievedOpenAIMessage.content, createAt: Date())
            await MainActor.run {
                messages.append(recievedMessage)
            }
        }
    }
}

struct Message: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}
