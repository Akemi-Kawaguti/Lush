//
//  Enums.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 28/09/26.
//

//
//  Enums.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 28/09/26.
//

import Foundation

enum GarmentPosition: String, Codable, CaseIterable {
    case top = "Parte de cima"
    case bottom = "Parte de baixo"
    case onePiece = "Peça única"
    case outerLayer = "Sobreposição"
}

enum GarmentCategory: String, Codable, CaseIterable {
    // Top
    case tShirt = "Camiseta"
    case tankTop = "Regata"
    case croppedTop = "Cropped"
    case blouse = "Blusa"
    case shirt = "Camisa"
    case bodysuit = "Body"
    case sweater = "Suéter"
    
    // Bottom
    case pants = "Calça"
    case shorts = "Short"
    case skirt = "Saia"
    case leggings = "Legging"
    case bermudaShorts = "Bermuda"
    
    // One piece
    case dress = "Vestido"
    case jumpsuit = "Macacão"
    case coordSet = "Conjunto"
    
    // Outer layer
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
    
    /// Modelagens disponíveis para a categoria atual
    var availableCuts: [GarmentCut] {
        GarmentCut.allCases.filter { $0.category == self }
    }
}

enum BodyShape: String, Codable, CaseIterable {
    case hourglass = "Ampulheta"
    case triangle = "Triângulo"
    case invertedTriangle = "Triângulo invertido"
    case rectangle = "Retângulo"
    case oval = "Oval"
}

enum ColorSeason: String, Codable, CaseIterable {
    case spring = "Primavera"
    case summer = "Verão"
    case autumn = "Outono"
    case winter = "Inverno"
}

enum AnalysisStatus: String, Codable {
    case pending = "Pendente"
    case completed = "Concluída"
    case failed = "Falhou"
}

// Modelagens específicas por categoria
enum GarmentCut: String, Codable, CaseIterable, Identifiable {
    var id: String { rawValue }

    // MARK: - Parte de Cima
    // Camiseta (tShirt)
    case tShirtTraditional = "tshirt_traditional"
    case tShirtFitted = "tshirt_fitted"
    case tShirtOversized = "tshirt_oversized"
    case tShirtBoxy = "tshirt_boxy"
    case tShirtLongline = "tshirt_longline"
    case tShirtBabyLook = "tshirt_baby_look"
    case tShirtRaglan = "tshirt_raglan"
    
    // Regata (tankTop)
    case tankTopTraditional = "tanktop_traditional"
    case tankTopFitted = "tanktop_fitted"
    case tankTopOversized = "tanktop_oversized"
    case tankTopCropped = "tanktop_cropped"
    case tankTopLongline = "tanktop_longline"
    case tankTopBoxy = "tanktop_boxy"
    case tankTopPeplum = "tanktop_peplum"
    case tankTopAsymmetric = "tanktop_asymmetric"
    
    // Cropped (croppedTop)
    case croppedTraditional = "cropped_traditional"
    case croppedUltraCropped = "cropped_ultra_cropped"
    case croppedFitted = "cropped_fitted"
    case croppedOversized = "cropped_oversized"
    case croppedBoxy = "cropped_boxy"
    case croppedTube = "cropped_tube"
    case croppedHalter = "cropped_halter"
    case croppedTie = "cropped_tie"
    
    // Blusa (blouse)
    case blouseTraditional = "blouse_traditional"
    case blouseFitted = "blouse_fitted"
    case blouseFlowy = "blouse_flowy"
    case blouseOversized = "blouse_oversized"
    case blouseOffShoulder = "blouse_off_shoulder"
    case blouseOneShoulder = "blouse_one_shoulder"
    case blousePeplum = "blouse_peplum"
    case blouseWrap = "blouse_wrap"
    
    // Camisa (shirt)
    case shirtTraditional = "shirt_traditional"
    case shirtSlim = "shirt_slim"
    case shirtOversized = "shirt_oversized"
    case shirtBoxy = "shirt_boxy"
    case shirtLongline = "shirt_longline"
    case shirtFlowy = "shirt_flowy"
    
    // Body (bodysuit)
    case bodysuitTraditional = "bodysuit_traditional"
    case bodysuitHighCut = "bodysuit_high_cut"
    case bodysuitStrapless = "bodysuit_strapless"
    case bodysuitOneShoulder = "bodysuit_one_shoulder"
    case bodysuitHalter = "bodysuit_halter"
    case bodysuitWrap = "bodysuit_wrap"
    case bodysuitAsymmetric = "bodysuit_asymmetric"
    
    // Suéter (sweater)
    case sweaterTraditional = "sweater_traditional"
    case sweaterFitted = "sweater_fitted"
    case sweaterOversized = "sweater_oversized"
    case sweaterBoxy = "sweater_boxy"
    case sweaterCropped = "sweater_cropped"
    case sweaterLongline = "sweater_longline"
    case sweaterDropShoulder = "sweater_drop_shoulder"
    
    // MARK: - Parte de Baixo
    // Calça (pants)
    case pantsSkinny = "pants_skinny"
    case pantsSlim = "pants_slim"
    case pantsStraight = "pants_straight"
    case pantsBootCut = "pants_boot_cut"
    case pantsFlare = "pants_flare"
    case pantsPantalona = "pants_pantalona"
    case pantsCulotte = "pants_culotte"
    case pantsPantacourt = "pants_pantacourt"
    case pantsMom = "pants_mom"
    case pantsBoyfriend = "pants_boyfriend"
    case pantsBaggy = "pants_baggy"
    
    // Short (shorts)
    case shortsHotPants = "shorts_hot_pants"
    case shortsTraditional = "shorts_traditional"
    case shortsFitted = "shorts_fitted"
    case shortsMom = "shorts_mom"
    case shortsBoyfriend = "shorts_boyfriend"
    case shortsGodet = "shorts_godet"
    case shortsTailored = "shorts_tailored"
    case shortsBiker = "shorts_biker"
    
    // Saia (skirt)
    case skirtPencil = "skirt_pencil"
    case skirtStraight = "skirt_straight"
    case skirtALine = "skirt_a_line"
    case skirtGodet = "skirt_godet"
    case skirtPleated = "skirt_pleated"
    case skirtMermaid = "skirt_mermaid"
    case skirtWrap = "skirt_wrap"
    case skirtBubble = "skirt_bubble"
    case skirtAsymmetric = "skirt_asymmetric"
    
    // Legging (leggings)
    case leggingsTraditional = "leggings_traditional"
    case leggingsCapriShort = "leggings_capri_short"
    case leggingsCapri = "leggings_capri"
    case leggingsBiker = "leggings_biker"
    case leggingsFlare = "leggings_flare"
    case leggingsJogger = "leggings_jogger"
    
    // Bermuda (bermudaShorts)
    case bermudaTraditional = "bermuda_traditional"
    case bermudaSlim = "bermuda_slim"
    case bermudaBaggy = "bermuda_baggy"
    case bermudaJorts = "bermuda_jorts"
    case bermudaCargo = "bermuda_cargo"
    case bermudaTailored = "bermuda_tailored"
    case bermudaBiker = "bermuda_biker"
    case bermudaJogger = "bermuda_jogger"
    
    // MARK: - Peça Única
    // Vestido (dress)
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
    
    // Macacão (jumpsuit)
    case jumpsuitStraight = "jumpsuit_straight"
    case jumpsuitFitted = "jumpsuit_fitted"
    case jumpsuitPantalona = "jumpsuit_pantalona"
    case jumpsuitPantacourt = "jumpsuit_pantacourt"
    case jumpsuitPlaysuit = "jumpsuit_playsuit"
    case jumpsuitDungarees = "jumpsuit_dungarees"

    // MARK: - Sobreposição
    // Jaqueta (jacket)
    case jacketTraditional = "jacket_traditional"
    case jacketCropped = "jacket_cropped"
    case jacketOversized = "jacket_oversized"
    case jacketBomber = "jacket_bomber"
    case jacketBiker = "jacket_biker"
    case jacketTrucker = "jacket_trucker"
    case jacketPuffer = "jacket_puffer"
    
    // Blazer (blazer)
    case blazerTraditional = "blazer_traditional"
    case blazerCropped = "blazer_cropped"
    case blazerOversized = "blazer_oversized"
    case blazerBomber = "blazer_bomber"
    case blazerBiker = "blazer_biker"
    case blazerTrucker = "blazer_trucker"
    case blazerPuffer = "blazer_puffer"
    
    // Casaco (coat)
    case coatStraight = "coat_straight"
    case coatALine = "coat_a_line"
    case coatOversized = "coat_oversized"
    case coatWrap = "coat_wrap"
    case coatCocoon = "coat_cocoon"
    case coatCropped = "coat_cropped"
    case coatLongline = "coat_longline"
    
    // Cardigan (cardigan)
    case cardiganTraditional = "cardigan_traditional"
    case cardiganFitted = "cardigan_fitted"
    case cardiganOversized = "cardigan_oversized"
    case cardiganCropped = "cardigan_cropped"
    case cardiganLongline = "cardigan_longline"
    case cardiganCascade = "cardigan_cascade"
    
    // Colete (vest)
    case vestTraditional = "vest_traditional"
    case vestFitted = "vest_fitted"
    case vestLongline = "vest_longline"
    case vestCropped = "vest_cropped"
    case vestOversized = "vest_oversized"
    case vestPuffer = "vest_puffer"
    case vestTailored = "vest_tailored"
    
    // Sobretudo (overcoat)
    case overcoatStraight = "overcoat_straight"
    case overcoatDoubleBreasted = "overcoat_double_breasted"
    case overcoatSlim = "overcoat_slim"
    case overcoatOversized = "overcoat_oversized"
    case overcoatTrench = "overcoat_trench"
    case overcoatMaxi = "overcoat_maxi"

    /// Nome exibido na interface do aplicativo (Picker/UI)
    var displayName: String {
        switch self {
        // Camiseta
        case .tShirtTraditional: return "Tradicional"
        case .tShirtFitted: return "Justa"
        case .tShirtOversized: return "Oversized"
        case .tShirtBoxy: return "Boxy"
        case .tShirtLongline: return "Longline"
        case .tShirtBabyLook: return "Baby look"
        case .tShirtRaglan: return "Raglan"
            
        // Regata
        case .tankTopTraditional: return "Tradicional"
        case .tankTopFitted: return "Justa"
        case .tankTopOversized: return "Oversized"
        case .tankTopCropped: return "Cropped"
        case .tankTopLongline: return "Longline"
        case .tankTopBoxy: return "Boxy"
        case .tankTopPeplum: return "Peplum"
        case .tankTopAsymmetric: return "Assimétrica"
            
        // Cropped
        case .croppedTraditional: return "Tradicional"
        case .croppedUltraCropped: return "Ultra cropped"
        case .croppedFitted: return "Justo"
        case .croppedOversized: return "Oversized"
        case .croppedBoxy: return "Boxy"
        case .croppedTube: return "Tubinho/Faixa"
        case .croppedHalter: return "Frente única"
        case .croppedTie: return "Amarração/Nó"
            
        // Blusa
        case .blouseTraditional: return "Tradicional"
        case .blouseFitted: return "Justa"
        case .blouseFlowy: return "Fluida"
        case .blouseOversized: return "Oversized"
        case .blouseOffShoulder: return "Ciganinha"
        case .blouseOneShoulder: return "Ombro único"
        case .blousePeplum: return "Peplum"
        case .blouseWrap: return "Transpassada"
            
        // Camisa
        case .shirtTraditional: return "Tradicional"
        case .shirtSlim: return "Slim"
        case .shirtOversized: return "Oversized"
        case .shirtBoxy: return "Boxy"
        case .shirtLongline: return "Alongada"
        case .shirtFlowy: return "Fluida"
            
        // Body
        case .bodysuitTraditional: return "Tradicional"
        case .bodysuitHighCut: return "Cavado"
        case .bodysuitStrapless: return "Tomara que caia"
        case .bodysuitOneShoulder: return "Ombro Único"
        case .bodysuitHalter: return "Frente Única"
        case .bodysuitWrap: return "Transpassado"
        case .bodysuitAsymmetric: return "Assimétrico"
            
        // Suéter
        case .sweaterTraditional: return "Tradicional"
        case .sweaterFitted: return "Justo"
        case .sweaterOversized: return "Oversized"
        case .sweaterBoxy: return "Boxy"
        case .sweaterCropped: return "Cropped"
        case .sweaterLongline: return "Alongado"
        case .sweaterDropShoulder: return "Ombro caído"
            
        // Calça
        case .pantsSkinny: return "Skinny"
        case .pantsSlim: return "Slim"
        case .pantsStraight: return "Reta"
        case .pantsBootCut: return "Boot cut"
        case .pantsFlare: return "Flare"
        case .pantsPantalona: return "Pantalona"
        case .pantsCulotte: return "Culotte"
        case .pantsPantacourt: return "Pantacourt"
        case .pantsMom: return "Mom"
        case .pantsBoyfriend: return "Boyfriend"
        case .pantsBaggy: return "Baggy"
            
        // Short
        case .shortsHotPants: return "Curto (hot pants)"
        case .shortsTraditional: return "Tradicional"
        case .shortsFitted: return "Justo"
        case .shortsMom: return "Mom"
        case .shortsBoyfriend: return "Boyfriend"
        case .shortsGodet: return "Godê/Evasê"
        case .shortsTailored: return "Alfaiataria"
        case .shortsBiker: return "Ciclista"
            
        // Saia
        case .skirtPencil: return "Lápis"
        case .skirtStraight: return "Reta"
        case .skirtALine: return "Evasê"
        case .skirtGodet: return "Godê"
        case .skirtPleated: return "Plissada"
        case .skirtMermaid: return "Sereia"
        case .skirtWrap: return "Envelope/Transpassada"
        case .skirtBubble: return "Balonê/Tulipa"
        case .skirtAsymmetric: return "Assimétrica"
            
        // Legging
        case .leggingsTraditional: return "Tradicional"
        case .leggingsCapriShort: return "Corsário"
        case .leggingsCapri: return "Capri"
        case .leggingsBiker: return "Ciclista"
        case .leggingsFlare: return "Flare"
        case .leggingsJogger: return "Jogger"
            
        // Bermuda
        case .bermudaTraditional: return "Tradicional"
        case .bermudaSlim: return "Slim"
        case .bermudaBaggy: return "Ampla/Baggy"
        case .bermudaJorts: return "Jorts"
        case .bermudaCargo: return "Cargo"
        case .bermudaTailored: return "Alfaiataria"
        case .bermudaBiker: return "Ciclista"
        case .bermudaJogger: return "Jogger"
            
        // Vestido
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
            
        // Macacão
        case .jumpsuitStraight: return "Reto"
        case .jumpsuitFitted: return "Justo"
        case .jumpsuitPantalona: return "Pantalona"
        case .jumpsuitPantacourt: return "Pantacourt"
        case .jumpsuitPlaysuit: return "Macaquinho"
        case .jumpsuitDungarees: return "Jardineira"
            
        // Jaqueta
        case .jacketTraditional: return "Tradicional"
        case .jacketCropped: return "Cropped"
        case .jacketOversized: return "Oversized"
        case .jacketBomber: return "Bomber"
        case .jacketBiker: return "Biker"
        case .jacketTrucker: return "Trucker"
        case .jacketPuffer: return "Puffer"
            
        // Blazer
        case .blazerTraditional: return "Tradicional"
        case .blazerCropped: return "Cropped"
        case .blazerOversized: return "Oversized"
        case .blazerBomber: return "Bomber"
        case .blazerBiker: return "Biker"
        case .blazerTrucker: return "Trucker"
        case .blazerPuffer: return "Puffer"
            
        // Casaco
        case .coatStraight: return "Reto"
        case .coatALine: return "Evasê"
        case .coatOversized: return "Oversized"
        case .coatWrap: return "Envelope"
        case .coatCocoon: return "Cocoon"
        case .coatCropped: return "Cropped"
        case .coatLongline: return "Alongado"
            
        // Cardigan
        case .cardiganTraditional: return "Tradicional"
        case .cardiganFitted: return "Justo"
        case .cardiganOversized: return "Oversized"
        case .cardiganCropped: return "Cropped"
        case .cardiganLongline: return "Alongado"
        case .cardiganCascade: return "Cascata"
            
        // Colete
        case .vestTraditional: return "Tradicional"
        case .vestFitted: return "Justo"
        case .vestLongline: return "Alongado"
        case .vestCropped: return "Cropped"
        case .vestOversized: return "Oversized"
        case .vestPuffer: return "Puffer"
        case .vestTailored: return "Alfaiataria"
            
        // Sobretudo
        case .overcoatStraight: return "Reto"
        case .overcoatDoubleBreasted: return "Transpassado"
        case .overcoatSlim: return "Slim"
        case .overcoatOversized: return "Oversized"
        case .overcoatTrench: return "Trench coat"
        case .overcoatMaxi: return "Maxi"
        }
    }

    var category: GarmentCategory {
        switch self {
        case .tShirtTraditional, .tShirtFitted, .tShirtOversized, .tShirtBoxy, .tShirtLongline, .tShirtBabyLook, .tShirtRaglan:
            return .tShirt
        case .tankTopTraditional, .tankTopFitted, .tankTopOversized, .tankTopCropped, .tankTopLongline, .tankTopBoxy, .tankTopPeplum, .tankTopAsymmetric:
            return .tankTop
        case .croppedTraditional, .croppedUltraCropped, .croppedFitted, .croppedOversized, .croppedBoxy, .croppedTube, .croppedHalter, .croppedTie:
            return .croppedTop
        case .blouseTraditional, .blouseFitted, .blouseFlowy, .blouseOversized, .blouseOffShoulder, .blouseOneShoulder, .blousePeplum, .blouseWrap:
            return .blouse
        case .shirtTraditional, .shirtSlim, .shirtOversized, .shirtBoxy, .shirtLongline, .shirtFlowy:
            return .shirt
        case .bodysuitTraditional, .bodysuitHighCut, .bodysuitStrapless, .bodysuitOneShoulder, .bodysuitHalter, .bodysuitWrap, .bodysuitAsymmetric:
            return .bodysuit
        case .sweaterTraditional, .sweaterFitted, .sweaterOversized, .sweaterBoxy, .sweaterCropped, .sweaterLongline, .sweaterDropShoulder:
            return .sweater
        case .pantsSkinny, .pantsSlim, .pantsStraight, .pantsBootCut, .pantsFlare, .pantsPantalona, .pantsCulotte, .pantsPantacourt, .pantsMom, .pantsBoyfriend, .pantsBaggy:
            return .pants
        case .shortsHotPants, .shortsTraditional, .shortsFitted, .shortsMom, .shortsBoyfriend, .shortsGodet, .shortsTailored, .shortsBiker:
            return .shorts
        case .skirtPencil, .skirtStraight, .skirtALine, .skirtGodet, .skirtPleated, .skirtMermaid, .skirtWrap, .skirtBubble, .skirtAsymmetric:
            return .skirt
        case .leggingsTraditional, .leggingsCapriShort, .leggingsCapri, .leggingsBiker, .leggingsFlare, .leggingsJogger:
            return .leggings
        case .bermudaTraditional, .bermudaSlim, .bermudaBaggy, .bermudaJorts, .bermudaCargo, .bermudaTailored, .bermudaBiker, .bermudaJogger:
            return .bermudaShorts
        case .dressBodycon, .dressStraight, .dressALine, .dressGodet, .dressEmpire, .dressWrap, .dressMermaid, .dressSlip, .dressTrapeze, .dressAsymmetric:
            return .dress
        case .jumpsuitStraight, .jumpsuitFitted, .jumpsuitPantalona, .jumpsuitPantacourt, .jumpsuitPlaysuit, .jumpsuitDungarees:
            return .jumpsuit
        case .jacketTraditional, .jacketCropped, .jacketOversized, .jacketBomber, .jacketBiker, .jacketTrucker, .jacketPuffer:
            return .jacket
        case .blazerTraditional, .blazerCropped, .blazerOversized, .blazerBomber, .blazerBiker, .blazerTrucker, .blazerPuffer:
            return .blazer
        case .coatStraight, .coatALine, .coatOversized, .coatWrap, .coatCocoon, .coatCropped, .coatLongline:
            return .coat
        case .cardiganTraditional, .cardiganFitted, .cardiganOversized, .cardiganCropped, .cardiganLongline, .cardiganCascade:
            return .cardigan
        case .vestTraditional, .vestFitted, .vestLongline, .vestCropped, .vestOversized, .vestPuffer, .vestTailored:
            return .vest
        case .overcoatStraight, .overcoatDoubleBreasted, .overcoatSlim, .overcoatOversized, .overcoatTrench, .overcoatMaxi:
            return .overcoat
        }
    }
}
