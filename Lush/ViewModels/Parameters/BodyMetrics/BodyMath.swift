//
//  BodyMath.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 30/09/26.
//

internal import CoreFoundation

func mathBodyShape(measurements: BodyMeasure) -> BodyShape {
    let shoulder = measurements.shoulder
    let waist = measurements.waist
    let hip = measurements.hip
    guard shoulder > 0, waist > 0, hip > 0 else { return .rectangle }

    let balanceTolerance: Double = 0.09   // ombros e quadril "iguais" se a diferença for até n%
    let waistNarrowRatio: Double = 0.80   // cintura marcada: até n% da maior medida

    if waist >= shoulder && waist >= hip {
        return .oval
    }

    let larger = max(shoulder, hip)
    let isBalanced = abs(shoulder - hip) <= larger * balanceTolerance
    let isSuperCinturada = waist <= larger * 0.72
        
        if isBalanced || isSuperCinturada{
        return waist <= larger * waistNarrowRatio ? .hourglass : .rectangle
    }

    return shoulder > hip ? .invertedTriangle : .triangle
}
