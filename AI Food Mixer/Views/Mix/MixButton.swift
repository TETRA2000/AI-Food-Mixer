import SwiftUI

struct MixButton: View {
    let count: Int
    let action: () -> Void

    @State private var isPulsing = false

    private var isEnabled: Bool { count > 0 }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: "frying.pan.fill")
                    .font(.title3)
                Text(isEnabled ? "Mix \(count) Ingredient\(count == 1 ? "" : "s")" : "Select Ingredients to Mix")
                    .font(.headline)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isEnabled
                            ? LinearGradient(colors: [Color(hex: "#FF922B"), Color(hex: "#E03131")], startPoint: .leading, endPoint: .trailing)
                            : LinearGradient(colors: [.gray.opacity(0.4), .gray.opacity(0.3)], startPoint: .leading, endPoint: .trailing)
                    )
            )
            .scaleEffect(isPulsing && isEnabled ? 1.02 : 1.0)
            .shadow(
                color: isEnabled ? Color(hex: "#FF922B").opacity(0.3) : .clear,
                radius: isPulsing ? 12 : 6,
                y: 4
            )
        }
        .disabled(!isEnabled)
        .padding(.horizontal)
        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isPulsing)
        .onAppear { isPulsing = true }
        .accessibilityLabel(isEnabled ? "Mix \(count) ingredients" : "Select ingredients to mix")
    }
}

#Preview {
    VStack(spacing: 20) {
        MixButton(count: 0, action: {})
        MixButton(count: 5, action: {})
    }
    .padding()
}
