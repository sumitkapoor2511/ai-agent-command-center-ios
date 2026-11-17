# Engineering Rules & Guardrails

## Swift & Concurrency
- All `ObservableObject` ViewModels MUST be annotated with `@MainActor`.
- Use structured `async/await` with `defer { isLoading = false }` so loading spinners never hang on thrown errors.
- Avoid third-party networking or Keychain libraries; use native `URLSession` and Apple's `Security` framework.

## Security & Authentication
- NEVER store JWT access tokens or passwords in `UserDefaults` or `@AppStorage`. Always use iOS Keychain (`kSecClassGenericPassword`).
- Clear plain-text `password` strings from memory immediately after a successful `login()` call.
- On HTTP `401 Unauthorized`, purge the stale Keychain token and route cleanly back to `LoginView`.

## API & Schema Integrity
- Trim whitespace and newlines from user email inputs before sending network requests.
- FastAPI OAuth2 login requires `application/x-www-form-urlencoded` with `username` and `password` fields—not JSON.
- Always trigger `dashboardVM.loadTasks(token:)` after any mutating agent chat response.
