//
//  OpenAIModel.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 10/06/2024.
//

import Foundation

struct OpenAIMessage: Codable {
    let role: String
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
