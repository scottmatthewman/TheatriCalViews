//
//  OptionalField.swift
//  
//
//  Created by Scott Matthewman on 03/06/2023.
//

import SwiftUI

public struct OptionalField<Value: Equatable, Label: View, Content: View>: View {
    @Binding private var selection: Value?
    @State private var isSelected: Bool
    @State private var value: Value
    private var content: (Binding<Value>) -> Content
    private var label: () -> Label

    public init(
        selection: Binding<Value?>,
        defaultValue: Value,
        @ViewBuilder content: @escaping (Binding<Value>) -> Content,
        label: @escaping () -> Label
    ) {
        self._selection = selection
        self._isSelected = State(initialValue: selection.wrappedValue != nil)
        self._value = State(initialValue: selection.wrappedValue ?? defaultValue)
        self.content = content
        self.label = label
    }

    public var body: some View {
        Group {
            Toggle(isOn: $isSelected.animation(), label: label)
            if isSelected {
                content($value)
            }
        }
        .onChange(of: isSelected) { _ in updateBoundValue() }
        .onChange(of: value) { _ in updateBoundValue() }
    }

    private func updateBoundValue() {
        if isSelected {
            selection = .some(value)
        } else {
            selection = .none
        }
    }
}
