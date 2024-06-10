//
//  ChatViewModel.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 10/06/2024.
//

import SwiftUI
import Combine

class OpenAIViewModel: ObservableObject {
    @Published var messages: [OpenAIMessage] = []
    @Published var userResponse: String = ""
    @Published var feedback: String = ""
    @Published var isLoading: Bool = false
    private var endpoint = "https://api.openai.com/v1/chat/completions"

    func sendMessage(content: String) {
        isLoading = true
        let userMessage = OpenAIMessage(role: "user", content: content)
        messages.append(userMessage)
        
        fetchChatResponse(messages: messages) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let message):
                    self.messages.append(message)
                    self.feedback = message.content
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    private func fetchChatResponse(messages: [OpenAIMessage], completion: @escaping (Result<OpenAIMessage, Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Constants.openAIAPIKey)", forHTTPHeaderField: "Authorization")
        
        let chatRequest = OpenAIRequest(model: "gpt-3.5-turbo-16k", messages: messages)
        
        do {
            let requestData = try JSONEncoder().encode(chatRequest)
            request.httpBody = requestData
        } catch {
            print("Failed to encode request: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                if let message = openAIResponse.choices.first?.message {
                    completion(.success(message))
                } else {
                    print("No message in response")
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
