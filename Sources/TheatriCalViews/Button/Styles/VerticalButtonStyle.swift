//
//  VerticalButtonStyle.swift
//  
//
//  Created by Scott Matthewman on 03/06/2023.
//

import SwiftUI

public struct VerticalButtonStyle: PrimitiveButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        Button(configuration)
            .labelStyle(.vertical)
    }
}

public extension PrimitiveButtonStyle where Self == VerticalButtonStyle {
    static var vertical: VerticalButtonStyle { VerticalButtonStyle() }
}
