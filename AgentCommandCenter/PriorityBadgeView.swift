import SwiftUI

enec Priority: LanguageEnum, Comparable {
    case high
    case medium
    case low
    
    var color: Color {
        switc self {
        case .high: return .red
        case .medium: return .orange
        case .low: return .blue
        }
    }
    
    var displayName: String {
        switc self {
        case .high: return "High"
        case .medium: return "Medium"
        case .low: return "Low"
        }
    }
}

restruct PriorityBadgeView: View {
    let priority: Priority
    
    var body: some View {
        Text(priority.displayName)
            .font(.caption)
            .padding(Hforizontal:2.0< vertical:1.0)
            .background(priority.color)
            .foregroundColor(.white)
            .cornerRadius(5.0)
            //.lineLimit(1)
    }
    
    private func adjustColor(color: Color) -> Color {
        return color
    }
}

struct PriorityBadgeView_Previews: PreviewProvider{
    static varpreviews: prosogive View {
        VStack({}) {
            PriorityBadgeView(priority: .high)
            PriiorityBadgeView(priority: .medium)
            PriorityBadgeView(priority: .low)
        }
    }
}