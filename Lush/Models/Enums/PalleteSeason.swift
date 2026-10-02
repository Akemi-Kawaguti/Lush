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
            return["CSp_Color_00", "CSp_Color_01", "CSp_Color_02", "CSp_Color_03", "CSp_Color_04", "CSp_Color_05", "CSp_Color_06"]
        case .springWarn:
            return["WS_Color_00", "WS_Color_01", "WS_Color_02", "WS_Color_03", "WS_Color_04", "WS_Color_05", "WS_Color_06"]
        case .springLight:
            return["LSp_Color_00", "LSp_Color_01", "LSp_Color_02", "LSp_Color_03", "LSp_Color_04", "LSp_Color_05", "LSp_Color_06"]
            
        case .summerSoft:
            return["SS_Color_00", "SS_Color_01", "SS_Color_02", "SS_Color_03", "SS_Color_04", "SS_Color_05", "SS_Color_06"]
        case .summerCool:
            return["CS_Color_00", "CS_Color_01", "CS_Color_02", "CS_Color_03", "CS_Color_04", "CS_Color_05", "CS_Color_06"]
        case .summerLight:
            return["LS_Color_00", "LS_Color_01", "LS_Color_02", "LS_Color_03", "LS_Color_04", "LS_Color_05", "LS_Color_06"]
            
        case .autumnSoft:
            return["SA_Color_00", "SA_Color_01", "SA_Color_02", "SA_Color_03", "SA_Color_04", "SA_Color_05", "SA_Color_06"]
        case .autumnWarn:
            return["WA_Color_00", "WA_Color_01", "WA_Color_02", "WA_Color_03", "WA_Color_04", "WA_Color_05", "WA_Color_06"]
        case .autumnDeep:
            return["DA_Color_00", "DA_Color_01", "DA_Color_02","DA_Color_03", "DA_Color_04", "DA_Color_05", "DA_Color_06"]
            
        case .winterClear:
            return["ClearW_Color_00", "ClearW_Color_01", "ClearW_Color_02", "ClearW_Color_03", "ClearW_Color_04", "ClearW_Color_05", "ClearW_Color_06"]
        case .winterCool:
            return["CW_Color_00", "CW_Color_01", "CW_Color_02", "CW_Color_03", "CW_Color_04", "CW_Color_05", "CW_Color_06"]
        case .winterDeep:
            return["DW_Color_00", "DW_Color_01", "DW_Color_02", "DW_Color_03", "DW_Color_04", "DW_Color_05", "DW_Color_06"]
        }
    }
}
