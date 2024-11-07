//
//  StudentSubscriptionView.swift
//  KUTeach
//
//  Created by Sarp Vulaş on 13.01.2024.
//
import SwiftUI
struct StudentSubscriptionView: View {
    @ObservedObject var subscriptionVM: StudentSubscriptionViewModel
    var body: some View {
        ZStack(alignment: .center) {
            BackgroundDS(color1: .cyan, color2: .white)
            if subscriptionVM.isLoading {
                ProgressView()
            } else if subscriptionVM.error != nil {
                Text("Error: \(subscriptionVM.error!.localizedDescription)")
            } else if !subscriptionVM.subscribedVideos.isEmpty {
                Heading1TextBlack(text: "Liked Videos")
                List(subscriptionVM.subscribedVideos, id: \.id) { video in
                    Text(video.videoName)
                    HStack {
                        VideoCellView(video: video)
                        Spacer()
                        ButtonDS(buttonTitle: "Unlike", action: {
                            subscriptionVM.unsubscribeVideo(videoName: video.videoName)
                        }).foregroundColor(.red)
                    }
                }
            } else {
                Text("Liked videos is empty")
            }
        }
        .onAppear {
            subscriptionVM.fetchSubscriptions()
        }
    }
}
#Preview {
    StudentSubscriptionView(subscriptionVM: StudentSubscriptionViewModel(userID: "testID"))
}
