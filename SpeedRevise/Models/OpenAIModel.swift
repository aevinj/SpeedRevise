//
//  OpenAIModel.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 10/06/2024.
//

import Foundation

struct FilteredMessage {
    let id: UUID
    let role: OpenAIRoles
    let content: String
    let isQuestion: Bool

    init(from openAIMessage: OpenAIMessage, isQuestion: Bool = false) {
        self.role = openAIMessage.role
        self.content = openAIMessage.content
        self.isQuestion = isQuestion
        self.id = UUID()
    }
    
    init(role: OpenAIRoles, content: String, isQuestion: Bool = false) {
        self.role = role
        self.content = content
        self.isQuestion = isQuestion
        self.id = UUID()
    }
}

struct OpenAIMessage: Codable {
    let role: OpenAIRoles
    let content: String
}

struct OpenAIRequest: Codable {
    let model: String
    let messages: [OpenAIMessage]
}

struct OpenAIResponse: Codable {
    struct Choice: Codable {
        let message: OpenAIMessage
    }
    let choices: [Choice]
}

enum OpenAIRoles: String, Codable {
    case user
    case assistant
    case system
}
