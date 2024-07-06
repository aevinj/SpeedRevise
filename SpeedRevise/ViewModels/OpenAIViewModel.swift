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
    @Published var filteredMessages: [FilteredMessage] = []
    @Published var userResponse: String = ""
    @Published var isLoading: Bool = false
    private var endpoint = "https://api.openai.com/v1/chat/completions"
    
    func reset() {
        messages = []
        filteredMessages = []
        userResponse = ""
        isLoading = false
    }
    
    func isNotIntialised() -> Bool {
        return messages.isEmpty
    }
    
    func initialiseQuiz(difficulty: Difficulty, desiredTopic: String) {
        let instruction = """
        Your aim is to test the user's knowledge on the topic of \(desiredTopic).
        Don't provide confirmation replies to user input - simply ask questions and perform concise analysis on the user's answers.
        Only output the question text directly. Generate questions of \(difficulty.rawValue) difficulty.
        If the user asks for the answer, tell them the answer concisely.
        """
        messages.append(OpenAIMessage(role: .system, content: instruction))
    }

    
    func performAnalysisOnUserResponse(completion: @escaping () -> Void) {
        Task {
            await sendMessage(content: "Analyse this answer: \(userResponse). Limit your response to 50 words maximum.")
            completion()
        }
    }
    
    func userUnsureOfAnswer(completion: @escaping () -> Void) {
        Task {
            await sendMessage(content: "Tell me the answer. Limit your response to 50 words maximum.")
            completion()
        }
    }
    
    func generateQuestion(completion: @escaping () -> Void) {
        Task {
            await sendMessage(content: "Generate an unseen question - do not show the answer unless asked to. Limit your response to 50 words maximum.")
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
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(Constants.openAIAPIKey)", forHTTPHeaderField: "Authorization")
        
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
