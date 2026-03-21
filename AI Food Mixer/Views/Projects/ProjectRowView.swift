import SwiftUI

struct ProjectRowView: View {
    let project: Project

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(project.title)
                .font(.headline)

            HStack(spacing: 12) {
                // Emoji strip
                Text(String(project.ingredientEmojis.prefix(8)))
                    .font(.caption)

                Spacer()

                // Metadata
                Text("\(project.wordCount) words")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Text(project.updatedAt, style: .date)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(project.title), \(project.wordCount) words")
    }
}
