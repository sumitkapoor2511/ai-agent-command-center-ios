import SwiftUI

struct TaskRowView: View {
    let task: AutomationTask

    private var priorityColor: Color {
        switch task.priority {
        case 4...5: return .red
        case 3: return .orange
        default: return .blue
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(task.title)
                    .font(.headline)
                Spacer()
                Text("P\(task.priority)")
                    .font(.caption.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(priorityColor.opacity(0.15))
                    .foregroundStyle(priorityColor)
                    .clipShape(Capsule())
            }

            HStack(spacing: 12) {
                Label(task.agentType, systemImage: "sparkles")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Text(task.status.uppercased())
                    .font(.caption2.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.green.opacity(0.15))
                    .foregroundStyle(.green)
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 4)
    }
}
