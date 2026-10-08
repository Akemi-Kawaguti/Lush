//
//  BiotypeMeasurementsViewModel.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 08/10/26.
//

import SwiftUI
import SwiftData
public import Combine

@MainActor
final class BiotypeMeasurementsViewModel: ObservableObject {
    
    @Published var shoulder = ""
    @Published var waist = ""
    @Published var hip = ""
    
    @Published var showResult = false
    @Published var currentAnalysis: AnalysisModel?
    
    // Converte o texto em número (aceita "48" ou "48,5")
    func number(_ text: String) -> Double? {
        Double(text.replacingOccurrences(of: ",", with: "."))
    }
    
    // Valida se as 3 medidas estão preenchidas e com valores possíveis (contornos em cm)
    var isFormValid: Bool {
        [shoulder, waist, hip].allSatisfy { text in
            guard let value = number(text) else { return false }
            return value >= 40 && value <= 250
        }
    }
    
    // Etapa 2 da análise: completa a análise da colorimetria com o biotipo e salva
    func saveAndAnalyze(using modelContext: ModelContext, users: [UserModel]) {
        guard let sVal = number(shoulder),
              let wVal = number(waist),
              let hVal = number(hip) else { return }

        let currentUser = users.first ?? UserModel.current(in: modelContext)

        let measurements = processBodyData(from: .manual(shoulderCm: sVal, waistCm: wVal, hipCm: hVal))
        let analysis = AnalysisService.finishAnalysis(measurements: measurements, user: currentUser, in: modelContext)

        do {
            try modelContext.save()
            self.currentAnalysis = analysis
            self.showResult = true // Dispara a navegação para o resultado
        } catch {
            print("Erro ao salvar dados no SwiftData: \(error.localizedDescription)")
        }
    }
}
