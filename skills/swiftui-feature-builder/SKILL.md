---
name: swiftui-feature-builder
description: Builds new SwiftUI views and ViewModels adhering to project architecture, Keychain security, and design standards.
---

# SwiftUI Feature Builder Skill

## Mandatory Pre-Flight Context Check
Before generating or modifying any Swift file, read:
1. `docs/ARCHITECTURE.md` to verify module boundaries.
2. `docs/RULES.md` to enforce `@MainActor`, Keychain security, and error handling.
3. `docs/DESIGN.md` to match corner radii, colors, and empty/loading states.

## Execution Workflow
1. Check `docs/TASKS.md` for the next unchecked `[ ]` UI or ViewModel requirement.
2. Build or update the `ObservableObject` ViewModel with `@MainActor` and `defer { isLoading = false }`.
3. Build the SwiftUI View using `@EnvironmentObject var authVM: AuthViewModel` for token access—never pass raw tokens down multiple view layers if `EnvironmentObject` is available.
4. Include a `#Preview` block with mock environment objects so Xcode Canvas compiles cleanly.
5. Update `docs/TASKS.md` (`[x]`) and log any new architectural decisions in `docs/MEMORY.md`.
