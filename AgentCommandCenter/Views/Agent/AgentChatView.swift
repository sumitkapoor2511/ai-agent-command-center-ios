import SwiftUI

struct AgentChatView: View {
    @ObservedObject var chatVM: AgentChatViewModel
    var onTaskUpdated: () async -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(chatVM.messages) { message in
                                HStack {
                                    if message.isUser { Spacer(minLength: 48) }

                                    Text(message.text)
                                        .font(.body)
                                        .padding(12)
                                        .background(message.isUser ? Color.blue : Color(.secondarySystemBackground))
                                        .foregroundStyle(message.isUser ? .white : .primary)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))

                                    if !message.isUser { Spacer(minLength: 48) }
                                }
                                .id(message.id)
                            }

                            if chatVM.isSending {
                                HStack {
                                    ProgressView("Agent thinking...")
                                        .font(.caption)
                                        .padding(10)
                                        .background(Color(.secondarySystemBackground))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                    }
                    .onChange(of: chatVM.messages.count) {
                        if let lastId = chatVM.messages.last?.id {
                            withAnimation { proxy.scrollTo(lastId, anchor: .bottom) }
                        }
                    }
                }

                Divider()

                HStack(spacing: 10) {
                    TextField("Command your AI Agent...", text: $chatVM.currentInput, axis: .vertical)
                        .lineLimit(1...4)
                        .padding(10)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    Button {
                        Task { await chatVM.sendMessage(onTaskUpdated: onTaskUpdated) }
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(chatVM.currentInput.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : .blue)
                    }
                    .disabled(chatVM.isSending || chatVM.currentInput.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()
            }
            .navigationTitle("AI Agent Console")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
