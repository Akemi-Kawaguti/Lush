//
//  GarmentCategory.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 29/09/26.
//

enum GarmentCategory: String, Codable, CaseIterable {
    // Parte de cima
    case tShirt = "Camiseta"
    case tankTop = "Regata"
    case croppedTop = "Cropped"
    case blouse = "Blusa"
    case shirt = "Camisa"
    case bodysuit = "Body"
    case sweater = "Suéter"

    // Parte de baixo
    case pants = "Calça"
    case shorts = "Short"
    case skirt = "Saia"
    case leggings = "Legging"
    case bermudaShorts = "Bermuda"

    // Peça única
    case dress = "Vestido"
    case jumpsuit = "Macacão"

    var position: GarmentPosition {
        switch self {
        case .tShirt, .tankTop, .croppedTop, .blouse, .shirt, .bodysuit, .sweater:
            return .top
        case .pants, .shorts, .skirt, .leggings, .bermudaShorts:
            return .bottom
        case .dress, .jumpsuit:
            return .onePiece
        }
    }
}
