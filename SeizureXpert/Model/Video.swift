//
//  Video.swift
//  KUTeach
//
//  Created by Sarp Vulaş on 13.01.2024.
//
import SwiftUI
struct Video: Identifiable {
    let id = UUID()
    let userID: String
    let imageName: String?
    let title: String?
    let description: String?
    let viewCount: Int?
    let uploadDate: String
    let url: URL
    let lectureName: String
    let videoName: String
    let videoDescription: String
}
