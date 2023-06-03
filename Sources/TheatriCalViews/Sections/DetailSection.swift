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
/// a text string with an SF Symbol image name, or with a custom view.
public struct DetailSection<
    Label: View,
    Content: View,
    ExtraButton: View
>: View {
    @ViewBuilder private var content: () -> Content
    private var label: () -> Label
    var button: (() -> ExtraButton)?

    public init(
        @ViewBuilder content: @escaping () -> Content,
        label: @escaping () -> Label,
        button: (() -> ExtraButton)? = { EmptyView() }
    ) {
        self.content = content
        self.label = label
        self.button = button
    }

    public var body: some View {
        Section(content: content, header: {
            HStack {
                label()
                Spacer()
                button?()
                    .controlSize(.small )
                    .buttonStyle(.bordered)
            }
        })
        .headerProminence(.increased)
    }
}

public extension DetailSection {
    init(
        _ titleKey: LocalizedStringKey,
        @ViewBuilder content: @escaping () -> Content,
        button: (() -> ExtraButton)? = { EmptyView() }
    ) where Label == Text {
        self.init(
            content: content,
            label: { Text(titleKey) },
            button: button
        )
    }

    init<S>(
        _ title: S,
        @ViewBuilder content: @escaping () -> Content,
        button: (() -> ExtraButton)? = { EmptyView() }
    ) where S: StringProtocol, Label == Text {
        self.init(
            content: content,
            label: { Text(title) },
            button: button
        )
    }

    init(
        _ titleKey: LocalizedStringKey,
        systemImage: String,
        @ViewBuilder content: @escaping () -> Content,
        button: (() -> ExtraButton)? = { EmptyView() }
    ) where Label == SwiftUI.Label<Text, Image> {
        self.init(
            content: content,
            label: { Label(titleKey, systemImage: systemImage) },
            button: button
        )
    }

    init<S>(
        _ title: S,
        systemImage: String,
        @ViewBuilder content: @escaping () -> Content,
        button: (() -> ExtraButton)? = { EmptyView() }
    ) where S: StringProtocol, Label == SwiftUI.Label<Text, Image> {
        self.init(
            content: content,
            label: { Label(title, systemImage: systemImage) },
            button: button
        )
    }
}

struct DetailSection_Previews: PreviewProvider {
    struct Preview: View {
        var body: some View {
            List {
                DetailSection("Address") {
                    Text("20 Sherwood Street, London")
                }

                DetailSection("Address", systemImage: "mappin.circle") {
                    Text("20 Sherwood Street, London")
                }

                DetailSection {
                    Text("20 Sherwood Street, London")
                } label: {
                    Label("My address", systemImage: "person")
                } button: {
                    Button("Import...") { }
                }
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}
