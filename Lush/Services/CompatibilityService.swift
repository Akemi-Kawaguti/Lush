//
//  CompatibilityService.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 09/10/26.
//

//Calcula a compatibilidade de uma peça do guarda-roupa com a usuária:
//1. Biotipo: a modelagem da peça valoriza
//2. Paleta: as cores da peça estão na paleta dela?

import SwiftUI
import UIKit

enum CompatibilityService {

    // MARK: - 1. Biotipo × modelagem

    /// Resultado da compatibilidade da modelagem com o biotipo.
    struct BodyResult {
        let level: CompatibilityLevel
        let explanation: String
    }

    static func bodyCompatibility(of clothing: ClothesModel, with bodyShape: BodyShape?) -> BodyResult {
        guard let bodyShape else {
            return BodyResult(
                level: .medium,
                explanation: "Faça sua análise para descobrir se esta modelagem valoriza o seu biotipo."
            )
        }

        guard let cut = cutToken(of: clothing) else {
            return BodyResult(
                level: .medium,
                explanation: "Não conseguimos identificar a modelagem desta peça. Edite a peça para tentar de novo."
            )
        }

        let rules = bodyRules(for: bodyShape, position: clothing.garmentPosition)
        let level: CompatibilityLevel =
            rules.high.contains(cut) ? .high :
            rules.low.contains(cut) ? .low : .medium

        let cutName = cutDisplayName(of: clothing).lowercased()
        let shapeName = bodyShape.rawValue.lowercased()
        let goal = styleGoal(for: bodyShape)

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

    /// Nome da modelagem para mostrar na tela (ex.: "Wide Leg", "Evasê").
    static func cutDisplayName(of clothing: ClothesModel) -> String {
        clothing.cutTop?.displayName
            ?? clothing.cutBottom?.displayName
            ?? clothing.cutOnePiece?.displayName
            ?? "Não especificada"
    }

    /// Parte do rawValue depois da categoria: "pants_wide_leg" → "wide_leg".
    private static func cutToken(of clothing: ClothesModel) -> String? {
        let rawValue = clothing.cutTop?.rawValue
            ?? clothing.cutBottom?.rawValue
            ?? clothing.cutOnePiece?.rawValue
        guard let rawValue else { return nil }
        return rawValue.split(separator: "_", maxSplits: 1).dropFirst().joined()
    }

    /// O que cada biotipo busca ao se vestir (usado no texto de explicação).
    private static func styleGoal(for bodyShape: BodyShape) -> String {
        switch bodyShape {
        case .hourglass: "marcar a cintura e acompanhar as curvas"
        case .triangle: "trazer destaque para a parte de cima e suavizar o quadril"
        case .invertedTriangle: "suavizar os ombros e trazer volume para a parte de baixo"
        case .rectangle: "criar curvas e marcar a cintura"
        case .oval: "alongar a silhueta com caimento fluido, sem apertar a região da cintura"
        }
    }

    // Modelagens que valorizam (high) e que não valorizam (low) cada biotipo.
    // O que não estiver nas listas é compatibilidade média.
    // Os nomes são a parte final dos rawValues dos enums GarmentCutTop/Bottom/OnePiece.
    private static func bodyRules(for bodyShape: BodyShape, position: GarmentPosition) -> (high: Set<String>, low: Set<String>) {
        switch (bodyShape, position) {

        // Ampulheta: marcar a cintura; evitar o que esconde as curvas
        case (.hourglass, .top):
            return (["fitted", "baby_look", "wrap", "slim", "tie", "cropped", "high_cut"],
                    ["oversized", "boxy", "drop_shoulder"])
        case (.hourglass, .bottom):
            return (["skinny", "slim", "pencil", "a_line", "flare", "boot_cut", "mermaid", "wrap", "fitted", "tailored", "godet"],
                    ["baggy", "boyfriend", "cargo", "jogger", "bubble"])
        case (.hourglass, .onePiece):
            return (["bodycon", "wrap", "a_line", "mermaid", "fitted", "godet"],
                    ["trapeze", "dungarees"])

        // Triângulo: volume e destaque em cima; parte de baixo com caimento que não marca o quadril
        case (.triangle, .top):
            return (["off_shoulder", "boxy", "strapless", "tube", "one_shoulder", "drop_shoulder"],
                    ["peplum", "longline", "halter", "raglan"])
        case (.triangle, .bottom):
            return (["a_line", "boot_cut", "wide_leg", "flare", "straight", "godet", "tailored", "wrap"],
                    ["skinny", "pencil", "biker", "mermaid", "bubble", "cargo", "hot_pants"])
        case (.triangle, .onePiece):
            return (["a_line", "empire", "wrap", "godet", "pantalona"],
                    ["bodycon", "mermaid", "fitted"])

        // Triângulo invertido: linhas que quebram os ombros; volume na parte de baixo
        case (.invertedTriangle, .top):
            return (["wrap", "halter", "one_shoulder", "asymmetric", "raglan", "peplum"],
                    ["off_shoulder", "boxy", "strapless", "tube"])
        case (.invertedTriangle, .bottom):
            return (["wide_leg", "flare", "boot_cut", "a_line", "godet", "pleated", "bubble", "cargo", "culotte", "pantacourt", "baggy", "mom"],
                    ["skinny", "pencil", "biker", "fitted", "capri"])
        case (.invertedTriangle, .onePiece):
            return (["a_line", "godet", "wrap", "pantalona"],
                    ["bodycon", "fitted"])

        // Retângulo: criar curvas e marcar a cintura; evitar peças retas e largas
        case (.rectangle, .top):
            return (["peplum", "wrap", "off_shoulder", "cropped", "tie", "ultra_cropped"],
                    ["boxy", "longline"])
        case (.rectangle, .bottom):
            return (["a_line", "godet", "pleated", "flare", "wide_leg", "mermaid", "bubble", "wrap", "tailored"],
                    ["boyfriend", "baggy", "jogger"])
        case (.rectangle, .onePiece):
            return (["wrap", "a_line", "godet", "mermaid"],
                    ["straight", "trapeze", "dungarees"])

        // Oval: caimento fluido e linhas verticais; evitar o que aperta ou dá volume na cintura
        case (.oval, .top):
            return (["flowy", "longline", "wrap", "asymmetric", "one_shoulder"],
                    ["fitted", "baby_look", "cropped", "ultra_cropped", "tube", "tie", "peplum", "high_cut", "slim", "strapless"])
        case (.oval, .bottom):
            return (["straight", "boot_cut", "wide_leg", "tailored", "flare", "a_line"],
                    ["bubble", "cargo", "mermaid"])
        case (.oval, .onePiece):
            return (["empire", "a_line", "trapeze", "wrap", "straight", "pantalona"],
                    ["bodycon", "mermaid", "fitted"])
        }
    }

    // MARK: - 2. Paleta × cores da peça

    /// Resultado da compatibilidade das cores com a paleta.
    struct PaletteResult {
        let level: CompatibilityLevel
        let colors: [GarmentColor]
        let explanation: String
    }

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

        // A primeira cor é a predominante: vale o dobro
        var score = 0.0
        var total = 0.0
        for (index, color) in colors.enumerated() {
            let weight = index == 0 ? 2.0 : 1.0
            total += weight
            if color.matchesPalette { score += weight }
        }
        let ratio = score / total

        let level: CompatibilityLevel = ratio >= 0.7 ? .high : ratio >= 0.4 ? .medium : .low

        // Cores longe do rosto (parte de baixo) influenciam menos
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

    /// A cor combina com a paleta se estiver bem perto de uma cor dela,
    /// ou se a paleta dela estiver entre as mais próximas dessa cor (comparando com as 12 paletas).
    private static func matches(_ color: UIColor, palette: PaleteSeason) -> Bool {
        let lab = LabColor(color)
        let distances = paletteSwatches.mapValues { swatches in
            swatches.map { lab.distance(to: $0) }.min() ?? .infinity
        }
        guard let userDistance = distances[palette],
              let best = distances.values.min() else { return false }

        return userDistance <= closeEnough || userDistance <= best + tieMargin
    }

    /// Diferença de cor (ΔE2000) abaixo da qual duas cores são "da mesma família".
    private static let closeEnough = 12.0
    /// Folga para considerar a paleta da usuária tão próxima quanto a mais próxima.
    private static let tieMargin = 5.0

    /// Cores de cada paleta (Assets) + neutros da estação, já convertidas para Lab.
    private static let paletteSwatches: [PaleteSeason: [LabColor]] = {
        var result: [PaleteSeason: [LabColor]] = [:]
        for palette in PaleteSeason.allCases {
            let assetColors = palette.colorPaletes.compactMap { UIColor(named: $0) }
            let neutrals = neutralHexes(for: palette).compactMap { UIColor(hex: $0) }
            result[palette] = (assetColors + neutrals).map { LabColor($0) }
        }
        return result
    }()

    /// As paletas do Assets não têm neutros (preto, branco, bege...), que são muito comuns em roupas.
    /// Neutros indicados para cada estação, pela teoria de coloração pessoal.
    private static func neutralHexes(for palette: PaleteSeason) -> [String] {
        switch palette {
        case .springClear, .springWarn, .springLight:
            // marfim, camelo, cinza quente claro, marinho claro, marrom dourado
            return ["#FFF5DC", "#C19A6B", "#BEB4A6", "#34558B", "#8B5A2B"]
        case .summerSoft, .summerCool, .summerLight:
            // branco suave, cinza claro, cinza azulado, marinho suave, rosa amarronzado, grafite azulado
            return ["#F4F1EC", "#C4C6CC", "#7D8A99", "#3B4A6B", "#9E7B7B", "#5A6270"]
        case .autumnSoft, .autumnWarn, .autumnDeep:
            // creme, camelo, chocolate, oliva, cáqui, grafite quente
            return ["#F3E5C8", "#B88A55", "#5B3A29", "#6B6B3A", "#A89F7B", "#4A4239"]
        case .winterClear, .winterCool, .winterDeep:
            // preto, branco puro, grafite, marinho, cinza frio
            return ["#111111", "#FFFFFF", "#3A3A3C", "#1B2440", "#A7A9AC"]
        }
    }
}

// MARK: - Cor no espaço Lab

/// Cor no espaço CIE Lab, que representa as cores como o olho humano percebe.
/// Assim a "distância" entre duas cores corresponde à diferença que a gente enxerga.
private struct LabColor {
    let l: Double
    let a: Double
    let b: Double

    init(_ color: UIColor) {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        // sRGB → RGB linear
        func linear(_ c: CGFloat) -> Double {
            let c = Double(min(max(c, 0), 1))
            return c <= 0.04045 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4)
        }
        let r = linear(red), g = linear(green), bl = linear(blue)

        // RGB linear → XYZ (luz do dia D65), normalizado pelo branco
        let x = (0.4124564 * r + 0.3575761 * g + 0.1804375 * bl) / 0.95047
        let y = (0.2126729 * r + 0.7151522 * g + 0.0721750 * bl)
        let z = (0.0193339 * r + 0.1191920 * g + 0.9503041 * bl) / 1.08883

        // XYZ → Lab
        func f(_ t: Double) -> Double {
            t > 0.008856 ? cbrt(t) : 7.787 * t + 16.0 / 116.0
        }
        let fx = f(x), fy = f(y), fz = f(z)
        l = 116 * fy - 16
        a = 500 * (fx - fy)
        b = 200 * (fy - fz)
    }

    /// Diferença entre duas cores pela fórmula CIEDE2000 (padrão da indústria).
    /// Até ~2: imperceptível. ~10: mesma família. Acima de ~20: cores diferentes.
    func distance(to other: LabColor) -> Double {
        let (l1, a1, b1) = (l, a, b)
        let (l2, a2, b2) = (other.l, other.a, other.b)

        let c1 = hypot(a1, b1), c2 = hypot(a2, b2)
        let cMean = (c1 + c2) / 2
        let g = 0.5 * (1 - sqrt(pow(cMean, 7) / (pow(cMean, 7) + pow(25, 7))))

        let a1p = (1 + g) * a1, a2p = (1 + g) * a2
        let c1p = hypot(a1p, b1), c2p = hypot(a2p, b2)

        func hue(_ b: Double, _ a: Double) -> Double {
            if a == 0 && b == 0 { return 0 }
            let h = atan2(b, a) * 180 / .pi
            return h >= 0 ? h : h + 360
        }
        let h1p = hue(b1, a1p), h2p = hue(b2, a2p)

        let deltaL = l2 - l1
        let deltaC = c2p - c1p

        var deltaHue = 0.0
        if c1p * c2p != 0 {
            let diff = h2p - h1p
            if abs(diff) <= 180 { deltaHue = diff }
            else if diff > 180 { deltaHue = diff - 360 }
            else { deltaHue = diff + 360 }
        }
        let deltaH = 2 * sqrt(c1p * c2p) * sin(deltaHue * .pi / 360)

        let lMean = (l1 + l2) / 2
        let cMeanP = (c1p + c2p) / 2

        var hMean = h1p + h2p
        if c1p * c2p != 0 {
            if abs(h1p - h2p) <= 180 { hMean = (h1p + h2p) / 2 }
            else if h1p + h2p < 360 { hMean = (h1p + h2p + 360) / 2 }
            else { hMean = (h1p + h2p - 360) / 2 }
        }

        func rad(_ degrees: Double) -> Double { degrees * .pi / 180 }
        let t = 1
            - 0.17 * cos(rad(hMean - 30))
            + 0.24 * cos(rad(2 * hMean))
            + 0.32 * cos(rad(3 * hMean + 6))
            - 0.20 * cos(rad(4 * hMean - 63))
        let deltaTheta = 30 * exp(-pow((hMean - 275) / 25, 2))
        let rc = 2 * sqrt(pow(cMeanP, 7) / (pow(cMeanP, 7) + pow(25, 7)))
        let sl = 1 + 0.015 * pow(lMean - 50, 2) / sqrt(20 + pow(lMean - 50, 2))
        let sc = 1 + 0.045 * cMeanP
        let sh = 1 + 0.015 * cMeanP * t
        let rt = -sin(rad(2 * deltaTheta)) * rc

        let termL = deltaL / sl
        let termC = deltaC / sc
        let termH = deltaH / sh
        return sqrt(termL * termL + termC * termC + termH * termH + rt * termC * termH)
    }
}


