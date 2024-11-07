//
//  LecturerPanelView.swift
//  KUTeach
//
//  Created by Zeynep Aydın on 1/23/24.
//
import Foundation
import SwiftUI
struct LecturerPanelView: View {
    var user: User
    var body: some View {
        TabView {
            LecturerProfilePageView(user: user)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
            LecturerDashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "list.dash.header.rectangle")
                }
            UploadLectureView()
                .tabItem {
                    Label("Upload", systemImage: "square.and.arrow.up.circle")
                }
        }.navigationBarBackButtonHidden(true)
    }
}
#Preview {
    LecturerPanelView(user: User(username: "test", email: "test", name: "test", isLecturer: true))
        .environmentObject(LoginViewModel())
}
