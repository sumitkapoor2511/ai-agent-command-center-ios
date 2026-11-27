import SwiftUI

enum TaskPriority: String, CaseIterable {
    case high
    case medium
    case low

    init(rawPriority: String) {
        self = TaskPriority(rawValue: rawPriority.lowercased()) ?? .medium
    }

    var color: Color {
        switch self {
        case .high: return .red
        case .medium: return .orange
        case .low: return .blue
        }
    }

    var displayName: String {
        rawValue.capitalized
    }
}

struct PriorityBadgeView: View {
    let priority: TaskPriority

    init(priority: TaskPriority) {
        self.priority = priority
    }

    init(priorityString: String) {
        self.priority = TaskPriority(rawPriority: priorityString)
    }

    var body: some View {
        Text(priority.displayName)
            .font(.caption2.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(priority.color.opacity(0.18))
            .foregroundColor(priority.color)
            .clipShape(Capsule())
            .lineLimit(1)
    }
}

#Preview {
    VStack(spacing: 8) {
        PriorityBadgeView(priority: .high)
        PriorityBadgeView(priority: .medium)
        PriorityBadgeView(priority: .low)
    }
    .padding()
}
