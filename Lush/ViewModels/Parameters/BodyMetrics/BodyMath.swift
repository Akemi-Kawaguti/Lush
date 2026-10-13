//
//  BodyMath.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 30/09/26.
//

internal import CoreFoundation

// Classifica o biotipo comparando ombros, cintura e quadril (contornos em cm).
// Regras usadas em consultoria de imagem:
// - Oval: cintura igual ou maior que ombros e quadril
// - Ombros e quadril equilibrados (diferença de até 5%):
//     cintura pelo menos 25% menor -> Ampulheta; senão -> Retângulo
// - Ombros maiores que o quadril -> Triângulo invertido
// - Quadril maior que os ombros -> Triângulo
func mathBodyShape(measurements: BodyMeasure) -> BodyShape {
    let shoulder = measurements.shoulder
    let waist = measurements.waist
    let hip = measurements.hip
    guard shoulder > 0, waist > 0, hip > 0 else { return .rectangle }

    // Limiar e tolerância
    let balanceTolerance: Double = 0.05   // ombros e quadril "iguais" se a diferença for até 5%
    let waistNarrowRatio: Double = 0.75   // cintura marcada: até 75% da maior medida

    if waist >= shoulder && waist >= hip {
        return .oval
    }

    let larger = max(shoulder, hip)
    let isBalanced = abs(shoulder - hip) <= larger * balanceTolerance

    if isBalanced {
        return waist <= larger * waistNarrowRatio ? .hourglass : .rectangle
    }

    return shoulder > hip ? .invertedTriangle : .triangle
}
