import Foundation
import Combine

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var tasks: [AutomationTask] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    func loadTasks(token: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            self.tasks = try await APIService.shared.fetchTasks(token: token)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func deleteTask(at offsets: IndexSet, token: String) async {
        for index in offsets {
            let task = tasks[index]
            do {
                try await APIService.shared.deleteTask(id: task.id, token: token)
                tasks.remove(at: index)
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
