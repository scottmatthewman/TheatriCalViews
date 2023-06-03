//
//  VerticalLabeledContentStyle.swift
//  
//
//  Created by Scott Matthewman on 03/06/2023.
//

import SwiftUI

public struct VerticalLabeledContentStyle: LabeledContentStyle {
    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
    }
}

public extension LabeledContentStyle where Self == VerticalLabeledContentStyle {
    static var vertical: VerticalLabeledContentStyle { VerticalLabeledContentStyle() }
}
