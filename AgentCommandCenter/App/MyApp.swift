import SwiftUI

@main
struct MyApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isCheckingSession {
                    // Initial launch splash screen while verifying saved token
                    VStack(spacing: 16) {
                        Image(systemName: "cpu.fill")
                            .font(.system(size: 56))
                            .foregroundStyle(.blue)
                        ProgressView("Connecting to Gateway...")
                            .foregroundStyle(.secondary)
                    }
                } else if authViewModel.isAuthenticated {
                    MainTabView()
                } else {
                    LoginView()
                }
            }
            .environmentObject(authViewModel)
            .animation(.easeInOut(duration: 0.3), value: authViewModel.isAuthenticated)
            .animation(.easeInOut(duration: 0.3), value: authViewModel.isCheckingSession)
            .task {
                // Runs automatically when the app launches
                await authViewModel.checkExistingSession()
            }
        }
    }
}
