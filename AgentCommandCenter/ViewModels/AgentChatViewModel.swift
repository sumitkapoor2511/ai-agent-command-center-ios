import Foundation
import Combine

@MainActor
final class AgentChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = [
        ChatMessage(
            text: "Hello! I am your autonomous n8n + Gemini agent. Ask me to queue a task or check your PostgreSQL database.",
            isUser: false
        )
    ]
    @Published var currentInput: String = ""
    @Published var isSending: Bool = false

    // Persistent session ID per app launch so n8n Simple Memory remembers follow-ups
    let sessionId: String = "ios-\(UUID().uuidString.prefix(8))"

    func sendMessage(onTaskUpdated: @escaping () async -> Void) async {
        let trimmed = currentInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !isSending else { return }

        messages.append(ChatMessage(text: trimmed, isUser: true))
        currentInput = ""
        isSending = true
        defer { isSending = false }

        do {
            let reply = try await APIService.shared.sendAgentCommand(prompt: trimmed, sessionId: sessionId)
            messages.append(ChatMessage(text: reply, isUser: false))
            await onTaskUpdated()
        } catch {
            messages.append(ChatMessage(text: "Error: \(error.localizedDescription)", isUser: false))
        }
    }
}
