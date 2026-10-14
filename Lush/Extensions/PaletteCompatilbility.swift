//
//  PaletteCompatilbility.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 13/10/26.
//

// MARK: - Extensões de Regras para PaleteSeason
extension PaleteSeason {
    var neutralHexes: [String] {
        switch self {
        case .springClear, .springWarn, .springLight:
            return ["#FFF5DC", "#C19A6B", "#BEB4A6", "#34558B", "#8B5A2B"]
        case .summerSoft, .summerCool, .summerLight:
            return ["#F4F1EC", "#C4C6CC", "#7D8A99", "#3B4A6B", "#9E7B7B", "#5A6270"]
        case .autumnSoft, .autumnWarn, .autumnDeep:
            return ["#F3E5C8", "#B88A55", "#5B3A29", "#6B6B3A", "#A89F7B", "#4A4239"]
        case .winterClear, .winterCool, .winterDeep:
            return ["#111111", "#FFFFFF", "#3A3A3C", "#1B2440", "#A7A9AC"]
        }
    }
}
