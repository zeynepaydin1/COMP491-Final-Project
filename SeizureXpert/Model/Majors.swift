//
//  Majors.swift
//  KUTeach
//
//  Created by Sarp Vulaş on 13.01.2024.
//
import SwiftUI
struct Major {
    let id = UUID()
    let imageName: String
    let title: String
    let videos: [String]
}
struct MajorList {
    static let topTen = [
        Major(imageName: "wish-i-knew",
              title: "9 Things I Wish I Knew When I Started Programming",
              videos: ["1"])
    ]
}
