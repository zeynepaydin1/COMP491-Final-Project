//
//  PatientDashboardView.swift
//  KUTeach
//
//  Created by Sarp Vulaş on 13.01.2024.
//
import SwiftUI
import FirebaseAuth
struct PatientDashboardView: View {
    @StateObject var viewModel = PatientDashboardViewModel()
    @State private var searchTerm = ""
    @StateObject var subscriptionVM: PatientSubscriptionViewModel
    init() {
        let currentUserId = Auth.auth().currentUser?.uid ?? "defaultID"
        _subscriptionVM = StateObject(wrappedValue: PatientSubscriptionViewModel(userID: currentUserId))
    }
    var filteredSearchTerms: [Video] {
        guard !searchTerm.isEmpty else { return viewModel.videos }
        return viewModel.videos.filter { $0.videoName.localizedCaseInsensitiveContains(searchTerm) }
    }
    var body: some View {
            VStack {
                NavigationView {
                    List(filteredSearchTerms, id: \.id) { video in
                        NavigationLink(destination:
                                        PatientVideoView(video: video,
                                                         userID: subscriptionVM.userID,
                                                         subscriptionVM:
                                                            PatientSubscriptionViewModel(userID:
                                                                                            subscriptionVM.userID))) {
                            VideoCellView(video: video)
                        }
                    }
                    .navigationTitle("Courses")
                    .navigationBarTitleDisplayMode(.inline)
                    .searchable(text: $searchTerm)
                    .onAppear {
                        viewModel.fetchAllVideos()
                    }
                }
            }
        }
}
#Preview {
    PatientDashboardView().environmentObject(LoginViewModel())
}
