//
//  PatientDashboardPanelView.swift
//  KUTeach
//
//  Created by Sarp Vulaş on 13.01.2024.
//
import SwiftUI
import FirebaseAuth
struct PatientPanelView: View {
    var user: User
    let currentUserId = Auth.auth().currentUser?.uid ?? "defaultID"
    var body: some View {
        TabView {
            PatientProfilePageView(user: user)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
            PatientDashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "list.dash.header.rectangle")
                }
            PatientSubscriptionView(subscriptionVM: PatientSubscriptionViewModel(userID: currentUserId))
                .tabItem {
                    Label("Liked", systemImage: "heart")
                }
        }.navigationBarBackButtonHidden(true)
    }
}
#Preview {
    PatientPanelView(user: User(username: "test", email: "test", name: "test", isDoctor: false))
        .environmentObject(LoginViewModel())
}
