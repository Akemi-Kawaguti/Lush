//
//  BodyMath.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 30/09/26.
//

internal import CoreFoundation

func mathBodyShape(measurements: BodyMeasure) -> BodyShape {
    let shoulderSize = measurements.shoulder
    let waistSize = measurements.waist
    let hipSize = measurements.hip
    let average = (shoulderSize + waistSize + hipSize) / 3
    
    //Limiar e Tolerância
    let dominanceMultiplier: Double = 1.05
    let balanceTolerance: Double = 0.05
    let waistNarrowRatio: Double = 0.85
    
    let shoulderHipDiff = abs(shoulderSize - hipSize)
    
    //MARK: Regras de Classificação
    if shoulderSize > average * dominanceMultiplier && shoulderHipDiff <= (shoulderSize * balanceTolerance) {
        return .invertedTriangle
    }
    
    if hipSize > average * dominanceMultiplier && shoulderHipDiff <= (hipSize * balanceTolerance) {
        return .triangle
    }
    
    if waistSize > average * dominanceMultiplier {
        return .oval
    }
    
    if shoulderHipDiff <= (shoulderSize * balanceTolerance) && waistSize < shoulderSize * waistNarrowRatio {
        return .hourglass
    }
    
    return .rectangle
}


