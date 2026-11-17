---
name: api-contract-sync
description: Synchronizes Swift Codable models and APIService methods with FastAPI Pydantic schemas and n8n webhook payloads.
---

# API Contract Sync Skill

## Mandatory Pre-Flight Context Check
Before modifying `APIService.swift` or model structs, read:
1. `docs/ARCHITECTURE.md` for endpoint routing (`/api/v1/*` vs. `/webhook/*`).
2. `docs/MEMORY.md` for known FastAPI OAuth2 and n8n payload quirks.

## Execution Workflow
1. Verify HTTP method, path parameters (`String` IDs), and `Bearer \(token)` Authorization headers.
2. Explicitly check for HTTP `401 Unauthorized` and map it to `APIError.unauthorized`.
3. Ensure any mutating operation (`POST`, `PATCH`, `DELETE`, or agent command) triggers a state refresh in `DashboardViewModel`.
4. Document any new endpoint quirks in `docs/MEMORY.md`.
