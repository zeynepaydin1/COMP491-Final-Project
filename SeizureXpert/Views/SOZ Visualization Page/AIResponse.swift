//
//  AIResponse.swift
//  SeizureXpert
//
//  Created by Sarp Vulaş on 3.01.2025.
//

import Foundation

/// Root-level response object for Chat Completions
struct AIResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
}

/// Each choice in the `choices` array
struct Choice: Codable {
    let index: Int
    let message: Message
    let logprobs: String?
    let finish_reason: String
}

/// The ChatGPT-style message structure
struct Message: Codable {
    let role: String
    let content: String
}

