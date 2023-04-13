//
//  CardView.swift
//  
//
//  Created by Scott Matthewman on 13/04/2023.
//

import SwiftUI


public struct CardView<Image: View, Overlay: View, Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme

    var cornerRadius: CGFloat = 10
    @ScaledMetric(relativeTo: .body) var spacing = 6

    @ViewBuilder var image: () -> Image
    @ViewBuilder var overlay: () -> Overlay
    @ViewBuilder var content: () -> Content

    public init(
        cornerRadius: CGFloat = 10,
        spacing: Double = 6,
        @ViewBuilder image: @escaping () -> Image,
        @ViewBuilder overlay: @escaping () -> Overlay,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        _spacing = ScaledMetric(wrappedValue: spacing, relativeTo: .body)
        self.image = image
        self.overlay = overlay
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            image()
                .overlay(alignment: .bottomLeading) {
                    VStack(alignment: .leading, spacing: spacing) {
                        overlay()
                    }
                    .padding(spacing)
                }
            VStack(alignment: .leading, spacing: spacing) {
                content()
            }
            .padding(spacing)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .background(cardBackground)
        .contentShape(Rectangle())
    }

    var cardBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundColor(
                colorScheme == .dark ? .primary : Color(uiColor: .systemBackground)
            )
            .opacity(colorScheme == .dark ? 0.1 : 1.0)
            .shadow(radius: 5)
    }
}

extension CardView {
    public init(
        cornerRadius: CGFloat = 10,
        spacing: Double = 6,
        @ViewBuilder image: @escaping () -> Image,
        @ViewBuilder content: @escaping () -> Content
    ) where Overlay == EmptyView {
        self.cornerRadius = cornerRadius
        _spacing = ScaledMetric(wrappedValue: spacing, relativeTo: .body)
        self.image = image
        self.overlay = { EmptyView() }
        self.content = content
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CardView {
                Image(systemName: "theatermasks")
                    .resizable()
                    .scaledToFit()
            } overlay: {
                Image(systemName: "theatermasks.fill")
                    .foregroundStyle(.tint)
            } content: {
                Text("Shakespeare for Breakfast")
                    .font(.title)
            }

            CardView {
                Color.blue
                    .frame(height: 200)
            } content: {
                Text("Shakespeare for Breakfast")
                    .font(.title)
                Text("C Venues, Edinburgh")
                    .foregroundStyle(.tint)
            }
        }
        .tint(.green)
        .padding()
    }
}
