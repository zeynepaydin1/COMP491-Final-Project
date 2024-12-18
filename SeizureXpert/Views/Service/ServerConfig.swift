//
//  ServerConfig.swift
//  SeizureXpert
//
//  Created by Zeynep Aydın on 12/18/24.
//

import Foundation

struct ServerConfig {
    static let baseURL = "http://172.20.10.3:8080/" // Update this as needed

    /// Constructs a full URL for a given path
    static func constructURL(for path: String) -> String {
        return "\(baseURL)\(path)"
    }
}

