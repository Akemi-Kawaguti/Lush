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
            if let skinColor = skinColor { colorSamples["pele"] = UIColor(skinColor) }
            if let hairColor = hairColor { colorSamples["cabelo"] = UIColor(hairColor) }
            if let eyeColor = eyeColor {
                colorSamples["olhoEsquerdo"] = UIColor(eyeColor)
                colorSamples["olhoDireito"] = UIColor(eyeColor)
            }
            
            let descriptor = FetchDescriptor<UserModel>()
            let currentUser = try? modelContext.fetch(descriptor).first ?? {
                let newUser = UserModel(name: "Usuária Lush")
                modelContext.insert(newUser)
                return newUser
            }()
            
            guard let user = currentUser else { return }

            // Exemplo: se você usa o AnalysisService para gerar a análise com base nas cores:
            let measurements = BodyMeasure(shoulder: 0, waist: 0, hip: 0)
            let newAnalysis = AnalysisService.performNewAnalysis(
                measurements: measurements,
                colorSamples: colorSamples,
                user: user
            )
            
            modelContext.insert(newAnalysis)
            
            do {
                try modelContext.save()
                showBiotypeMethod = true // Avança para a próxima tela
            } catch {
                print("Erro ao salvar colorimetria: \(error.localizedDescription)")
            }
        }
}
