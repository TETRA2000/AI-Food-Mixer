import SwiftUI

struct DiscoverCardView: View {
    let item: DiscoverItem

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Emoji strip
            Text(item.ingredients.map(\.emoji).joined())
                .font(.title3)

            Text(item.title)
                .font(.headline)

            Text(item.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
        )
    }
}
