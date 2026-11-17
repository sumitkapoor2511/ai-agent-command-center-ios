# Design System & UI Standards

## Visual Hierarchy
- **Navigation:** Native iOS `TabView` (`Dashboard`, `Agent`, `Profile`) wrapped in `NavigationStack`.
- **Feedback States:** Always provide explicit empty states (`ContentUnavailableView`), inline `ProgressView` spinners, and destructive confirmation actions (`Button(role: .destructive)`).

## Components & Layout
- **Form Inputs:** `RoundedRectangle(cornerRadius: 12)` with `Color(.secondarySystemBackground)` fills and `14pt` vertical spacing.
- **Chat Bubbles:** User messages right-aligned in `.blue` with `.white` text; Agent responses left-aligned in `Color(.secondarySystemBackground)` with `.primary` text and automatic `ScrollViewReader` bottom anchoring.
- **Badges:** Live numeric `.badge()` on the Dashboard tab reflecting `dashboardVM.tasks.count`.
