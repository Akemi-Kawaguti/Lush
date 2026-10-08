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
    
    // Valida se as 3 medidas estão preenchidas e com valores possíveis
    var isFormValid: Bool {
        [shoulder, waist, hip].allSatisfy { text in
            guard let value = number(text) else { return false }
            return value >= 70 && value <= 250
        }
    }
    
    // Calcula o biotipo com as funções do projeto (BodyConversion.swift e BodyMath.swift)
    var bodyShape: BodyShape {
        let measure = processBodyData(from: .manual(
            shoulderCm: number(shoulder) ?? 0,
            waistCm: number(waist) ?? 0,
            hipCm: number(hip) ?? 0
        ))
        return mathBodyShape(measurements: measure)
    }
    
    // Salva os dados no banco de dados (SwiftData) e prepara a navegação
    func saveAndAnalyze(using modelContext: ModelContext, users: [UserModel]) {
        guard let sVal = number(shoulder),
              let wVal = number(waist),
              let hVal = number(hip) else { return }

        // 1. Recupera ou cria uma usuária padrão caso ainda não exista no banco
        let currentUser = users.first ?? {
            let newUser = UserModel(name: "Usuária Lush")
            modelContext.insert(newUser)
            return newUser
        }()
         
        // 2. Busca uma análise pendente ou inicializa uma nova de forma segura
        let analysisToUse: AnalysisModel
        if let pendingAnalysis = currentUser.analysis.sorted(by: { $0.date > $1.date }).first, pendingAnalysis.userSilhouette.isEmpty {
            analysisToUse = pendingAnalysis
        } else {
            let freshAnalysis = AnalysisModel(userSilhouette: "", userPalette: [], user: currentUser)
            modelContext.insert(freshAnalysis)
            analysisToUse = freshAnalysis
        }
             
        analysisToUse.userSilhouette = bodyShape.rawValue

        // 3. Cria o objeto de especificações de tamanho
        let sizeSpecs = SizeSpecifications(
            shoulderSize: sVal,
            waistSize: wVal,
            hipSize: hVal,
            user: currentUser
        )
        modelContext.insert(sizeSpecs)
        analysisToUse.sizeSpecifications = sizeSpecs

        do {
            try modelContext.save()
            self.currentAnalysis = analysisToUse
            self.showResult = true // Dispara a navegação
        } catch {
            print("Erro ao salvar dados no SwiftData: \(error.localizedDescription)")
        }
    }
}
