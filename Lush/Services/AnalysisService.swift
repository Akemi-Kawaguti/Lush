//
//  AnalysisService.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 06/10/26.
//

import Foundation
import UIKit
import SwiftData

struct AnalysisService {
    
    static func performNewAnalysis(
        measurements: BodyMeasure,
        colorSamples: [String: UIColor],
        user: UserModel? = nil ) -> AnalysisModel {
        
        // 1. Executa o algoritmo de biotipo (convertendo o Enum para String ou salvando conforme sua modelagem)
        let detectedBodyShape = mathBodyShape(measurements: measurements)
        
        // 2. Executa o mapeamento de cores
        let colorProfile = PalleteMapper.analyze(colors: colorSamples)
        
        // 3. Extrai as informações relevantes para preencher o AnalysisModel
        let silhouetteString = detectedBodyShape.rawValue // Ou a descrição textual equivalente
        
        // Exemplo de preenchimento da paleta de cores com base na estação detectada
        var paletteStrings: [String] = []
        let seasonName = colorProfile?.season.rawValue ?? "Padrão"
        paletteStrings.append(seasonName)
        if let temp = colorProfile?.temperature { paletteStrings.append(temp) }
        if let depth = colorProfile?.depth { paletteStrings.append(depth) }
        if let saturation = colorProfile?.saturation { paletteStrings.append(saturation) }
        
        // 4. Instancia e retorna o AnalysisModel
        let newAnalysis = AnalysisModel( id: UUID(),date: Date(), userSilhouette: silhouetteString, userPalette: paletteStrings, pillarColor: nil, sizeSpecifications: nil, user: user )
        
        return newAnalysis
    }
}
