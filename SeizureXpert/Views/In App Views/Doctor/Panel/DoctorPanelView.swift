//
//  DoctorPanelView.swift
//  KUTeach
//
//  Created by Zeynep Aydın on 1/23/24.
//
import Foundation
import SwiftUI
struct DoctorPanelView: View {
    var user: User
    var body: some View {
        TabView {
            DoctorProfilePageView(user: user)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
            DoctorDashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "list.dash.header.rectangle")
                }
            UploadDataView()
                .tabItem {
                    Label("Upload", systemImage: "square.and.arrow.up.circle")
                }
        }.navigationBarBackButtonHidden(true)
    }
}
#Preview {
    DoctorPanelView(user: User(username: "test", email: "test", name: "test", isDoctor: true))
        .environmentObject(LoginViewModel())
}
