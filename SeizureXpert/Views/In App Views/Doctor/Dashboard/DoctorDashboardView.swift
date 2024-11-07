//
//  LecturerDashboardView.swift
//  KUTeach
//
//  Created by Zeynep Aydın on 1/23/24.
//
import Foundation
import SwiftUI
struct LecturerDashboardView: View {
    @StateObject var viewModel = LecturerDashboardViewModel()
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State private var searchTerm = ""
    var body: some View {
        VStack {
            NavigationView {
                List(filteredSearchTerms, id: \.id) { video in
                    NavigationLink(destination: LecturerVideoView(video: video), label: {
                        VideoCellView(video: video)
                    })
                }.navigationTitle("My Courses")
                    .navigationBarTitleDisplayMode(.inline)
                    .searchable(text: $searchTerm)
            }
        }.onAppear {
            if let lecturerID = loginViewModel.currentUserId {
                viewModel.fetchVideosForLecturer(lecturerID: lecturerID)
            }
        }
    }
    var filteredSearchTerms: [Video] {
            guard !searchTerm.isEmpty else {return viewModel.videos}
            return viewModel.videos.filter {$0.videoName.localizedCaseInsensitiveContains(searchTerm)}
        }
}
#Preview {
    LecturerDashboardView().environmentObject(LoginViewModel())
}
