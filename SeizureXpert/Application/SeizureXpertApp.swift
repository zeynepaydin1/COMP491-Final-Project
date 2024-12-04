import SwiftUI

@main
struct SeizureXpertApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var loginViewModel = LoginViewModel()

    var body: some Scene {
        WindowGroup {
            AppFlowView()
                .environmentObject(loginViewModel)
        }
    }
}
