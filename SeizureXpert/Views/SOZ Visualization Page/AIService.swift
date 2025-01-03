//
//  AIService.swift
//  SeizureXpert
//
//  Created by Sarp Vulaş on 3.01.2025.
//

import Foundation

class AIService {
    private let networkManager = NetworkManager()
    private let requestBuilder = RequestBuilder()

    /// Generic error message to return on failure
    private let errorMessage = "Error: Unable to generate AI response"

    /// The Chat Completions endpoint
    private let url = URL(string: "https://api.openai.com/v1/chat/completions")

    /// Entry point: pass in a `prompt` string and get a response back
    func getAIResponse(prompt: String) async -> String {
        // 1) Build the request
        guard let request = requestBuilder.buildRequest(prompt: prompt, url: url) else {
            print("[Error] Failed to build request")
            return errorMessage
        }

        // 2) Send the request
        do {
            let data = try await networkManager.sendRequest(request)
            return decodeResponse(data)
        } catch {
            print("[Error] Failed to send request: \(error.localizedDescription)")
            return errorMessage
        }
    }

    /// Attempts to decode JSON data into `AIResponse`, then returns the assistant’s text
    private func decodeResponse(_ data: Data) -> String {
        do {
            let aiResponse = try JSONDecoder().decode(AIResponse.self, from: data)
            // The first choice’s message content, or a fallback if missing
            return aiResponse.choices.first?.message.content ?? "No response found"
        } catch {
            print("[Error] Failed to decode response: \(error.localizedDescription)")
            return errorMessage
        }
    }
}
