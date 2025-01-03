//
//  ServerConfig.swift
//  SeizureXpert
//
//  Created by Zeynep Aydın on 12/18/24.
//

import Foundation

struct ServerConfig {
    static let baseURL = "http://172.21.192.225:8080/" // Update this as needed

    /// Constructs a full URL for a given path
    static func constructURL(for path: String) -> String {
        return "\(baseURL)\(path)"
    }
}

