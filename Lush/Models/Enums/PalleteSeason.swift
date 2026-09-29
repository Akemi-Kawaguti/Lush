//
//  PalleteSeason.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 29/09/26.
//

enum PalleteSeason: String, CaseIterable {
    case springClear = "Primavera Clara"
    case springWarn = "Primavera Quente"
    case springLight = "Primavera Brilhante"
    
    case summerSoft = "Verão Suave"
    case summerCool = "Verão Frio"
    case summerLight = "Verão Brilhante"
    
    case autumnSoft = "Outono Suave"
    case autumnWarn = "Outono Quente"
    case autumnDeep = "Outono Profundo"
    
    case winterClear = "Inverno Brilhante"
    case winterCool = "Inverno Frio"
    case winterDeep = "Inverno Profundo"
    
    var colorPalletes: [String]{
        switch self{
        case .springClear:
            return["nome cor 1", "cor 2", "cor 3"]
        case .springWarn:
            return["1", "2", "3"]
        case .springLight:
            return["1", "2", "3"]
            
        case .summerSoft:
            return["1", "2", "3"]
        case .summerCool:
            return["nome cor 1", "cor 2", "cor 3"]
        case .summerLight:
            return["1", "2", "3"]
            
        case .autumnSoft:
            return["1", "2", "3"]
        case .autumnWarn:
            return["1", "2", "3"]
        case .autumnDeep:
            return["nome cor 1", "cor 2", "cor 3"]
            
        case .winterClear:
            return["1", "2", "3"]
        case .winterCool:
            return["1", "2", "3"]
        case .winterDeep:
            return["1", "2", "3"]
        }
    }
}
