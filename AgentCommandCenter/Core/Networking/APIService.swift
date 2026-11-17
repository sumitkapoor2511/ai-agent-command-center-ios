import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case unauthorized
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid server URL."
        case .invalidResponse:
            return "Received an unexpected response from the server."
        case .unauthorized:
            return "Your session has expired. Please sign in again."
        case .serverError(let message):
            return message
        }
    }
}

final class APIService {
    static let shared = APIService()
    private init() {}

    // Matches http://localhost/docs
    private let baseURL = "http://localhost/api/v1"
    private let n8nWebhookURL = "http://localhost/webhook/agent-command"

    // MARK: - 1. Authentication (POST /api/v1/auth/login)
    func login(email: String, password: String) async throws -> String {
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "username", value: email),
            URLQueryItem(name: "password", value: password)
        ]
        request.httpBody = components.query?.data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let serverMsg = String(data: data, encoding: .utf8) ?? "Invalid credentials."
            throw APIError.serverError(serverMsg)
        }

        struct LoginResponse: Decodable {
            let access_token: String
        }

        let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)
        return decoded.access_token
    }

    // MARK: - 2. Agent Chat
    func sendAgentCommand(prompt: String, sessionId: String) async throws -> String {
        guard let url = URL(string: n8nWebhookURL) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = ["prompt": prompt, "sessionId": sessionId]
        request.httpBody = try JSONEncoder().encode(payload)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError("Agent gateway failed to respond.")
        }

        struct AgentResponse: Decodable {
            let output: String?
            let reply: String?
            let text: String?
        }

        if let decoded = try? JSONDecoder().decode(AgentResponse.self, from: data) {
            return decoded.output ?? decoded.reply ?? decoded.text ?? "Command processed."
        }
        return String(data: data, encoding: .utf8) ?? "Command processed."
    }

    // MARK: - 3. Fetch Tasks (GET /api/v1/tasks)
    func fetchTasks(token: String) async throws -> [AutomationTask] {
        guard let url = URL(string: "\(baseURL)/tasks") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        if httpResponse.statusCode == 401 {
            throw APIError.unauthorized
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError("Failed to fetch tasks.")
        }

        return try JSONDecoder().decode([AutomationTask].self, from: data)
    }

    // MARK: - 4. Delete Task (DELETE /api/v1/tasks/{task_id})
    func deleteTask(id: String, token: String) async throws {
        guard let url = URL(string: "\(baseURL)/tasks/\(id)") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError("Failed to delete task.")
        }
    }
}
