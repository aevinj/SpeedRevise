//
//  ChatViewModel.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 10/06/2024.
//

import SwiftUI
import Combine

@MainActor
class OpenAIViewModel: ObservableObject {
    @Published var messages: [OpenAIMessage] = []
    @Published var userResponse: String = ""
    @Published var isLoading: Bool = false
    private var endpoint = "https://api.openai.com/v1/chat/completions"
    
    func isNotIntialised() -> Bool {
        return messages.isEmpty
    }
    
    func initialiseQuiz(difficulty: Difficulty) {
        let instruction = "Your aim is to test the user's knowledge on the topic of \(userResponse). Don't provide confirmations/greetings/unnecessary information - simply ask questions and perform analysis on user's answers. Generate \(difficulty.rawValue) difficulty questions."
        
        messages.append(OpenAIMessage(role: .system, content: instruction))
    }
    
    func performAnalysisOnUserResponse(completion: @escaping () -> Void) {
        Task {
            await sendMessage(content: "Analyse this answer: \(userResponse)")
            completion()
        }
    }
    
    func generateQuestion(completion: @escaping () -> Void) {
        Task {
            await sendMessage(content: "Generate an unseen question")
            completion()
        }
    }
    
    func sendMessage(content: String) async {
        isLoading = true
        
        let userMessage = OpenAIMessage(role: .user, content: content)
        messages.append(userMessage)
        
        let result = await fetchChatResponse(messages: messages)
            
        switch result {
        case .success(let message):
            messages.append(message)
            DispatchQueue.main.async {
                self.isLoading = false
            }
        case .failure(let error):
            DispatchQueue.main.async {
                self.isLoading = false
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func fetchChatResponse(messages: [OpenAIMessage]) async -> Result<OpenAIMessage, Error> {
        guard let url = URL(string: endpoint) else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
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
            return .failure(error)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
            if let message = openAIResponse.choices.first?.message {
                return .success(message)
            } else {
                return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No message in response"]))
            }
        } catch {
            return .failure(error)
        }
    }
}
