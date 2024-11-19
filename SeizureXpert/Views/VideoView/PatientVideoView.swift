//
//  VideoView.swift
//  KUTeach
//
//  Created by Sarp Vulaş on 13.01.2024.
//
import SwiftUI
struct PatientVideoView: View {
    var video: Video
    var userID: String
    @ObservedObject var subscriptionVM: PatientSubscriptionViewModel
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
            Button("Like") {
                        subscriptionVM.subscribeTo(video: video)
                    }
            Link(destination: video.url, label: {
                ButtonView(title: "Watch Now", color: Color.red)
            })
            Spacer()
        }
    }
}
