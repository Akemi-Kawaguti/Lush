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
    var showResult = false
    var createdAnalysis: AnalysisModel?
    var errorMessage: String?       
    
    // Etapa 2 da análise (pela foto): mede o corpo com o Vision e completa a análise
    func processPhotoAndSave(image: UIImage?, modelContext: ModelContext, users: [UserModel]) async {
        guard let uiImage = image?.fixedOrientation(), let cgImage = uiImage.cgImage else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        let measurements: BodyMeasure
        do {
            measurements = try await analyzeBodyProportions(in: cgImage, userRealHeightCm: 170.0)
        } catch {
            // Mensagem específica (braços encostados, foto de lado...) ou uma genérica
            errorMessage = (error as? LocalizedError)?.errorDescription
                ?? "Não conseguimos identificar seu corpo na foto. Tente uma foto de corpo inteiro, de frente e com boa iluminação, ou informe suas medidas."
            return
        }
        let currentUser = users.first ?? UserModel.current(in: modelContext)
        let analysis = AnalysisService.finishAnalysis(measurements: measurements, user: currentUser, in: modelContext)
        
        try? modelContext.save()
        createdAnalysis = analysis
        showResult = true
    }
}
