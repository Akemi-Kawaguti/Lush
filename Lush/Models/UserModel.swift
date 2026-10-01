//
//  UserModel.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 28/09/26.
//
// nome - foto
// favoritos - analises

import Foundation
import SwiftData

@Model
final class UserModel {
    var name: String
    var photoData: Data?
    var favorites: [String]
    
    @Relationship(deleteRule: .cascade, inverse: \AnalysisModel.user)
    var analysis: [AnalysisModel] = [] //analises do usuario
    
    @Relationship(deleteRule: .cascade)
        var userClothes: [ClothesModel] //guarda - roupa
    
    init(name: String, photoData: Data? = nil, favorites: [String], analysis: [AnalysisModel], userClothes: [ClothesModel]) {
        self.name = name
        self.photoData = photoData
        self.favorites = favorites
        self.analysis = analysis
        self.userClothes = userClothes
    }
}



