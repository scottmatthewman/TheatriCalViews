//
//  ImagePicker.swift
//  
//
//  Created by Scott Matthewman on 13/04/2023.
//

import PhotosUI
import SwiftUI

/// A custom wrapper around PhotoPicker that allows for the selection of an image.
public struct ImagePicker: View {
    @Binding var uiImage: UIImage?
    private var titleKey: LocalizedStringKey
    @StateObject private var imageModel = ImagePickerModel()

    /// Creates an ImagePicker button bound to an optional `UIImage`. When the bound
    /// variable is `nil`, displays a button that activates a `PhotoPicker`. When the
    /// variable is a `uiImage`, the image is displayed with a cancel button in the top trailing
    /// corner.
    ///
    /// - Parameters:
    ///   - uiImage: A binding to a property that stores the selected image
    ///   - titleKey: The text to display on the selection button. Defaults to **Select Image...**
    public init(
        uiImage: Binding<UIImage?>,
        titleKey: LocalizedStringKey = "Select Image..."
    ) {
        self._uiImage = uiImage
        self.titleKey = titleKey
    }

    public var body: some View {
        if let uiImage {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(alignment: .topTrailing) {
                    clearImageButton
                        .padding([.top, .trailing])
                }
        } else {
            PhotosPicker(selection: $imageModel.imageSelection) {
                Label(titleKey, systemImage: "photo.on.rectangle.angled")
                    .onChange(of: imageModel.imageState, perform: updateImageState)
            }
        }
    }

    private func updateImageState(_ imageState: ImagePickerModel.ImageState) {
        switch imageState {
        case .empty, .failure:
            uiImage = nil
        case .success(let image):
            uiImage = image
        default:
            break
        }
    }

    private var clearImageButton: some View {
        Button {
            uiImage = nil
            imageModel.imageSelection = nil
        } label: {
            Label("Clear", systemImage: "xmark.circle.fill")
                .foregroundStyle(.ultraThickMaterial)
                .shadow(radius: 2)
        }
        .controlSize(.large)
        .labelStyle(.iconOnly)
    }
}

struct ImagePicker_Previews: PreviewProvider {
    struct Preview: View {
        @State var image: UIImage?

        var body: some View {
            VStack {
                ImagePicker(uiImage: $image)
            }
            .padding()
        }
    }

    static var previews: some View {
        Preview()
    }
}
