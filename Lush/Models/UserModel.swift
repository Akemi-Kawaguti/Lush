//
//  UserModel.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 28/09/26.
//

import Foundation
import SwiftData

@Model
final class UserModel {
    var name: String
    var photoData: Data?
    var favorites: [String]
    var selectedAnalysisID: UUID? = nil   // análise escolhida em "Minhas avaliações"
    
    @Relationship(deleteRule: .cascade, inverse: \AnalysisModel.user)
    var analysis: [AnalysisModel] = []
    
    @Relationship(deleteRule: .cascade)
        var userClothes: [ClothesModel] = []
    
    init(name: String, photoData: Data? = nil, favorites: [String] = [], analysis: [AnalysisModel] = [], userClothes: [ClothesModel] = []) {
        self.name = name
        self.photoData = photoData
        self.favorites = favorites
        self.analysis = analysis
        self.userClothes = userClothes
    }
}

extension UserModel {

    // Análises ordanadas da mais recente para a mais antiga.
    var completedAnalyses: [AnalysisModel] {
        analysis
            .filter { !$0.userSilhouette.isEmpty }
            .sorted { $0.date > $1.date }
    }

    // Análise em andamento: já tem a paleta (colorimetria), mas ainda falta o biotipo
    var pendingAnalysis: AnalysisModel? {
        analysis
            .filter { $0.userSilhouette.isEmpty }
            .sorted { $0.date > $1.date }
            .first
    }

    // Análise usada no app (Home, Minha área, sugestões, roupas):
    var currentAnalysis: AnalysisModel? {
        if let id = selectedAnalysisID,
           let chosen = completedAnalyses.first(where: { $0.id == id }) {
            return chosen
        }
        return completedAnalyses.first
    }

    // Paleta da análise atual
    var currentPalette: PaleteSeason {
        guard let name = currentAnalysis?.userPalette.first,
              let season = PaleteSeason.allCases.first(where: { $0.rawValue == name }) else {
            return .autumnDeep
        }
        return season
    }

    // Biotipo da análise atual
    var currentBodyShape: BodyShape {
        guard let name = currentAnalysis?.userSilhouette,
              let shape = BodyShape.allCases.first(where: { $0.rawValue == name }) else {
            return .hourglass
        }
        return shape
    }

    // Busca a usuária do app. Se ainda não existir, cria uma (o app tem uma usuária só)
    static func current(in context: ModelContext) -> UserModel {
        if let user = try? context.fetch(FetchDescriptor<UserModel>()).first {
            return user
        }
        let user = UserModel(name: "")
        context.insert(user)
        return user
    }
}
