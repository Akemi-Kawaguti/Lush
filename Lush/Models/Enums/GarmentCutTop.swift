//
//  GarmentCutTop.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 29/09/26.
//

enum GarmentCutTop: String, Codable, CaseIterable, Identifiable {
    var id: String { rawValue }

    // Camiseta
    case tShirtTraditional = "tshirt_traditional"
    case tShirtFitted = "tshirt_fitted"
    case tShirtOversized = "tshirt_oversized"
    case tShirtBoxy = "tshirt_boxy"
    case tShirtLongline = "tshirt_longline"
    case tShirtBabyLook = "tshirt_baby_look"
    case tShirtRaglan = "tshirt_raglan"
    
    // Regata
    case tankTopTraditional = "tanktop_traditional"
    case tankTopFitted = "tanktop_fitted"
    case tankTopOversized = "tanktop_oversized"
    case tankTopCropped = "tanktop_cropped"
    case tankTopLongline = "tanktop_longline"
    case tankTopBoxy = "tanktop_boxy"
    case tankTopPeplum = "tanktop_peplum"
    case tankTopAsymmetric = "tanktop_asymmetric"
    
    // Cropped
    case croppedTraditional = "cropped_traditional"
    case croppedUltraCropped = "cropped_ultra_cropped"
    case croppedFitted = "cropped_fitted"
    case croppedOversized = "cropped_oversized"
    case croppedBoxy = "cropped_boxy"
    case croppedTube = "cropped_tube"
    case croppedHalter = "cropped_halter"
    case croppedTie = "cropped_tie"
    
    // Blusa
    case blouseTraditional = "blouse_traditional"
    case blouseFitted = "blouse_fitted"
    case blouseFlowy = "blouse_flowy"
    case blouseOversized = "blouse_oversized"
    case blouseOffShoulder = "blouse_off_shoulder"
    case blouseOneShoulder = "blouse_one_shoulder"
    case blousePeplum = "blouse_peplum"
    case blouseWrap = "blouse_wrap"
    
    // Camisa
    case shirtTraditional = "shirt_traditional"
    case shirtSlim = "shirt_slim"
    case shirtOversized = "shirt_oversized"
    case shirtBoxy = "shirt_boxy"
    case shirtLongline = "shirt_longline"
    case shirtFlowy = "shirt_flowy"
    
    // Body
    case bodysuitTraditional = "bodysuit_traditional"
    case bodysuitHighCut = "bodysuit_high_cut"
    case bodysuitStrapless = "bodysuit_strapless"
    case bodysuitOneShoulder = "bodysuit_one_shoulder"
    case bodysuitHalter = "bodysuit_halter"
    case bodysuitWrap = "bodysuit_wrap"
    case bodysuitAsymmetric = "bodysuit_asymmetric"
    
    // Suéter
    case sweaterTraditional = "sweater_traditional"
    case sweaterFitted = "sweater_fitted"
    case sweaterOversized = "sweater_oversized"
    case sweaterBoxy = "sweater_boxy"
    case sweaterCropped = "sweater_cropped"
    case sweaterLongline = "sweater_longline"
    case sweaterDropShoulder = "sweater_drop_shoulder"

    var displayName: String {
        switch self {
        case .tShirtTraditional: return "Tradicional"
        case .tShirtFitted: return "Justa"
        case .tShirtOversized: return "Oversized"
        case .tShirtBoxy: return "Boxy"
        case .tShirtLongline: return "Longline"
        case .tShirtBabyLook: return "Baby look"
        case .tShirtRaglan: return "Raglan"
             
        case .tankTopTraditional: return "Tradicional"
        case .tankTopFitted: return "Justa"
        case .tankTopOversized: return "Oversized"
        case .tankTopCropped: return "Cropped"
        case .tankTopLongline: return "Longline"
        case .tankTopBoxy: return "Boxy"
        case .tankTopPeplum: return "Peplum"
        case .tankTopAsymmetric: return "Assimétrica"
             
        case .croppedTraditional: return "Tradicional"
        case .croppedUltraCropped: return "Ultra cropped"
        case .croppedFitted: return "Justo"
        case .croppedOversized: return "Oversized"
        case .croppedBoxy: return "Boxy"
        case .croppedTube: return "Tubinho/Faixa"
        case .croppedHalter: return "Frente única"
        case .croppedTie: return "Amarração/Nó"
             
        case .blouseTraditional: return "Tradicional"
        case .blouseFitted: return "Justa"
        case .blouseFlowy: return "Fluida"
        case .blouseOversized: return "Oversized"
        case .blouseOffShoulder: return "Ciganinha"
        case .blouseOneShoulder: return "Ombro único"
        case .blousePeplum: return "Peplum"
        case .blouseWrap: return "Transpassada"
             
        case .shirtTraditional: return "Tradicional"
        case .shirtSlim: return "Slim"
        case .shirtOversized: return "Oversized"
        case .shirtBoxy: return "Boxy"
        case .shirtLongline: return "Alongada"
        case .shirtFlowy: return "Fluida"
             
        case .bodysuitTraditional: return "Tradicional"
        case .bodysuitHighCut: return "Cavado"
        case .bodysuitStrapless: return "Tomara que caia"
        case .bodysuitOneShoulder: return "Ombro Único"
        case .bodysuitHalter: return "Frente Única"
        case .bodysuitWrap: return "Transpassado"
        case .bodysuitAsymmetric: return "Assimétrico"
             
        case .sweaterTraditional: return "Tradicional"
        case .sweaterFitted: return "Justo"
        case .sweaterOversized: return "Oversized"
        case .sweaterBoxy: return "Boxy"
        case .sweaterCropped: return "Cropped"
        case .sweaterLongline: return "Alongado"
        case .sweaterDropShoulder: return "Ombro caído"
        }
    }
}
