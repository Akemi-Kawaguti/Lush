//
//  CompatibilityService.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 09/10/26.
//

import SwiftUI
import UIKit

struct CompatibilityService {
    
    // MARK: - 1. Biotipo × modelagem
    static func bodyCompatibility(of clothing: ClothesModel, with bodyShape: BodyShape?) -> BodyResult {
        guard let bodyShape else {
            return BodyResult( level: .medium, explanation: "Faça sua análise para descobrir se esta modelagem valoriza o seu biotipo." )
        }
        
        guard let cut = cutToken(of: clothing) else {
            return BodyResult( level: .medium, explanation: "Não conseguimos identificar a modelagem desta peça. Edite a peça para tentar de novo." )
        }
        
        let rules = bodyShape.rules(for: clothing.garmentPosition)
        let level: CompatibilityLevel =
        rules.high.contains(cut) ? .high :
        rules.low.contains(cut) ? .low : .medium
        
        let cutName = cutDisplayName(of: clothing).lowercased()
        let shapeName = bodyShape.rawValue.lowercased()
        let goal = bodyShape.styleGoal
        
        let explanation: String
        switch level {
        case .high:
            explanation = "A modelagem \(cutName) ajuda a \(goal), por isso valoriza o biotipo \(shapeName)."
        case .medium:
            explanation = "A modelagem \(cutName) é neutra para o biotipo \(shapeName). Para valorizar ainda mais, combine com peças que ajudem a \(goal)."
        case .low:
            explanation = "A modelagem \(cutName) não ajuda a \(goal). Se quiser usar, combine com peças que equilibrem a silhueta."
        }
        return BodyResult(level: level, explanation: explanation)
    }
    
    static func cutDisplayName(of clothing: ClothesModel) -> String {
        clothing.cutTop?.displayName
        ?? clothing.cutBottom?.displayName
        ?? clothing.cutOnePiece?.displayName
        ?? "Não especificada"
    }
    
    private static func cutToken(of clothing: ClothesModel) -> String? {
        let rawValue = clothing.cutTop?.rawValue
        ?? clothing.cutBottom?.rawValue
        ?? clothing.cutOnePiece?.rawValue
        guard let rawValue else { return nil }
        return rawValue.split(separator: "_", maxSplits: 1).dropFirst().joined()
    }
    
    // MARK: - 2. Paleta × cores da peça
    static func paletteCompatibility(of clothing: ClothesModel, with palette: PaleteSeason?) -> PaletteResult {
        let uiColors = clothing.predominantColors.compactMap { UIColor(hex: $0) }
        
        guard let palette else {
            return PaletteResult(
                level: .medium,
                colors: uiColors.map { GarmentColor(color: Color(uiColor: $0), matchesPalette: true) },
                explanation: "Faça sua análise para descobrir se as cores desta peça estão na sua paleta."
            )
        }
        
        guard !uiColors.isEmpty else {
            return PaletteResult(
                level: .medium,
                colors: [],
                explanation: "Não conseguimos identificar as cores desta peça."
            )
        }
        
        let colors = uiColors.map { color in
            GarmentColor(color: Color(uiColor: color), matchesPalette: matches(color, palette: palette))
        }
        
        var score = 0.0
        var total = 0.0
        for (index, color) in colors.enumerated() {
            let weight = index == 0 ? 2.0 : 1.0
            total += weight
            if color.matchesPalette { score += weight }
        }
        let ratio = score / total
        
        let level: CompatibilityLevel = ratio >= 0.7 ? .high : ratio >= 0.4 ? .medium : .low
        
        let farFromFace = clothing.garmentPosition == .bottom
        let paletteName = palette.rawValue
        
        let explanation: String
        switch level {
        case .high:
            explanation = "As cores desta peça estão na sua paleta \(paletteName) e harmonizam com o seu tom de pele, cabelo e olhos."
        case .medium:
            explanation = farFromFace
            ? "Parte das cores está na sua paleta \(paletteName). Como é uma peça de baixo, longe do rosto, ela funciona bem."
            : "Parte das cores está na sua paleta \(paletteName). Combine com acessórios ou uma terceira peça nas suas cores perto do rosto."
        case .low:
            explanation = farFromFace
            ? "As cores desta peça estão fora da sua paleta \(paletteName), mas, por ficarem longe do rosto, interferem pouco. Combine com uma parte de cima nas suas cores."
            : "As cores desta peça estão fora da sua paleta \(paletteName). Se quiser usar, use um lenço, colar ou blusa nas suas cores perto do rosto."
        }
        return PaletteResult(level: level, colors: colors, explanation: explanation)
    }
    
    private static func matches(_ color: UIColor, palette: PaleteSeason) -> Bool {
        let lab = LabColor(color)
        let distances = paletteSwatches.mapValues { swatches in
            swatches.map { lab.distance(to: $0) }.min() ?? .infinity
        }
        guard let userDistance = distances[palette],
              let best = distances.values.min() else { return false }
        
        return userDistance <= closeEnough || userDistance <= best + tieMargin
    }
    
    private static let closeEnough = 12.0
    private static let tieMargin = 5.0
    
    private static let paletteSwatches: [PaleteSeason: [LabColor]] = {
        var result: [PaleteSeason: [LabColor]] = [:]
        for palette in PaleteSeason.allCases {
            let assetColors = palette.colorPaletes.compactMap { UIColor(named: $0) }
            let neutrals = palette.neutralHexes.compactMap { UIColor(hex: $0) }
            result[palette] = (assetColors + neutrals).map { LabColor($0) }
        }
        return result
    }()
    
    public struct BodyResult {
            public let level: CompatibilityLevel
            public let explanation: String
        }
        
        public struct PaletteResult {
            public let level: CompatibilityLevel
            public let colors: [GarmentColor]
            public let explanation: String
        }
}
