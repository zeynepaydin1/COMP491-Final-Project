//
//  VideoCellView.swift
//  KUTeach
//
//  Created by Sarp Vulaş on 13.01.2024.
//
import SwiftUI
struct VideoCellView: View {
    var video: Video
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Lecture: \(video.lectureName)")
            Text(video.videoDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(video.videoName)
                    .fontWeight(.semibold)
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    .minimumScaleFactor(0.5)

                Text(video.uploadDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
