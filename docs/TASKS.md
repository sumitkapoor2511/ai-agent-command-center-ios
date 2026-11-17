# Implementation Roadmap & Tasks

## Completed Milestones
- [x] **Phase 1:** Root app navigation, `LoginView`, and `AuthViewModel` with Keychain JWT persistence.
- [x] **Phase 2:** Typed `APIService` client wired to FastAPI `/api/v1` and n8n webhook endpoints.
- [x] **Phase 3:** Multi-tab `MainTabView` with live `DashboardViewModel` and stateful `AgentChatViewModel`.
- [x] **Phase 4:** End-to-end verification of Create, Read, Update, and Delete (CRUD) agent tool chaining.
- [x] **Phase 5:** Structured `docs/` context engine and custom `SKILL.md` playbooks.

## Upcoming Enhancements
- [ ] Handle `401 Unauthorized` auto-logout across all `APIService` endpoints.
- [ ] Add rich `agent_type` (`RAG_Search` vs. `Data_Extraction`) and `priority` pills on Dashboard rows.
- [ ] Add manual `+` task creation sheet (`POST /api/v1/tasks`) and quick-prompt chips in Agent Chat.
