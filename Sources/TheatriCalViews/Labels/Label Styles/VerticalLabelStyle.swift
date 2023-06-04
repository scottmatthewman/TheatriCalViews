//
//  VerticalLabelStyle.swift
//  
//
//  Created by Scott Matthewman on 03/06/2023.
//

import SwiftUI

public struct VerticalLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 8) {
            configuration.icon
                .frame(maxHeight: 44)
            configuration.title
        }
        .imageScale(.large)
        .frame(maxWidth: .infinity)
    }
}

public extension LabelStyle where Self == VerticalLabelStyle {
    static var vertical: VerticalLabelStyle { VerticalLabelStyle() }
}
