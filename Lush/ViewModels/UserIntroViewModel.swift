//
//  UserIntroViewModel.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 07/10/26.
//

import SwiftUI
import SwiftData
import PhotosUI

@Observable
final class UserIntroViewModel {
    var name = ""
    var photoItem: PhotosPickerItem?
    var photo: UIImage?
    var isKeyboardOpen = false

    var hasName: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    /// Carrega a foto selecionada na galeria
    func loadPhoto() async {
        if let data = try? await photoItem?.loadTransferable(type: Data.self) {
            photo = UIImage(data: data)
        }
    }

    /// Salva o nome e a foto na usuária que já existe (criada na colorimetria)
    func saveUser(modelContext: ModelContext, isSkipped: Bool, onFinish: (_ name: String?, _ photo: UIImage?) -> Void) {
        let user = UserModel.current(in: modelContext)

        if !isSkipped {
            user.name = name.trimmingCharacters(in: .whitespaces)
            if let photo {
                user.photoData = compressedPhotoData(photo)
            }
        }

        try? modelContext.save()

        // Chama o callback passando os dados reais ou nulos caso tenha pulado
        onFinish(isSkipped ? nil : user.name, photo)
    }

    /// Diminui a foto antes de salvar (foto da câmera tem vários MB), igual à Configurações
    private func compressedPhotoData(_ image: UIImage) -> Data? {
        let maxSide: CGFloat = 800
        let scale = min(1, maxSide / max(image.size.width, image.size.height))
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)

        let resized = UIGraphicsImageRenderer(size: newSize).image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        return resized.jpegData(compressionQuality: 0.8)
    }
}
