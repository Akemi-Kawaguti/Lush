//
//  ColorMath.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 30/09/26.
//

import UIKit

struct ColorMetrics {
    let temperature: String
    let brightness: CGFloat
    let saturation: CGFloat
    let isWarm: Bool
}

class ColorMetricsAnalyzer {
    
    // Limiares de Calibração (Thresholds)
    // Para ajustar estes valores facilmente se notar distorções nos testes.
    
    private struct Thresholds {
        // Matiz (Hue) da pele para considerar subtom quente (aprox. 14° a 47°)
        // Peles com Hue tipicamente entre 0.05 e 0.12 (escala 0 a 1, ou seja, ~18° a 43°) tendem a ser quentes se tiverem saturação saudável.
        static let skinHueMin: CGFloat = 0.04
        static let skinHueMax: CGFloat = 0.13
        
        // Cabelo quente
        // Cabelos com tons acinzentados tendem a baixar a saturação global do cabelo.
        static let hairHueMin: CGFloat = 0.05
        static let hairHueMax: CGFloat = 0.15
        static let hairMinSatForWarm: CGFloat = 0.25
    }

    static func extractMetrics(from colors: [String: UIColor]) -> ColorMetrics? {
        guard let skin = colors["pele"],
              let hair = colors["cabelo"] else {
            return nil
        }

        var skinHue: CGFloat = 0, skinSat: CGFloat = 0, skinBright: CGFloat = 0, skinAlpha: CGFloat = 0
        skin.getHue(&skinHue, saturation: &skinSat, brightness: &skinBright, alpha: &skinAlpha)

        var hairHue: CGFloat = 0, hairSat: CGFloat = 0, hairBright: CGFloat = 0, hairAlpha: CGFloat = 0
        hair.getHue(&hairHue, saturation: &hairSat, brightness: &hairBright, alpha: &hairAlpha)

        let leftEye = colors["olhoEsquerdo"]
        let rightEye = colors["olhoDireito"]
        var avgEyeSat: CGFloat = 0.3
        
        if let lEye = leftEye, let rEye = rightEye {
            var h1: CGFloat = 0, s1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
            var h2: CGFloat = 0, s2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
            lEye.getHue(&h1, saturation: &s1, brightness: &b1, alpha: &a1)
            rEye.getHue(&h2, saturation: &s2, brightness: &b2, alpha: &a2)
            avgEyeSat = (s1 + s2) / 2.0
        }

        let isWarmSkin = (skinHue >= Thresholds.skinHueMin && skinHue <= Thresholds.skinHueMax) ||
                         (hairHue > Thresholds.hairHueMin && hairHue < Thresholds.hairHueMax && hairSat > Thresholds.hairMinSatForWarm)
        
        let temperature = isWarmSkin ? "Quente" : "Frio"
        // Determinar Profundidade (Baseado no brilho da pele e do cabelo)
        let globalBrightness = (skinBright * 0.6) + (hairBright * 0.4)
        let globalSaturation = (skinSat + hairSat + avgEyeSat) / 3.0

        return ColorMetrics(
            temperature: temperature,
            brightness: globalBrightness,
            saturation: globalSaturation,
            isWarm: isWarmSkin
        )
    }
}
