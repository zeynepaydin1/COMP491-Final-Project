//
//  NetworkManager.swift
//  SeizureXpert
//
//  Created by Sarp Vulaş on 3.01.2025.
//

import Foundation

class NetworkManager {
    /// Sends a URLRequest using async/await and returns the raw `Data`.
    func sendRequest(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)

        // Basic validation of HTTP status
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode != 200 {
            throw URLError(.badServerResponse)
        }

        return data
    }
}
