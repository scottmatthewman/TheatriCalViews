//
//  FixedAspectRatio.swift
//  TheatriCal iOS
//
//  Created by Scott Matthewman on 30/07/2023.
//

import SwiftUI

struct FixedAspectRatio: ViewModifier {
    var aspectRatio: CGFloat = 1.0
    var contentMode: ContentMode = .fill

    func body(content: Content) -> some View {
        Color.clear
            .aspectRatio(aspectRatio, contentMode: .fit)
            .overlay {
                content
                    .aspectRatio(contentMode: contentMode)
            }
            .clipShape(.rect)
    }
}

public extension View {
    func fixedAspectRatio(
        _ aspectRatio: CGFloat,
        contentMode: ContentMode = .fill
    ) -> some View {
        self
            .modifier(
                FixedAspectRatio(
                    aspectRatio: aspectRatio,
                    contentMode: contentMode
                )
            )
    }
}

public extension Image {
    func fillAspectRatio(_ aspectRatio: CGFloat) -> some View {
        self
            .resizable()
            .fixedAspectRatio(aspectRatio, contentMode: .fill)
    }
}
