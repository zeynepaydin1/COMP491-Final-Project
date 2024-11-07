//
//  StudentDashboardPanelView.swift
//  KUTeach
//
//  Created by Sarp Vulaş on 13.01.2024.
//
import SwiftUI
import FirebaseAuth
struct StudentPanelView: View {
    var user: User
    let currentUserId = Auth.auth().currentUser?.uid ?? "defaultID"
    var body: some View {
        TabView {
            StudentProfilePageView(user: user)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
            StudentDashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "list.dash.header.rectangle")
                }
            StudentSubscriptionView(subscriptionVM: StudentSubscriptionViewModel(userID: currentUserId))
                .tabItem {
                    Label("Liked", systemImage: "heart")
                }
        }.navigationBarBackButtonHidden(true)
    }
}
#Preview {
    StudentPanelView(user: User(username: "test", email: "test", name: "test", isLecturer: false))
        .environmentObject(LoginViewModel())
}
