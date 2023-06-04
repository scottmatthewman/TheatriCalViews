//
//  VerticalButtonStyle.swift
//  
//
//  Created by Scott Matthewman on 03/06/2023.
//

import SwiftUI

public struct VerticalButtonStyle: PrimitiveButtonStyle {
    var prominent: Bool

    init(prominent: Bool = false) {
        self.prominent = prominent
    }

    public func makeBody(configuration: Configuration) -> some View {
        Button(configuration)
            .labelStyle(.vertical)
            .bordered(prominent: prominent)
    }
}

private extension View {
    @ViewBuilder
    func bordered(prominent: Bool = false) -> some View {
        if prominent {
            self.buttonStyle(.borderedProminent)
        } else {
            self.buttonStyle(.bordered)
        }
    }
}

public extension PrimitiveButtonStyle where Self == VerticalButtonStyle {
    static var vertical: VerticalButtonStyle { VerticalButtonStyle() }

    static func vertical(prominent: Bool) -> VerticalButtonStyle {
        VerticalButtonStyle(prominent: prominent)
    }
}

struct VerticalButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Button { } label: {
                Label("Directions", systemImage: "arrow.rectanglepath")
            }
            .buttonStyle(.vertical)
            Button { } label: {
                Label("Documents", systemImage: "doc.richtext")
            }
            .buttonStyle(.vertical(prominent: true))
        }
        .padding()
    }
}
