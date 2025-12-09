import SwiftUI

public struct ProgressBarView: View {
    let value: Double

    public var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white.opacity(0.2))

                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(red: 1.0, green: 0.97, blue: 0.65))
                    .frame(width: max(0, min(1, value)) * width)
            }
        }
    }
}
