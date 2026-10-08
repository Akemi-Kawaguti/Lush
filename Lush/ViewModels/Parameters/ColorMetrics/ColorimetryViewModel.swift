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
    
    // Etapa 1 da análise: calcula a paleta com as cores do conta-gotas e salva
    func saveAnalysisAndProceed(modelContext: ModelContext) {
        // Os nomes das chaves precisam ser os que o ColorMetricsAnalyzer procura
        var colorSamples: [String: UIColor] = [:]
        if let skinColor { colorSamples["pele"] = UIColor(skinColor) }
        if let hairColor { colorSamples["cabelo"] = UIColor(hairColor) }
        if let eyeColor {
            // O conta-gotas pega um olho só: usa a mesma cor para os dois
            colorSamples["olhoEsquerdo"] = UIColor(eyeColor)
            colorSamples["olhoDireito"] = UIColor(eyeColor)
        }

        let currentUser = user ?? UserModel.current(in: modelContext)
        AnalysisService.startAnalysis(colorSamples: colorSamples, user: currentUser, in: modelContext)

        do {
            try modelContext.save()
            showBiotypeMethod = true // Avança para a escolha do método do biotipo
        } catch {
            print("Erro ao salvar colorimetria: \(error.localizedDescription)")
        }
    }
}
