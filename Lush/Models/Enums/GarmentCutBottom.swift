//
//  GarmentCutBottom.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 29/09/26.
//

enum GarmentCutBottom: String, Codable, CaseIterable, Identifiable {
    var id: String { rawValue }

    // Calça
    case pantsSkinny = "pants_skinny"
    case pantsSlim = "pants_slim"
    case pantsStraight = "pants_straight"
    case pantsBootCut = "pants_boot_cut"
    case pantsFlare = "pants_flare"
    //case pantsPantalona = "pants_pantalona"
    case pantsWideLeg = "pants_wide_leg"
    case pantsCulotte = "pants_culotte"
    case pantsPantacourt = "pants_pantacourt"
    case pantsMom = "pants_mom"
    case pantsBoyfriend = "pants_boyfriend"
    case pantsBaggy = "pants_baggy"
    case pantsJogger = "pants_jogger"
    
    // Short
    case shortsHotPants = "shorts_hot_pants"
    case shortsTraditional = "shorts_traditional"
    case shortsFitted = "shorts_fitted"
    case shortsMom = "shorts_mom"
    case shortsBoyfriend = "shorts_boyfriend"
    case shortsGodet = "shorts_godet"
    case shortsTailored = "shorts_tailored"
    case shortsBiker = "shorts_biker"
    
    // Saia
    case skirtPencil = "skirt_pencil"
    case skirtStraight = "skirt_straight"
    case skirtALine = "skirt_a_line"
    case skirtGodet = "skirt_godet"
    case skirtPleated = "skirt_pleated"
    case skirtMermaid = "skirt_mermaid"
    case skirtWrap = "skirt_wrap"
    case skirtBubble = "skirt_bubble"
    case skirtAsymmetric = "skirt_asymmetric"
    
    // Legging
    case leggingsTraditional = "leggings_traditional"
    case leggingsCapriShort = "leggings_capri_short"
    case leggingsCapri = "leggings_capri"
    case leggingsBiker = "leggings_biker"
    case leggingsFlare = "leggings_flare"
    case leggingsJogger = "leggings_jogger"
    
    // Bermuda
    case bermudaTraditional = "bermuda_traditional"
    case bermudaSlim = "bermuda_slim"
    case bermudaBaggy = "bermuda_baggy"
    case bermudaJorts = "bermuda_jorts"
    case bermudaCargo = "bermuda_cargo"
    case bermudaTailored = "bermuda_tailored"
    case bermudaBiker = "bermuda_biker"
    case bermudaJogger = "bermuda_jogger"

    var displayName: String {
        switch self {
        case .pantsSkinny: return "Skinny"
        case .pantsSlim: return "Slim"
        case .pantsStraight: return "Reta"
        case .pantsBootCut: return "Boot cut"
        case .pantsFlare: return "Flare"
        //case .pantsPantalona: return "Pantalona"
        case .pantsWideLeg: return "Wide Leg"
        case .pantsCulotte: return "Culotte"
        case .pantsPantacourt: return "Pantacourt"
        case .pantsMom: return "Mom"
        case .pantsBoyfriend: return "Boyfriend"
        case .pantsBaggy: return "Baggy"
        case .pantsJogger: return "Jogger"
             
        case .shortsHotPants: return "Curto (hot pants)"
        case .shortsTraditional: return "Tradicional"
        case .shortsFitted: return "Justo"
        case .shortsMom: return "Mom"
        case .shortsBoyfriend: return "Boyfriend"
        case .shortsGodet: return "Godê/Evasê"
        case .shortsTailored: return "Alfaiataria"
        case .shortsBiker: return "Ciclista"
             
        case .skirtPencil: return "Lápis"
        case .skirtStraight: return "Reta"
        case .skirtALine: return "Evasê"
        case .skirtGodet: return "Godê"
        case .skirtPleated: return "Plissada"
        case .skirtMermaid: return "Sereia"
        case .skirtWrap: return "Envelope/Transpassada"
        case .skirtBubble: return "Balonê/Tulipa"
        case .skirtAsymmetric: return "Assimétrica"
             
        case .leggingsTraditional: return "Tradicional"
        case .leggingsCapriShort: return "Corsário"
        case .leggingsCapri: return "Capri"
        case .leggingsBiker: return "Ciclista"
        case .leggingsFlare: return "Flare"
        case .leggingsJogger: return "Jogger"
             
        case .bermudaTraditional: return "Tradicional"
        case .bermudaSlim: return "Slim"
        case .bermudaBaggy: return "Ampla/Baggy"
        case .bermudaJorts: return "Jorts"
        case .bermudaCargo: return "Cargo"
        case .bermudaTailored: return "Alfaiataria"
        case .bermudaBiker: return "Ciclista"
        case .bermudaJogger: return "Jogger"
        }
    }
}
