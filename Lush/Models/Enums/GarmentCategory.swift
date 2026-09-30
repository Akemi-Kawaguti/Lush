//
//  GarmentCategory.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 29/09/26.
//

enum GarmentCategory: String, Codable, CaseIterable {
    case tShirt = "Camiseta"
    case tankTop = "Regata"
    case croppedTop = "Cropped"
    case blouse = "Blusa"
    case shirt = "Camisa"
    case bodysuit = "Body"
    case sweater = "Suéter"
    
    case pants = "Calça"
    case shorts = "Short"
    case skirt = "Saia"
    case leggings = "Legging"
    case bermudaShorts = "Bermuda"
    
    case dress = "Vestido"
    case jumpsuit = "Macacão"
    case coordSet = "Conjunto"
    
    case jacket = "Jaqueta"
    case blazer = "Blazer"
    case coat = "Casaco"
    case cardigan = "Cardigan"
    case vest = "Colete"
    case overcoat = "Sobretudo"
    case other = "Outros"

    var position: GarmentPosition {
        switch self {
        case .tShirt, .tankTop, .croppedTop, .blouse, .shirt, .bodysuit, .sweater:
            return .top
        case .pants, .shorts, .skirt, .leggings, .bermudaShorts:
            return .bottom
        case .dress, .jumpsuit, .coordSet:
            return .onePiece
        case .jacket, .blazer, .coat, .cardigan, .vest, .overcoat, .other:
            return .outerLayer
        }
    }
}
