# System Architecture

## Pattern
**MVVM + Service Layer** powered by Swift Concurrency (`async/await`) and SwiftUI `@EnvironmentObject` state injection.

## Multi-Tier Data Flow
1. **iOS Client (`APIService.swift`):** Communicates over HTTP/HTTPS via `URLSession` with `Codable` models (`AutomationTask`, `ChatMessage`).
2. **Gateway (`Nginx`):** Routes `/api/v1/*` requests to FastAPI and `/webhook/*` payloads to n8n on Port 80/443.
3. **API Core (`FastAPI` + `PostgreSQL`):** Validates JWT Bearer tokens and enforces Pydantic v2 schemas.
4. **Agent Engine (`n8n` + `Google Gemini`):** Maintains session memory (`sessionId`) and executes chained CRUD HTTP tool calls against FastAPI.

## Module Boundaries
- `MyApp.swift`: Root lifecycle, session verification (`isCheckingSession`), and auth routing.
- `AuthViewModel.swift`: Login state, error handling, and Apple `Security` framework Keychain CRUD.
- `DashboardViewModel.swift`: Task queue state, loading indicators, and deletion mutations.
- `AgentChatViewModel.swift`: Conversational state, persistent `sessionId`, and post-turn sync callbacks.
