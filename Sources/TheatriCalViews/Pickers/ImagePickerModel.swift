//
//  ImagePickerModel.swift
//  
//
//  Created by Scott Matthewman on 13/04/2023.
//

import PhotosUI
import SwiftUI

@MainActor
internal class ImagePickerModel: ObservableObject {
    enum ImageState: Equatable {
        case empty
        case loading(Progress)
        case success(UIImage)
        case failure(Error)

        static func == (lhs: ImageState, rhs: ImageState) -> Bool {
            switch (lhs, rhs) {
            case (.empty, .empty):
                return true
            case (.loading(let lhsProgress), .loading(let rhsProgress)):
                return lhsProgress == rhsProgress
            case (.success(let lhsImage), .success(let rhsImage)):
                return lhsImage == rhsImage
            default:
                return false
            }
        }
    }

    enum TransferError: Error {
        case transferFailed
    }

    struct EventImage: Transferable {
        let uiImage: UIImage

        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                guard
                    let uiImage = UIImage(data: data)
                else { throw TransferError.transferFailed }

                return EventImage(uiImage: uiImage)
            }
        }
    }

    @Published private(set) var imageState: ImageState = .empty
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }

    private func loadTransferable(
        from imageSelection: PhotosPickerItem
    ) -> Progress {
        imageSelection.loadTransferable(type: EventImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item")
                    return
                }

                switch result {
                case .success(let eventImage?):
                    self.imageState = .success(eventImage.uiImage)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
}
