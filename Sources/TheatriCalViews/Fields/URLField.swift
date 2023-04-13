//
//  URLField.swift
//  TheatriCal
//
//  Created by Scott Matthewman on 11/10/2022.
//

import SwiftUI

public struct URLField: View {
    private var titleKey: LocalizedStringKey
    @Binding private var text: String
    private var showPasteButton: PasteButtonDisplayType
    @FocusState private var isFocused: Bool

    public enum PasteButtonDisplayType {
        case never
        case always
        case whenFocused
    }

    public init(
        _ titleKey: LocalizedStringKey = "URL",
        text: Binding<String>,
        showPasteButton: PasteButtonDisplayType = .never
    ) {
        self.titleKey = titleKey
        self._text = text
        self.showPasteButton = showPasteButton
    }

    public var body: some View {
        HStack {
            TextField(titleKey, text: $text, prompt: Text("https://"))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textContentType(.URL)
                .keyboardType(.URL)
                .focused($isFocused)
            if isShowingPasteButton {
                PasteButton(payloadType: URL.self, onPaste: handlePaste(urls:))
                    .labelStyle(.iconOnly)
                    .buttonBorderShape(.capsule)
            }
        }
    }

    private var isShowingPasteButton: Bool {
        switch showPasteButton {
        case .never:
            return false
        case .always:
            return true
        case .whenFocused:
            return isFocused
        }
    }

    private func handlePaste(urls: [URL]) {
        guard let url = urls.first,
              url.absoluteString.starts(with: "https://")
        else { return }

        DispatchQueue.main.async {
            text = url.absoluteString
        }
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
