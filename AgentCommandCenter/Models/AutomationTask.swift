import Foundation

struct AutomationTask: Codable, Identifiable {
    let id: String
    let title: String
    let agentType: String
    let priority: Int
    let status: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, title, priority, status
        case agentType = "agent_type"
        case createdAt = "created_at"
    }
}
