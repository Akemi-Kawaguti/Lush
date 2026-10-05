//
//  PalleteMapper.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 05/10/26.
//

import UIKit

struct ColorProfile {
    let season: PalleteSeason
    let temperature: String
    let depth: String
    let saturation: String
}

class PalleteMapper {

    private struct Thresholds {
        
        // Brilho global (Profundidade)
        static let brightnessLight: CGFloat = 0.70
        static let brightnessMedium: CGFloat = 0.45
        
        // Saturação global (Intensidade)
        static let satVeryLow: CGFloat = 0.18
        static let satLow: CGFloat = 0.30
        static let satMedium: CGFloat = 0.48
        static let satHigh: CGFloat = 0.65
    }

    static func analyze(colors: [String: UIColor]) -> ColorProfile? {
        // 1. Delega a extração de métricas puras
        guard let metrics = ColorMetricsAnalyzer.extractMetrics(from: colors) else {
            return nil
        }

        // 2. Determina Profundidade
        let depth: String
        if metrics.brightness > Thresholds.brightnessLight {
            depth = "Clara"
        } else if metrics.brightness > Thresholds.brightnessMedium {
            depth = metrics.isWarm ? "Média" : "Média-Escura"
        } else {
            depth = "Escura"
        }

        // 3. Determina Saturação 
        let saturation: String
        if metrics.saturation < Thresholds.satVeryLow {
            saturation = "Muito Baixa"
        } else if metrics.saturation < Thresholds.satLow {
            saturation = "Baixa"
        } else if metrics.saturation < Thresholds.satMedium {
            saturation = "Média"
        } else if metrics.saturation < Thresholds.satHigh {
            saturation = "Alta"
        } else {
            saturation = "Muito Alta"
        }

        // 4. Mapeia para a Estação
        let detectedSeason = mapToSeason(isWarm: metrics.isWarm, brightnessVal: metrics.brightness, saturationVal: metrics.saturation)

        return ColorProfile(
            season: detectedSeason,
            temperature: metrics.temperature,
            depth: depth,
            saturation: saturation
        )
    }

    private static func mapToSeason(isWarm: Bool, brightnessVal: CGFloat, saturationVal: CGFloat) -> PalleteSeason {
        if isWarm {
            if brightnessVal > Thresholds.brightnessLight {
                if saturationVal > 0.50 { return .springLight }
                else if saturationVal < 0.30 { return .autumnSoft }
                else { return .springClear }
            } else if brightnessVal > Thresholds.brightnessMedium {
                if saturationVal > 0.45 { return .springWarn }
                else if saturationVal < 0.28 { return .autumnSoft }
                else { return .autumnWarn }
            } else {
                return .autumnDeep
            }
        } else {
            if brightnessVal > Thresholds.brightnessLight {
                if saturationVal > 0.45 { return .winterClear }
                else { return .summerLight }
            } else if brightnessVal > Thresholds.brightnessMedium {
                if saturationVal < 0.25 { return .summerSoft }
                else if saturationVal > 0.50 { return .winterClear }
                else { return .summerCool }
            } else {
                if saturationVal > 0.40 { return .winterDeep }
                else { return .winterCool }
            }
        }
    }
}
