//
//  AnalysisService.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 06/10/26.
//

//  A análise acontece em duas etapas, em telas diferentes:
//  1. Colorimetria (startAnalysis): cria a análise com a paleta. O biotipo fica vazio ("em andamento").
//  2. Biotipo por medidas ou foto (finishAnalysis): completa a MESMA análise com o biotipo.
//  Também tem as ações da tela "Minhas avaliações": escolher e apagar uma análise.

import Foundation
import UIKit
import SwiftData

struct AnalysisService {

    // MARK: - Etapa 1: colorimetria

    /// Cria a análise com a paleta. Apaga análises que a usuária começou antes e não terminou.
    @discardableResult
    static func startAnalysis(colorSamples: [String: UIColor], user: UserModel, in context: ModelContext) -> AnalysisModel {
        // Se a usuária voltou e refez a colorimetria, descarta a análise incompleta anterior
        for unfinished in user.analysis where unfinished.userSilhouette.isEmpty {
            context.delete(unfinished)
        }

        let profile = PalleteMapper.analyze(colors: colorSamples)
        let season = profile?.season ?? .autumnDeep

        // Primeira posição: nome da estação (ex.: "Outono Profundo"); depois, os pilares
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

        let analysis = AnalysisModel(userSilhouette: "", userPalette: palette, pillarColor: pillars, user: user)
        context.insert(analysis)
        return analysis
    }

    // MARK: - Etapa 2: biotipo (medidas ou foto)

    /// Completa a análise em andamento com o biotipo e as medidas,
    /// e a torna a análise atual da usuária.
    @discardableResult
    static func finishAnalysis(measurements: BodyMeasure, user: UserModel, in context: ModelContext) -> AnalysisModel {
        // A análise criada na colorimetria. Se não existir (não deveria acontecer), cria uma sem cores.
        let analysis: AnalysisModel
        if let pending = user.pendingAnalysis {
            analysis = pending
        } else {
            analysis = startAnalysis(colorSamples: [:], user: user, in: context)
        }

        analysis.userSilhouette = mathBodyShape(measurements: measurements).rawValue
        analysis.sizeSpecifications = SizeSpecifications(
            shoulderSize: measurements.shoulder,
            waistSize: measurements.waist,
            hipSize: measurements.hip,
            user: user
        )
        analysis.date = Date()                 // data de conclusão
        user.selectedAnalysisID = analysis.id  // a análise nova passa a ser a usada no app
        return analysis
    }

    // MARK: - "Minhas avaliações"

    /// Escolhe qual análise o app usa (Home, Minha área, sugestões)
    static func select(_ analysis: AnalysisModel, for user: UserModel, in context: ModelContext) {
        user.selectedAnalysisID = analysis.id
        try? context.save()
    }

    /// Renomeia uma análise. Nome vazio volta para o padrão ("Avaliação N").
    static func rename(_ analysis: AnalysisModel, to name: String, in context: ModelContext) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        analysis.customName = trimmed.isEmpty ? nil : String(trimmed.prefix(30))
        try? context.save()
    }

    /// Apaga uma análise. Se era a escolhida, o app passa a usar a mais recente.
    static func delete(_ analysis: AnalysisModel, from user: UserModel, in context: ModelContext) {
        if user.selectedAnalysisID == analysis.id {
            user.selectedAnalysisID = nil
        }
        context.delete(analysis)
        try? context.save()
    }
}
