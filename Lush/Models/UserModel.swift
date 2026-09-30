//
//  UserModel.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 28/09/26.
//

//nome - foto
//silhueta RESULTADO
//Paleta do usuario RESULTADO
//favoritos - roupas

import Foundation
import SwiftData

@Model
final class UserModel {
    var name: String
    var photoData: Data?
    
    var userSilhouette: String //RESULTADO
    var userPallete: [String] // RESULTADO
    var favorites: [String]
    
    @Relationship(deleteRule: .cascade)
        var userClothes: [ClothesModel] //guarda - roupa
        
        @Relationship(deleteRule: .cascade)
        var pillarColor: PillarsColor? //parametros manuais
        
        @Relationship(deleteRule: .cascade)
        var sizeSpecifications: SizeSpecifications? //parametros manuais
    
    init(name: String, photoData: Data? = nil, userSilhouette: String, userPallete: [String], favorites: [String], userClothes: [ClothesModel], pillarColor: PillarsColor, sizeSpecifications: SizeSpecifications) {
        self.name = name
        self.photoData = photoData
        self.userSilhouette = userSilhouette
        self.userPallete = userPallete
        self.favorites = favorites
        self.userClothes = userClothes
        self.pillarColor = pillarColor
        self.sizeSpecifications = sizeSpecifications
    }
}

