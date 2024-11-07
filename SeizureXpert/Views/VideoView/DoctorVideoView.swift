//
//  DoctorVideoView.swift
//  KUTeach
//
//  Created by Zeynep Aydın on 1/24/24.
//
import Foundation
import SwiftUI
struct DoctorVideoView: View {
    var video: Video
    var body: some View {
        VStack(spacing: 10) {
            Image(video.imageName ?? "image not given")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            Text(video.videoName)
                .font(.title2)
                .fontWeight(.semibold)
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            HStack {
                Label("\(video.viewCount!)", systemImage: "eye.fill")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(video.uploadDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Text(video.videoDescription)
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            Spacer()
            Link(destination: video.url, label: {
                ButtonView(title: "Watch Now", color: Color.red)
            })
            Spacer()
        }
    }
}
