import Foundation

struct AgentPromptRequest: Codable {
    let sessionId: String
    let prompt: String

    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case prompt
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let timestamp = Date()
}
