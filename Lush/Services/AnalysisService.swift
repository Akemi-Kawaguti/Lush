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

    // MARK: - Etapa 1: colorimetria
    @discardableResult
    static func startAnalysis (colorSamples: [String: UIColor], user: UserModel, in context: ModelContext) -> AnalysisModel {
        for unfinished in user.analysis where unfinished.userSilhouette.isEmpty {
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

        let analysis = AnalysisModel (userSilhouette: "", userPalette: palette, pillarColor: pillars, user: user)
        context.insert(analysis)
        return analysis
    }

    // MARK: - Etapa 2: biotipo (medidas ou foto)
    @discardableResult
    static func finishAnalysis (measurements: BodyMeasure, user: UserModel, in context: ModelContext) -> AnalysisModel {
        let analysis: AnalysisModel
        if let pending = user.pendingAnalysis {
            analysis = pending
        } else {
            analysis = startAnalysis (colorSamples: [:], user: user, in: context)
        }
        analysis.userSilhouette = mathBodyShape (measurements: measurements).rawValue
        analysis.sizeSpecifications = SizeSpecifications (shoulderSize: measurements.shoulder, waistSize: measurements.waist, hipSize: measurements.hip, user: user )
        analysis.date = Date()
        user.selectedAnalysisID = analysis.id  // a análise nova passa a ser a usada no app
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
