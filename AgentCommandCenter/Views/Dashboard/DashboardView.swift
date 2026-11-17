import SwiftUI

struct DashboardView: View {
    @ObservedObject var authVM: AuthViewModel
    @ObservedObject var dashboardVM: DashboardViewModel

    var body: some View {
        NavigationStack {
            Group {
                if dashboardVM.isLoading && dashboardVM.tasks.isEmpty {
                    ProgressView("Loading PostgreSQL Tasks...")
                } else if dashboardVM.tasks.isEmpty {
                    ContentUnavailableView(
                        "No Active Tasks",
                        systemImage: "tray",
                        description: Text("Switch to the AI Agent tab to dispatch a new workflow.")
                    )
                } else {
                    List {
                        ForEach(dashboardVM.tasks) { task in
                            TaskRowView(task: task)
                        }
                        .onDelete { offsets in
                            guard let token = authVM.authToken else { return }
                            Task { await dashboardVM.deleteTask(at: offsets, token: token) }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Operations")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Logout") { authVM.logout() }
                        .foregroundStyle(.red)
                }
            }
            .refreshable {
                if let token = authVM.authToken {
                    await dashboardVM.loadTasks(token: token)
                }
            }
            .task {
                if let token = authVM.authToken {
                    await dashboardVM.loadTasks(token: token)
                }
            }
        }
    }
}
