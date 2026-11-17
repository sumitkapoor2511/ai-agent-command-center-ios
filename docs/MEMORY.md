# Project Memory & Architectural Decision Log

## Resolved Issues & Lessons Learned
- **FastAPI OAuth2 Payload Format:** Swagger `/api/v1/auth/login` uses `OAuth2PasswordRequestForm`, which expects `application/x-www-form-urlencoded` with key `username` (even when passing an email address) rather than JSON.
- **Port 80 Reverse Proxy Routing:** Nginx exposes FastAPI directly on `http://localhost/api/v1` (Port 80) rather than `:8000`.
- **n8n AI Agent Payload Keys:** Sending both `"prompt"` and `"chatInput"` alongside `"sessionId"` ensures compatibility across n8n Webhook and Chat Trigger nodes.
- **n8n Tool Chaining (`PATCH`):** FastAPI `PATCH /api/v1/tasks/{task_id}` requires both `status` and `priority`. The agent must call `list_tasks` first to preserve existing field values when only one field is updated.
- **Gemini Free-Tier Rate Limits (HTTP 429):** Multi-tool agent turns trigger 2–3 LLM calls per message. Using `gemini-2.5-flash` with `Retry On Fail` (3 tries, 5000ms delay) prevents transient throttling.
