import SwiftUI

enum AppTab: Hashable {
    case dashboard
    case agentChat
    case profile
}

struct MainTabView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var dashboardVM = DashboardViewModel()
    @StateObject private var chatVM = AgentChatViewModel()
    @State private var selectedTab: AppTab = .dashboard

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Dashboard", systemImage: "checklist", value: .dashboard) {
                NavigationStack {
                    DashboardTabView(dashboardVM: dashboardVM)
                }
            }
            .badge(dashboardVM.tasks.count)

            Tab("Agent", systemImage: "cpu.fill", value: .agentChat) {
                NavigationStack {
                    AgentChatTabView(chatVM: chatVM) {
                        if let token = authVM.authToken {
                            await dashboardVM.loadTasks(token: token)
                        }
                    }
                }
            }

            Tab("Profile", systemImage: "person.fill", value: .profile) {
                NavigationStack {
                    ProfileTabView()
                }
            }
        }
        .task {
            if let token = authVM.authToken {
                await dashboardVM.loadTasks(token: token)
            }
        }
    }
}

// MARK: - 1. Dashboard Tab View
struct DashboardTabView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @ObservedObject var dashboardVM: DashboardViewModel

    var body: some View {
        Group {
            if dashboardVM.isLoading && dashboardVM.tasks.isEmpty {
                ProgressView("Loading tasks...")
            } else if dashboardVM.tasks.isEmpty {
                ContentUnavailableView(
                    "No Tasks Queued",
                    systemImage: "tray",
                    description: Text("Ask your Agent in the next tab to queue a task.")
                )
            } else {
                List {
                    ForEach(dashboardVM.tasks) { task in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(task.title)
                                .font(.headline)
                            Text(task.status)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete { offsets in
                        guard let token = authVM.authToken else { return }
                        Task {
                            await dashboardVM.deleteTask(at: offsets, token: token)
                        }
                    }
                }
                .refreshable {
                    if let token = authVM.authToken {
                        await dashboardVM.loadTasks(token: token)
                    }
                }
            }
        }
        .navigationTitle("Tasks")
    }
}

// MARK: - 2. Agent Chat Tab View
struct AgentChatTabView: View {
    @ObservedObject var chatVM: AgentChatViewModel
    var onTaskUpdated: () async -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(chatVM.messages) { msg in
                            HStack {
                                if msg.isUser { Spacer() }
                                Text(msg.text)
                                    .padding(12)
                                    .background(msg.isUser ? Color.blue : Color(.secondarySystemBackground))
                                    .foregroundStyle(msg.isUser ? .white : .primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                if !msg.isUser { Spacer() }
                            }
                            .id(msg.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: chatVM.messages.count) { _, _ in
                    if let lastId = chatVM.messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            HStack(spacing: 10) {
                TextField("Command n8n + Gemini agent...", text: $chatVM.currentInput)
                    .textFieldStyle(.roundedBorder)
                    .disabled(chatVM.isSending)

                Button {
                    Task {
                        await chatVM.sendMessage(onTaskUpdated: onTaskUpdated)
                    }
                } label: {
                    if chatVM.isSending {
                        ProgressView()
                    } else {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                    }
                }
                .disabled(chatVM.currentInput.trimmingCharacters(in: .whitespaces).isEmpty || chatVM.isSending)
            }
            .padding()
        }
        .navigationTitle("Agent Chat")
    }
}

// MARK: - 3. Profile & Sign Out Tab View
struct ProfileTabView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        Form {
            Section("Account") {
                LabeledContent("Email", value: authVM.email.isEmpty ? "Authenticated User" : authVM.email)
                LabeledContent("Gateway", value: "FastAPI + n8n")
            }

            Section {
                Button(role: .destructive) {
                    authVM.logout()
                } label: {
                    HStack {
                        Spacer()
                        Text("Sign Out")
                            .bold()
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Profile")
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
}
