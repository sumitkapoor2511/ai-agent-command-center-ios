import Foundation
import Combine
import Security

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var authToken: String? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isCheckingSession: Bool = true
    
    private let tokenKey = "com.myapp.fastapi.jwt"
    
    var isAuthenticated: Bool {
        authToken != nil
    }

    func login() async {
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanEmail.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password."
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let token = try await APIService.shared.login(email: cleanEmail, password: password)
            saveTokenToKeychain(token)
            self.authToken = token
            self.password = "" // Clear password from memory after successful login
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func logout() {
        deleteTokenFromKeychain()
        authToken = nil
        password = ""
        errorMessage = nil
    }
    
    func checkExistingSession() async {
        defer { isCheckingSession = false }
        
        guard let savedToken = loadTokenFromKeychain(), !savedToken.isEmpty else {
            return
        }

        do {
            // Verify token is still valid by making an authenticated call
            _ = try await APIService.shared.fetchTasks(token: savedToken)
            self.authToken = savedToken
        } catch APIError.unauthorized {
            // Token expired overnight -> clear Keychain so LoginView opens cleanly
            deleteTokenFromKeychain()
            self.authToken = nil
            self.errorMessage = "Session expired. Please sign in again."
        } catch {
            // If server is temporarily unreachable, keep token so user isn't locked out
            self.authToken = savedToken
        }
    }

    // MARK: - Keychain Helpers
    
    private func saveTokenToKeychain(_ token: String) {
        guard let data = token.data(using: .utf8) else { return }
        deleteTokenFromKeychain() // Remove any existing token first
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecValueData as String: data
        ]
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func loadTokenFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let data = item as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    private func deleteTokenFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey
        ]
        SecItemDelete(query as CFDictionary)
    }
}
