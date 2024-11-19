//
//  DoctorDashboardView.swift
//  KUTeach
//
//  Created by Zeynep Aydın on 1/23/24.
//
import Foundation
import SwiftUI
struct DoctorDashboardView: View {
    @StateObject var viewModel = DoctorDashboardViewModel()
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State private var searchTerm = ""
    var body: some View {
        VStack {
            NavigationView {
                List(filteredSearchTerms, id: \.id) { video in
                    NavigationLink(destination: DoctorVideoView(video: video), label: {
                        VideoCellView(video: video)
                    })
                }.navigationTitle("My Courses")
                    .navigationBarTitleDisplayMode(.inline)
                    .searchable(text: $searchTerm)
            }
        }.onAppear {
            if let DoctorID = loginViewModel.currentUserId {
                viewModel.fetchVideosForDoctor(DoctorID: DoctorID)
            }
        }
    }
    var filteredSearchTerms: [Video] {
            guard !searchTerm.isEmpty else {return viewModel.videos}
            return viewModel.videos.filter {$0.videoName.localizedCaseInsensitiveContains(searchTerm)}
        }
}
#Preview {
    DoctorDashboardView().environmentObject(LoginViewModel())
}
