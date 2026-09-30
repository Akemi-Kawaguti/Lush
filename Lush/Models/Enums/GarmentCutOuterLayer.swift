//
//  GarmentCutOuterLayer.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 29/09/26.
//

enum GarmentCutOuterLayer: String, Codable, CaseIterable, Identifiable {
    var id: String { rawValue }

    // Jaqueta
    case jacketTraditional = "jacket_traditional"
    case jacketCropped = "jacket_cropped"
    case jacketOversized = "jacket_oversized"
    case jacketBomber = "jacket_bomber"
    case jacketBiker = "jacket_biker"
    case jacketTrucker = "jacket_trucker"
    case jacketPuffer = "jacket_puffer"
    
    // Blazer
    case blazerTraditional = "blazer_traditional"
    case blazerCropped = "blazer_cropped"
    case blazerOversized = "blazer_Oversized"
    case blazerBomber = "blazer_bomber"
    case blazerBiker = "blazer_biker"
    case blazerTrucker = "blazer_trucker"
    case blazerPuffer = "blazer_puffer"
    
    // Casaco
    case coatStraight = "coat_straight"
    case coatALine = "coat_a_line"
    case coatOversized = "coat_Oversized"
    case coatWrap = "coat_wrap"
    case coatCocoon = "coat_cocoon"
    case coatCropped = "coat_cropped"
    case coatLongline = "coat_longline"
    
    // Cardigan
    case cardiganTraditional = "cardigan_traditional"
    case cardiganFitted = "cardigan_fitted"
    case cardiganOversized = "cardigan_Oversized"
    case cardiganCropped = "cardigan_cropped"
    case cardiganLongline = "cardigan_longline"
    case cardiganCascade = "cardigan_cascade"
    
    // Colete
    case vestTraditional = "vest_traditional"
    case vestFitted = "vest_fitted"
    case vestLongline = "vest_longline"
    case vestCropped = "vest_cropped"
    case vestOversized = "vest_Oversized"
    case vestPuffer = "vest_puffer"
    case vestTailored = "vest_tailored"
    
    // Sobretudo
    case overcoatStraight = "overcoat_straight"
    case overcoatDoubleBreasted = "overcoat_double_breasted"
    case overcoatSlim = "overcoat_slim"
    case overcoatOversized = "overcoat_Oversized"
    case overcoatTrench = "overcoat_trench"
    case overcoatMaxi = "overcoat_maxi"

    var displayName: String {
        switch self {
        case .jacketTraditional: return "Tradicional"
        case .jacketCropped: return "Cropped"
        case .jacketOversized: return "Oversized"
        case .jacketBomber: return "Bomber"
        case .jacketBiker: return "Biker"
        case .jacketTrucker: return "Trucker"
        case .jacketPuffer: return "Puffer"
             
        case .blazerTraditional: return "Tradicional"
        case .blazerCropped: return "Cropped"
        case .blazerOversized: return "Oversized"
        case .blazerBomber: return "Bomber"
        case .blazerBiker: return "Biker"
        case .blazerTrucker: return "Trucker"
        case .blazerPuffer: return "Puffer"
             
        case .coatStraight: return "Reto"
        case .coatALine: return "Evasê"
        case .coatOversized: return "Oversized"
        case .coatWrap: return "Envelope"
        case .coatCocoon: return "Cocoon"
        case .coatCropped: return "Cropped"
        case .coatLongline: return "Alongado"
             
        case .cardiganTraditional: return "Tradicional"
        case .cardiganFitted: return "Justo"
        case .cardiganOversized: return "Oversized"
        case .cardiganCropped: return "Cropped"
        case .cardiganLongline: return "Alongado"
        case .cardiganCascade: return "Cascata"
             
        case .vestTraditional: return "Tradicional"
        case .vestFitted: return "Justo"
        case .vestLongline: return "Alongado"
        case .vestCropped: return "Cropped"
        case .vestOversized: return "Oversized"
        case .vestPuffer: return "Puffer"
        case .vestTailored: return "Alfaiataria"
             
        case .overcoatStraight: return "Reto"
        case .overcoatDoubleBreasted: return "Transpassado"
        case .overcoatSlim: return "Slim"
        case .overcoatOversized: return "Oversized"
        case .overcoatTrench: return "Trench coat"
        case .overcoatMaxi: return "Maxi"
        }
    }
}
