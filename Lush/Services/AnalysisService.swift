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

    // MARK: - Fluxo de avaliação (triagem)
    //
    // Cada vez que a usuária faz o fluxo de avaliação, deve existir UMA análise só,
    // mesmo que ela volte telas e refaça a colorimetria, a foto ou as medidas.
    // Guardamos aqui qual é a análise do fluxo aberto.
    private static var flowAnalysisID: UUID?

    /// Chamado quando o fluxo de avaliação abre (primeira tela da colorimetria).
    /// A partir daqui, a próxima análise criada é a deste fluxo.
    static func beginFlow() {
        flowAnalysisID = nil
    }

    /// Análise do fluxo aberto agora (se ainda existir)
    private static func flowAnalysis(of user: UserModel) -> AnalysisModel? {
        guard let id = flowAnalysisID else { return nil }
        return user.analysis.first { $0.id == id }
    }

    // MARK: - Etapa 1: colorimetria
    @discardableResult
    static func startAnalysis (colorSamples: [String: UIColor], user: UserModel, in context: ModelContext) -> AnalysisModel {
        let current = flowAnalysis(of: user)

        // Apaga análises que ficaram pela metade (menos a deste fluxo)
        for unfinished in user.analysis where unfinished.userSilhouette.isEmpty && unfinished.id != current?.id {
            context.delete(unfinished)
        }

        let profile = PalleteMapper.analyze (colors: colorSamples)
        let season = profile?.season ?? .autumnDeep

        var palette = [season.rawValue]
        if let profile {
            palette += [profile.temperature, profile.depth, profile.saturation]
        }

        let pillars = PillarsColor(
            temperature: profile?.temperature ?? "Neutro",
            brightness: profile?.depth ?? "Média",
            contrast: "Médio",
            saturation: profile?.saturation ?? "Média",
            user: user
        )

        // Voltou e refez a colorimetria no mesmo fluxo: atualiza a mesma análise
        if let current {
            if let oldPillars = current.pillarColor {
                context.delete(oldPillars)
            }
            current.userPalette = palette
            current.pillarColor = pillars
            current.date = Date()
            return current
        }

        let analysis = AnalysisModel (userSilhouette: "", userPalette: palette, pillarColor: pillars, user: user)
        context.insert(analysis)
        flowAnalysisID = analysis.id
        return analysis
    }

    // MARK: - Etapa 2: biotipo (medidas ou foto)
    @discardableResult
    static func finishAnalysis (measurements: BodyMeasure, user: UserModel, in context: ModelContext) -> AnalysisModel {
        // Usa a análise deste fluxo: assim, se a usuária voltar e mudar a foto ou as medidas,
        // a mesma análise é atualizada (com a paleta certa), sem criar outra
        let analysis: AnalysisModel
        if let current = flowAnalysis(of: user) {
            analysis = current
        } else if let pending = user.pendingAnalysis {
            analysis = pending
        } else {
            analysis = startAnalysis (colorSamples: [:], user: user, in: context)
        }

        // Troca as medidas antigas pelas novas (sem deixar registros soltos)
        if let oldSizes = analysis.sizeSpecifications {
            context.delete(oldSizes)
        }

        analysis.userSilhouette = mathBodyShape (measurements: measurements).rawValue
        analysis.sizeSpecifications = SizeSpecifications (shoulderSize: measurements.shoulder, waistSize: measurements.waist, hipSize: measurements.hip, user: user )
        analysis.date = Date()
        user.selectedAnalysisID = analysis.id  // a análise nova passa a ser a usada no app
        flowAnalysisID = analysis.id
        return analysis
    }

    // MARK: - "Minhas avaliações"
    static func select(_ analysis: AnalysisModel, for user: UserModel, in context: ModelContext) {
        user.selectedAnalysisID = analysis.id
        try? context.save()
    }
    static func rename(_ analysis: AnalysisModel, to name: String, in context: ModelContext) {
        let trimmed = name.trimmingCharacters (in: .whitespacesAndNewlines)
        analysis.customName = trimmed.isEmpty ? nil : String(trimmed.prefix(30))
        try? context.save()
    }
    static func delete(_ analysis: AnalysisModel, from user: UserModel, in context: ModelContext) {
        if user.selectedAnalysisID == analysis.id {
            user.selectedAnalysisID = nil
        }
        context.delete(analysis)
        try? context.save()
    }
}
