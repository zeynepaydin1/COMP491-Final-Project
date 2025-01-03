//
//  RequestBuilder.swift
//  SeizureXpert
//
//  Created by Sarp Vulaş on 3.01.2025.
//

import Foundation

class RequestBuilder {
    /// Store your API key securely; hard-coding is fine only for testing.
    private var apiKey: String {
        "BURAYA APINIZI GİRİN"
    }

    /// Builds a `URLRequest` for the Chat Completions API
    func buildRequest(prompt: String, url: URL?) -> URLRequest? {
        guard let apiUrl = url else {
            return nil
        }

        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Customize as needed (e.g., "gpt-3.5-turbo", "gpt-4", etc.)
        let parameters: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ]
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            print("[Error] Failed to encode JSON parameters.")
            return nil
        }

        request.httpBody = jsonData
        return request
    }
}

