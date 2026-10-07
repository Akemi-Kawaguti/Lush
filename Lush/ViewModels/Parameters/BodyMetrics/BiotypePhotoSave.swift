//
//  BiotypePhotoSave.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 07/10/26.
//

import SwiftUI
import SwiftData
import UIKit

@Observable
final class BiotypePhotoSave {
    var isLoading = false
    var detectedBodyShape: BodyShape = .rectangle
    var showResult = false
    var createdAnalysis: AnalysisModel?

    func processPhotoAndSave(
        image: UIImage?,
        modelContext: ModelContext,
        users: [UserModel]
    ) async {
        guard let uiImage = image, let cgImage = uiImage.cgImage else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        // 1. Executa a análise do Vision na foto
        guard let measurements = await analyzeBodyProportions(in: cgImage, userRealHeightCm: 170.0) else {
            print("Não foi possível extrair as proporções corporais da foto.")
            return
        }
        
        // 2. Calcula o formato corporal utilizando a função matemática
        let bodyShape = mathBodyShape(measurements: measurements)
        detectedBodyShape = bodyShape
        
        // 3. Recupera o usuário atual do banco de dados (ou cria um padrão se não existir)
        let currentUser: UserModel
        if let existingUser = users.first {
            currentUser = existingUser
        } else {
            currentUser = UserModel(name: "Usuário Padrão")
            modelContext.insert(currentUser)
        }
        
        // 4. Executa o serviço de análise para criar o modelo estruturado
        let newAnalysis = AnalysisService.performNewAnalysis(
            measurements: measurements,
            colorSamples: [:],
            user: currentUser
        )
        
        // 5. Salva no SwiftData
        modelContext.insert(newAnalysis)
        try? modelContext.save()
        
        // 6. Autoriza a navegação para a tela de resultado
        self.createdAnalysis = newAnalysis
        showResult = true
    }
}
