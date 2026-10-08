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
                user.photoData = photo.jpegData(compressionQuality: 0.8)
            }
        }

        try? modelContext.save()

        // Chama o callback passando os dados reais ou nulos caso tenha pulado
        onFinish(isSkipped ? nil : user.name, photo)
    }
}
