//
//  GarmentCutOnePiece.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 29/09/26.
//

enum GarmentCutOnePiece: String, Codable, CaseIterable, Identifiable {
    var id: String { rawValue }

    // Vestido
    case dressBodycon = "dress_bodycon"
    case dressStraight = "dress_straight"
    case dressALine = "dress_a_line"
    case dressGodet = "dress_godet"
    case dressEmpire = "dress_empire"
    case dressWrap = "dress_wrap"
    case dressMermaid = "dress_mermaid"
    case dressSlip = "dress_slip"
    case dressTrapeze = "dress_trapeze"
    case dressAsymmetric = "dress_asymmetric"
    
    // Macacão
    case jumpsuitStraight = "jumpsuit_straight"
    case jumpsuitFitted = "jumpsuit_fitted"
    case jumpsuitPantalona = "jumpsuit_pantalona"
    case jumpsuitPantacourt = "jumpsuit_pantacourt"
    case jumpsuitPlaysuit = "jumpsuit_playsuit"
    case jumpsuitDungarees = "jumpsuit_dungarees"

    var displayName: String {
        switch self {
        case .dressBodycon: return "Tubinho"
        case .dressStraight: return "Reto"
        case .dressALine: return "Evasê"
        case .dressGodet: return "Godê"
        case .dressEmpire: return "Império"
        case .dressWrap: return "Envelope"
        case .dressMermaid: return "Sereia"
        case .dressSlip: return "Slip Dress"
        case .dressTrapeze: return "Trapézio"
        case .dressAsymmetric: return "Assimétrico"
             
        case .jumpsuitStraight: return "Reto"
        case .jumpsuitFitted: return "Justo"
        case .jumpsuitPantalona: return "Pantalona"
        case .jumpsuitPantacourt: return "Pantacourt"
        case .jumpsuitPlaysuit: return "Macaquinho"
        case .jumpsuitDungarees: return "Jardineira"
        }
    }
}
