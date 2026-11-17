# Product Requirements Document (PRD)

## Overview
**AI Agent Command Center** is a native SwiftUI iOS client that enables developers and operators to securely authenticate, monitor queued automation jobs, and command an autonomous n8n + Google Gemini AI agent in plain English.

## Core User Stories
1. **Persistent Authentication:** As a user, I want to sign in once via FastAPI OAuth2 and stay authenticated across app launches using the iOS Keychain.
2. **Live Task Monitoring:** As a user, I want to view all queued `RAG_Search` and `Data_Extraction` tasks in PostgreSQL with live tab badges, pull-to-refresh, and swipe-to-delete.
3. **Conversational Agent Control:** As a user, I want to create, query, update, and delete tasks via natural-language chat with multi-turn clarification memory.
4. **Automatic Dashboard Sync:** As a user, I want my Dashboard task list to refresh automatically whenever the AI agent modifies database records.
