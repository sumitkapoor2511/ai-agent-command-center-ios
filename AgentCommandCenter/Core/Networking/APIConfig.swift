import Foundation

enum APIConfig {
    // Switch easily between iOS Simulator ("http://localhost") and Cloudflare HTTPS Tunnel
    static let baseURL = "http://localhost"

    enum Endpoints {
        static let login = "\(baseURL)/api/v1/auth/login"
        static let tasks = "\(baseURL)/api/v1/tasks"
        static let agentWebhook = "\(baseURL)/webhook/agent-command"
    }
}
