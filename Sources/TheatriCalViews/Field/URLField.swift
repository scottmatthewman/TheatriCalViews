//
//  URLField.swift
//  TheatriCal
//
//  Created by Scott Matthewman on 11/10/2022.
//

import Observation
import SwiftUI

@Observable
internal class URLFieldModel {
    @ObservationIgnored var text: Binding<String>
    var isFocused: Bool = false
    var showPasteButton: PasteButtonDisplayType = .whenFocused

    init(
        text: Binding<String>,
        isFocused: Bool,
        showPasteButton: PasteButtonDisplayType
    ) {
        self.text = text
        self.isFocused = isFocused
        self.showPasteButton = showPasteButton
    }

    func handlePaste(urls: [URL]) async {
        guard let url = urls.first,
              url.absoluteString.starts(with: "https://")
        else { return }

        text.wrappedValue = url.absoluteString
    }

    var isShowingPasteButton: Bool {
        switch showPasteButton {
        case .never:
            return false
        case .always:
            return true
        case .whenFocused:
            return isFocused
        }
    }
}

/// The visibility option of a paste button on the trailing edge of a ``URLField``.
public enum PasteButtonDisplayType {
    /// Never display a paste button.
    case never
    /// Always display a paste button.
    case always
    /// Only display a paste button when the form focus is inside the ``URLField``.
    case whenFocused
}

/// A text field geared to the input of URLs.
///
/// This is a drop-in replacement for `TextField` wherever URLs are required as input.
/// The following traits are automatically added:
/// - the placeholder prompt is set to **http://**
/// - autocorrection is disabled
/// - capitalisation is disabled
/// - the text content type is set to `.URL`
/// - the keyboard type is set to `.URL`
///
/// In addition, the field also supports the display and use of a paste button. When visible,
/// it will become active when a URL is on the clipboard.
public struct URLField<Label: View>: View {
    private var label: () -> Label
    private var showPasteButton: PasteButtonDisplayType
    @FocusState private var isFocused: Bool

    @State private var model: URLFieldModel

    /// Create a `TextField` geared towards URL entry.
    /// - Parameters:
    ///   - text: the URL to display and edit.
    ///   - showPasteButton: whether (and when) to show a paste button.
    ///   - label: A view that describes the purpose of the URL field.
    public init(
        text: Binding<String>,
        showPasteButton: PasteButtonDisplayType = .never,
        label: @escaping () -> Label
    ) {
        let model = URLFieldModel(
            text: text,
            isFocused: false,
            showPasteButton: showPasteButton
        )
        self._model = State(wrappedValue: model)

        self.label = label
        self.showPasteButton = showPasteButton
    }

    public var body: some View {
        HStack {
            TextField(text: model.text, prompt: Text("https://"), label: label)
                #if os(iOS)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textContentType(.URL)
                .keyboardType(.URL)
                #endif
                .focused($isFocused)
            if model.isShowingPasteButton {
                PasteButton(payloadType: URL.self) { urls in
                    Task { await model.handlePaste(urls: urls) }
                }
                .labelStyle(.iconOnly)
                .buttonBorderShape(.capsule)
            }
        }
        .onChange(of: model.isFocused) { isFocused = model.isFocused }
        .onChange(of: isFocused) { model.isFocused = isFocused }
    }
}

public extension URLField {
    init(
        _ titleKey: LocalizedStringKey = "URL",
        text: Binding<String>,
        showPasteButton: PasteButtonDisplayType = .never
    ) where Label == Text {
        self.init(
            text: text,
            showPasteButton: showPasteButton,
            label: { Text(titleKey) }
        )
    }
}

struct URLField_Previews: PreviewProvider {
    struct Preview: View {
        @State var url = ""

        var body: some View {
            Form {
                URLField(text: $url)
                URLField(text: $url, showPasteButton: .always)
                URLField(text: $url, showPasteButton: .whenFocused)
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}
