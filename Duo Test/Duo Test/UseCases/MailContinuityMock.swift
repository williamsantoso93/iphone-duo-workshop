import SwiftUI

/// Inbox alone on the outer display, inbox plus message on the inner display. The selection lives in
/// scene storage, so folding or unfolding the device keeps the same message open.
struct MailContinuityMock: View {
    @SceneStorage("mail.selection") private var selectionID: Int?

    private var selected: MockData.Email? {
        MockData.emails.first { $0.id == selectionID }
    }

    private var unreadCount: Int {
        MockData.emails.count(where: \.isUnread)
    }

    var body: some View {
        NavigationSplitView {
            List(MockData.emails, selection: $selectionID) { email in
                EmailRow(email: email)
                    .tag(email.id)
            }
            .navigationTitle("Inbox")
            .navigationSubtitle("\(unreadCount) unread")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    DismissButton()
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Compose", systemImage: "square.and.pencil") {}
                }
                .visibilityPriority(.high)
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Filter", systemImage: "line.3.horizontal.decrease") {}
                }
                .visibilityPriority(.low)
            }
        } detail: {
            if let selected {
                EmailDetail(email: selected)
            } else {
                ContentUnavailableView("No Message Selected", systemImage: "envelope")
            }
        }
    }
}

private struct EmailRow: View {
    let email: MockData.Email

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: Metrics.compactSpacing) {
            Circle()
                .fill(email.isUnread ? Color.accentColor : .clear)
                .frame(width: 8, height: 8)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .firstTextBaseline) {
                    Text(email.sender)
                        .font(.headline)
                    Spacer()
                    Text(email.time)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(email.subject)
                    .font(.subheadline)
                Text(email.preview)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityValue(email.isUnread ? "Unread" : "")
    }
}

private struct EmailDetail: View {
    let email: MockData.Email

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Metrics.spacing) {
                Text(email.subject)
                    .font(.title2.bold())
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    VStack(alignment: .leading) {
                        Text(email.sender)
                            .font(.headline)
                        Text(email.time)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Text(email.preview)
                Text("Sent from iPhone Duo")
                    .foregroundStyle(.secondary)
            }
            .padding(Metrics.spacing)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Archive", systemImage: "archivebox") {}
                Button("Reply", systemImage: "arrowshape.turn.up.left") {}
            }
        }
    }
}

#Preview {
    MailContinuityMock()
}
