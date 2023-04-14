//
//  ColoredLabel.swift
//  
//
//  Created by Scott Matthewman on 13/04/2023.
//

import SwiftUI

/// A text view with colored background
public struct ColoredLabel<S: StringProtocol>: View {
    @Environment(\.controlSize) private var controlSize
    private var text: S
    private var color: Color

    public init(_ text: S, color: Color) {
        self.text = text
        self.color = color
    }

    public var body: some View {
        Text(text)
            .font(fontSize)
            .fontWeight(fontWeight)
            .foregroundStyle(color.contrastColor)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, 2)
            .background {
                backgroundShape
                    .foregroundStyle(color.gradient)
            }
    }

    private var horizontalPadding: CGFloat {
        switch controlSize {
        case .small, .mini:
            return 4
        default:
            return 10
        }
    }

    private var fontSize: Font {
        switch controlSize {
        case .large:
            return .body
        case .regular:
            return .subheadline
        case .small:
            return .caption
        case .mini:
            return .caption2
        @unknown default:
            return .caption
        }
    }

    private var fontWeight: Font.Weight {
        switch controlSize {
        case .mini:
            return .heavy
        case .small:
            return .bold
        default:
            return .semibold
        }
    }

    @ViewBuilder
    private var backgroundShape: some View {
        switch controlSize {
        case .mini, .small:
            RoundedRectangle(cornerRadius: 4)
        default:
            Capsule()
        }
    }
}

struct ColoredLabel_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 8) {
            ColoredLabel("Library", color: .blue).controlSize(.large)
            ColoredLabel("Musical Theatre", color: .red)
            ColoredLabel("Urgent", color: .purple).controlSize(.small)
            ColoredLabel("+1 NEEDED", color: .yellow).controlSize(.mini)
        }
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
