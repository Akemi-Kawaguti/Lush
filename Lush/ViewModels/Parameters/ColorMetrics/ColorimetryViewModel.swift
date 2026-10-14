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
        // Os nomes das chaves precisam ser os que o ColorMetricsAnalyzer procura
        var colorSamples: [String: UIColor] = [:]
        if let skinColor { colorSamples["pele"] = UIColor(skinColor) }
        if let hairColor { colorSamples["cabelo"] = UIColor(hairColor) }
        if let eyeColor {
            colorSamples["olhoEsquerdo"] = UIColor(eyeColor)
            colorSamples["olhoDireito"] = UIColor(eyeColor)
        }

        let currentUser = user ?? UserModel.current(in: modelContext)
        AnalysisService.startAnalysis(colorSamples: colorSamples, user: currentUser, in: modelContext)

        do {
            try modelContext.save()
            showBiotypeMethod = true
        } catch { #if DEBUG
            print("Erro ao salvar colorimetria: \(error.localizedDescription)") #endif
        }
    }
}
