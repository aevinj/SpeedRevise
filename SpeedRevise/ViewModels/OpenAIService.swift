//
//  OpenAIService.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 10/06/2024.
//

import Foundation
import Alamofire

class OpenAIService {
    private let endpointURL = "https://api.openai.com/v1/chat/completions"
        
    func sendMessage(message: [Message]) async -> OpenAIChatResponse? {
        let openAIMessages = message.map({OpenAIChatMessage(role: $0.role, content: $0.content)})
        print("openAIMessages: \(openAIMessages)")
        let body = OpenAIChatBody(model: "gpt-3.5-turbo-16k", messages: openAIMessages)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openAIAPIKey)"
        ]
        return try? await AF.request(endpointURL, method: .post, parameters: body, encoder: .json, headers: headers).serializingDecodable(OpenAIChatResponse.self).value
    }
}

struct OpenAIChatBody: Encodable {
    let model: String
    let messages: [OpenAIChatMessage]
}

struct OpenAIChatMessage: Codable {
    let role: SenderRole
    let content: String
}

struct OpenAIChatResponse: Decodable {
    let choices: [OpenAIChatChoices]
}

struct OpenAIChatChoices: Decodable {
    let message: OpenAIChatMessage
}

enum SenderRole: String, Codable {
    case system
    case assistant
    case user
}
