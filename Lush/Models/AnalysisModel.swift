//
//  AnalysisModel.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 01/10/26.
//

// ID e data
// silhueta RESULTADO
// Paleta do usuario RESULTADO

import Foundation
import SwiftData

@Model
final class AnalysisModel {
    var id: UUID
    var date: Data //registrar quando foi feita a avaliação
    
    // Resultados da Avaliação
    var userSilhouette: String
    var userPalette: [String]
    
    // Parâmetros manuais ou obtidos na avaliação
    @Relationship(deleteRule: .cascade)
    var pillarColor: PillarsColor?
    @Relationship(deleteRule: .cascade)
    var sizeSpecifications: SizeSpecifications?
    
    // Relacionamento inverso com o usuário
    var user: UserModel?
    
    init(id: UUID, date: Data, userSilhouette: String, userPalette: [String], pillarColor: PillarsColor? = nil, sizeSpecifications: SizeSpecifications? = nil, user: UserModel? = nil) {
        self.id = id
        self.date = date
        self.userSilhouette = userSilhouette
        self.userPalette = userPalette
        self.pillarColor = pillarColor
        self.sizeSpecifications = sizeSpecifications
        self.user = user
    }
}


