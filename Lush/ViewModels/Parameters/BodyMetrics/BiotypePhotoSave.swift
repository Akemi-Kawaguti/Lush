//
//  BiotypePhotoSave.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 07/10/26.
//

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
    var errorMessage: String?          // aviso quando o Vision não encontra o corpo na foto
    
    // Etapa 2 da análise (pela foto): mede o corpo com o Vision e completa a análise
    func processPhotoAndSave(image: UIImage?, modelContext: ModelContext, users: [UserModel]) async {
        // Corrige a orientação: fotos da câmera vêm "deitadas" nos pixels
        guard let uiImage = image?.fixedOrientation(), let cgImage = uiImage.cgImage else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        // 1. Executa a análise do Vision na foto
        guard let measurements = await analyzeBodyProportions(in: cgImage, userRealHeightCm: 170.0) else {
            errorMessage = "Não conseguimos identificar seu corpo na foto. Tente uma foto de corpo inteiro, de frente e com boa iluminação, ou informe suas medidas."
            return
        }
        
        // 2. Completa a análise da colorimetria com o biotipo
        let currentUser = users.first ?? UserModel.current(in: modelContext)
        let analysis = AnalysisService.finishAnalysis(measurements: measurements, user: currentUser, in: modelContext)
        
        // 3. Salva e navega para o resultado
        try? modelContext.save()
        createdAnalysis = analysis
        showResult = true
    }
}
