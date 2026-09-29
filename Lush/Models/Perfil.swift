//
//  Perfil.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 29/09/26.
//


import Foundation
import SwiftData

@Model
final class UserModel {
    //    var id: UUID
    var name: String
    var photoData: Data?
    var userSilhouette: String
    
    var userPallete: [String]
    var favorites: [String]
    var clothes: [String]
    
    @Relationship()
    var pillarColor: PillarsColor
    
    init(name: String, photoData: Data? = nil, userSilhouette: String, userPallete: [String], favorites: [String], clothes: [String], pillarColor: PillarsColor) {
        self.name = name
        self.photoData = photoData
        self.userSilhouette = userSilhouette
        self.userPallete = userPallete
        self.favorites = favorites
        self.clothes = clothes
        self.pillarColor = pillarColor
    }
}
