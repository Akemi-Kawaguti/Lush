//
//  BodyMath.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 30/09/26.
//

import Foundation

func processBodyData(from source: BodyInputSource) -> BodyMeasure{
    switch source {
    case .photo(let shoulderPixels, let hipPixels, _, let skeletonHeightPixels, let userRealHeightCm):
        
        let cmPerPixel = userRealHeightCm/skeletonHeightPixels
        
        let shoulderCm = shoulderPixels * cmPerPixel
        let hipCm = hipPixels * cmPerPixel
        
        let estimatedWaistCm = ((shoulderCm + hipCm) / 2) * 0.85
        
        return BodyMeasure(shoulder: shoulderCm, waist: estimatedWaistCm, hip: hipCm)
        
    case .manual(let shoulderCm, let waistCm, let hipCm):
        return BodyMeasure(shoulder: shoulderCm, waist: waistCm, hip: hipCm)
    }
}

//MARK: o Vision retorna 2 pontos nativos, sendo ombro e quadril, por isso são CGFloat
// mas a cintura é CGPoint, para que fosse mais padronizado, uso tipo genérico e faço conversões dos tipos
// em resumo, sendo foto ou dados fornecidos manualmente, tudo vida cm
