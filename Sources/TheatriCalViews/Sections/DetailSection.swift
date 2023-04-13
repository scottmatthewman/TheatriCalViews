//
//  DetailSection.swift
//  
//
//  Created by Scott Matthewman on 13/04/2023.
//

import SwiftUI

/// A collapsible view, with optional button in the header
///
/// You can create a `DetailSection` with a header defined by a single text string,
/// a text string with an SF Symbol image name, or with a custom view. The header is
/// displayed aligned to the leading edge of the group box, with a discloure triangle on
/// the trailing edge. Clicking anywhere on the header (including any empty space
/// between the heading and disclsure indicator toggles the detail section to be
/// shown or hidden.
///
/// By default the detail section is visible when first rendered. This can be overridden by
/// passing a `startsExpanded: false` parameter. Note this is not a bound value, so
/// navigating away from a parent view and returning will reset the panel's visible state.
public struct DetailSection<
    Label: View,
    Content: View,
    ExtraButton: View
>: View {
    private var startsExpanded: Bool
    @ViewBuilder private var content: () -> Content
    private var label: () -> Label
    var button: (() -> ExtraButton)?

    public init(
        startsExpanded: Bool = true,
        @ViewBuilder content: @escaping () -> Content,
        label: @escaping () -> Label,
        button: (() -> ExtraButton)? = { EmptyView() }
    ) {
        self.startsExpanded = startsExpanded
        self.content = content
        self.label = label
        self.button = button
    }

    public var body: some View {
        GroupBox(content: content, label: label)
            .groupBoxStyle(DetailSectionGroupBoxStyle(startsExpanded: startsExpanded, button: button))
    }
}

private struct DetailSectionGroupBoxStyle<Button: View>: GroupBoxStyle {
    private var button: (() -> Button)?
    @State private var isExpanded: Bool

    init(
        startsExpanded: Bool = true,
        button: (() -> Button)?
    ) {
        _isExpanded = State(initialValue: startsExpanded)
        self.button = button
    }

    func makeBody(configuration: Configuration) -> some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            VStack(alignment: .leading, spacing: 8) {
                configuration.content
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        } label: {
            HStack {
                configuration.label
                    .bold()
                Spacer()
                button?()
                    .controlSize(.small)
                    .buttonStyle(.bordered)
            }
        }
    }
}

public extension DetailSection {
    init(
        _ titleKey: LocalizedStringKey,
        startsExpanded: Bool = true,
        @ViewBuilder content: @escaping () -> Content,
        button: (() -> ExtraButton)? = { EmptyView() }
    ) where Label == Text {
        self.init(
            startsExpanded: startsExpanded,
            content: content,
            label: { Text(titleKey) },
            button: button
        )
    }

    init<S>(
        _ title: S,
        startsExpanded: Bool = true,
        @ViewBuilder content: @escaping () -> Content,
        button: (() -> ExtraButton)? = { EmptyView() }
    ) where S: StringProtocol, Label == Text {
        self.init(
            startsExpanded: startsExpanded,
            content: content,
            label: { Text(title) },
            button: button
        )
    }

    init(
        _ titleKey: LocalizedStringKey,
        systemImage: String,
        startsExpanded: Bool = true,
        @ViewBuilder content: @escaping () -> Content,
        button: (() -> ExtraButton)? = { EmptyView() }
    ) where Label == SwiftUI.Label<Text, Image> {
        self.init(
            startsExpanded: startsExpanded,
            content: content,
            label: { Label(titleKey, systemImage: systemImage) },
            button: button
        )
    }

    init<S>(
        _ title: S,
        systemImage: String,
        startsExpanded: Bool = true,
        @ViewBuilder content: @escaping () -> Content,
        button: (() -> ExtraButton)? = { EmptyView() }
    ) where S: StringProtocol, Label == SwiftUI.Label<Text, Image> {
        self.init(
            startsExpanded: startsExpanded,
            content: content,
            label: { Label(title, systemImage: systemImage) },
            button: button
        )
    }
}

struct DetailSection_Previews: PreviewProvider {
    struct Preview: View {
        var body: some View {
            VStack {
                DetailSection("Address") {
                    Text("20 Sherwood Street, London")
                }

                Divider()

                DetailSection("Address", systemImage: "mappin.circle") {
                    Text("20 Sherwood Street, London")
                }

                Divider()

                DetailSection(startsExpanded: false) {
                    Text("20 Sherwood Street, London")
                } label: {
                    Label("My address", systemImage: "person")
                } button: {
                    Button("Import...") { }
                }
            }
            .padding()
        }
    }

    static var previews: some View {
        Preview()
    }
}
