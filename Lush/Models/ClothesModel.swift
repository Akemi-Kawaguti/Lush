//
//  ClothesModel.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 28/09/26.
//

//ID - nome - foto
//categoria - posicao roupa - modelagem

import Foundation
import SwiftData

@Model
final class ClothesModel {
    var id: UUID
    var name: String
    var photo: Data?
    var garmentCategory: GarmentCategory
    var garmentPosition: GarmentPosition

    //Como não pode receber varias enums
    //precisa declarar como opcionais para selecionar 1
    //MARK: para usar - For each
    var cutTop: GarmentCutTop?
    var cutBottom: GarmentCutBottom?
    var cutOnePiece: GarmentCutOnePiece?
    var cutOuterLayer: GarmentCutOuterLayer?
    
    var user: UserModel?
    
    init(id: UUID, name: String, photo: Data? = nil, garmentCategory: GarmentCategory, garmentPosition: GarmentPosition, cutTop: GarmentCutTop? = nil, cutBottom: GarmentCutBottom? = nil, cutOnePiece: GarmentCutOnePiece? = nil, cutOuterLayer: GarmentCutOuterLayer? = nil, user: UserModel? = nil) {
        
        self.id = id
        self.name = name
        self.photo = photo
        
        self.garmentCategory = garmentCategory
        self.garmentPosition = garmentPosition
        
        self.cutTop = cutTop
        self.cutBottom = cutBottom
        self.cutOnePiece = cutOnePiece
        self.cutOuterLayer = cutOuterLayer
        
        self.user = user
    }

}
