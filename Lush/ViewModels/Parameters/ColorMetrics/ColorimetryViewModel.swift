//
//  ColorimetryViewModel.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 07/10/26.
//

import SwiftUI
import SwiftData

@Observable
final class ColorimetryViewModel {
    var image: UIImage?
    var showBiotypeMethod = false
    
    var skinColor: Color?
    var hairColor: Color?
    var eyeColor: Color?
    
    var hasAllColors: Bool {
        skinColor != nil && hairColor != nil && eyeColor != nil
    }
    
    let user: UserModel?
    
    init(image: UIImage?, user: UserModel? = nil) {
        self.image = image
        self.user = user
    }
    
    func saveAnalysisAndProceed(modelContext: ModelContext) {
        var colorSamples: [String: UIColor] = [:]
        if let skinColor = skinColor { colorSamples["skin"] = UIColor(skinColor) }
        if let hairColor = hairColor { colorSamples["hair"] = UIColor(hairColor) }
        if let eyeColor = eyeColor { colorSamples["eyes"] = UIColor(eyeColor) }
        
        // Medidas padrão (substitua conforme sua tela de medidas reais)
        let dummyMeasurements = BodyMeasure(shoulder: 0, waist: 0, hip: 0)
        
        let newAnalysis = AnalysisService.performNewAnalysis(
            measurements: dummyMeasurements,
            colorSamples: colorSamples,
            user: user
        )
        
        modelContext.insert(newAnalysis)
        
        if let user = user {
            user.analysis.append(newAnalysis)
        }
        
        try? modelContext.save()
        
        showBiotypeMethod = true
    }
}
