//
//  OpenAIModel.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 10/06/2024.
//

import Foundation

struct FilteredMessage: Identifiable, Codable, Hashable {
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

struct OpenAIMessage: Codable, Hashable {
    let role: OpenAIRoles
    let content: String
}

struct OpenAIRequest: Codable, Hashable {
    let model: String
    let messages: [OpenAIMessage]
}

struct OpenAIResponse: Codable, Hashable {
    struct Choice: Codable, Hashable {
        let message: OpenAIMessage
    }
    let choices: [Choice]
}

enum OpenAIRoles: String, Codable, Hashable {
    case user
    case assistant
    case system
}
