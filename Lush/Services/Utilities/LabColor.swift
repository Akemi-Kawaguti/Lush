//
//  LabColor.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 13/10/26.
//

import UIKit

// Cor no espaço CIE Lab, que representa as cores como o olho humano percebe.
// Assim a "distância" entre duas cores corresponde à diferença que a gente enxerga.
struct LabColor {
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
            return t > 0.008856 ? cbrt(t) : (7.787 * t) + (16.0 / 116.0)
        }
        let fx = f(x), fy = f(y), fz = f(z)
        
        self.l = (116.0 * fy) - 16.0
        self.a = 500.0 * (fx - fy)
        self.b = 200.0 * (fy - fz)
    }

    // Diferença entre duas cores pela fórmula CIEDE2000 (padrão da indústria).
    // Até ~2: imperceptível. ~10: mesma família. Acima de ~20: cores diferentes.
    func distance(to other: LabColor) -> Double {
        let (l1, a1, b1) = (l, a, b)
        let (l2, a2, b2) = (other.l, other.a, other.b)

        let c1 = hypot(a1, b1), c2 = hypot(a2, b2)
        let cMean = (c1 + c2) / 2
        let g = 0.5 * (1.0 - sqrt(pow(cMean, 7) / (pow(cMean, 7) + pow(25, 7))))

        let a1p = (1.0 + g) * a1, a2p = (1.0 + g) * a2
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
        let deltaH = 2.0 * sqrt(c1p * c2p) * sin(deltaHue * .pi / 360)

        let lMean = (l1 + l2) / 2
        let cMeanP = (c1p + c2p) / 2

        var hMean = h1p + h2p
        if c1p * c2p != 0 {
            if abs(h1p - h2p) <= 180 { hMean = (h1p + h2p) / 2 }
            else if h1p + h2p < 360 { hMean = (h1p + h2p + 360) / 2 }
            else { hMean = (h1p + h2p - 360) / 2 }
        }

        func rad(_ degrees: Double) -> Double { degrees * .pi / 180 }
        let t = 1.0 - 0.17 * cos(rad(hMean - 30))
            + 0.24 * cos(rad(2 * hMean))
            + 0.32 * cos(rad(3 * hMean + 6))
            - 0.20 * cos(rad(4 * hMean - 63))
        
        let deltaTheta = 30.0 * exp(-pow((hMean - 275) / 25, 2))
        let rc = 2.0 * sqrt(pow(cMeanP, 7) / (pow(cMeanP, 7) + pow(25, 7)))
        let sl = 1.0 + (0.015 * pow(lMean - 50, 2)) / sqrt(20.0 + pow(lMean - 50, 2))
        let sc = 1.0 + 0.045 * cMeanP
        let sh = 1.0 + 0.015 * cMeanP * t
        let rt = -sin(rad(2 * deltaTheta)) * rc

        let termL = deltaL / sl
        let termC = deltaC / sc
        let termH = deltaH / sh
        return sqrt(termL * termL + termC * termC + termH * termH + rt * termC * termH)
    }
}
