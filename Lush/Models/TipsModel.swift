//
//  TipsModel.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 28/09/26.
//

// ID - nome - favoritos - roupas

import Foundation
import SwiftData

@Model
final class TipsModel {
    var id: UUID
    var name: String
    var favorites: Bool
    var clothes: [ClothesModel]
        
    init(
        id: UUID = UUID(),
        name: String,
        favorites: Bool = false,
        perfil: UserModel? = nil,
        clothes: [ClothesModel] = []
    ) {
        self.id = id
        self.name = name
        self.favorites = favorites
        self.clothes = clothes
    }
}
