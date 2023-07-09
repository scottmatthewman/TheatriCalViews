//
//  ColoredLabel.swift
//  
//
//  Created by Scott Matthewman on 13/04/2023.
//

import SwiftUI

public struct ColoredLabel<Title: View>: View {
    @Environment(\.controlSize) private var controlSize
    private var title: Title
    private var color: Color

    public init(color: Color, @ViewBuilder title: () -> Title) {
        self.title = title()
        self.color = color
    }

    public var body: some View {
        title
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
        case .extraLarge:
            return .body
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

public extension ColoredLabel where Title == Text {
    init(_ text: any StringProtocol, color: Color) {
        self.init(color: color) {
            Text(text)
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
