//
//  AddClothingViewModel.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 08/10/26.
//
import Foundation
import UIKit
import Combine
import SwiftData

// Embrulho para levar a foto para a análise fora da thread principal
nonisolated struct SendableUIImage: @unchecked Sendable {
    let image: UIImage
}

@MainActor
final class AddClothingViewModel: ObservableObject {

    @Published var isAnalyzing = false
    @Published var analysis: GarmentAnalysis?
    @Published var errorMessage: String?
    @Published var processedImage: UIImage?

    private let minimumLoadingTime: Duration = .seconds(1.5)

    func analyzeClothing(image: UIImage, category: GarmentCategory) {
        guard let modelName = category.classifierModelName else {
            errorMessage = "Essa categoria ainda não possui um modelo de análise."
            return
        }
        guard !isAnalyzing else { return }

        isAnalyzing = true
        errorMessage = nil

        let input = SendableUIImage(image: image)
        let minimumLoadingTime = minimumLoadingTime

        Task {
            let start = ContinuousClock.now
            do {
                let (withoutBackground, result) = try await Task.detached(priority: .userInitiated) {
                    let processed = try GarmentBackgroundRemovalService.removeBackground(from: input.image)
                    let result = try GarmentAnalysisService.analyze(image: processed, modelName: modelName)
                    return (SendableUIImage(image: processed), result)
                }.value

                let elapsed = ContinuousClock.now - start
                if elapsed < minimumLoadingTime {
                    try? await Task.sleep(for: minimumLoadingTime - elapsed)
                }
                processedImage = withoutBackground.image
                analysis = result
            } catch {
                errorMessage = error.localizedDescription
            }
            isAnalyzing = false
        }
    }
    
    private func predominantColorHexes(from image: UIImage) -> [String] {
        let colors = GarmentColorAnalysisService.predominantColors(from: image)
        return colors.map { $0.hexString }
    }
    
    func saveAnalyzedClothing( name: String, image: UIImage, category: GarmentCategory, in context: ModelContext ) -> ClothesModel? {
        guard analysis?.best != nil else { return nil }
        let photo = processedImage ?? image
        return ClothingService.addClothing(
            name: name,
            image: photo,
            category: category,
            position: category.position,
            cutTop: cutTop(for: category),
            cutBottom: cutBottom(for: category),
            cutOnePiece: cutOnePiece(for: category),
            predominantColors: predominantColorHexes(from: photo),
            in: context
        )
    }

    func updateAnalyzedClothing( _ clothing: ClothesModel, name: String, image: UIImage, category: GarmentCategory, in context: ModelContext ) -> Bool {
        guard analysis?.best != nil else { return false }
        let photo = processedImage ?? image
        ClothingService.updateClothing(
            clothing,
            name: name,
            image: photo,
            category: category,
            position: category.position,
            cutTop: cutTop(for: category),
            cutBottom: cutBottom(for: category),
            cutOnePiece: cutOnePiece(for: category),
            predominantColors: predominantColorHexes(from: photo),
            in: context
        )
        return true
    }


    private func cutTop(for category: GarmentCategory) -> GarmentCutTop? {
        guard let label = analysis?.best?.label else { return nil }

        switch category {

        case .tShirt:
            switch label {
            case "Justa":
                return .tShirtFitted
            case "Oversized":
                return .tShirtOversized
            case "Tradicional":
                return .tShirtTraditional
            default:
                return nil
            }

        case .tankTop:
            switch label {
            case "Cropped":
                return .tankTopCropped
            case "Justa":
                return .tankTopFitted
            case "Tradicional":
                return .tankTopTraditional
            default:
                return nil
            }

        case .croppedTop:
            switch label {
            case "Justo":
                return .croppedFitted
            case "Oversized":
                return .croppedOversized
            case "Tradicional":
                return .croppedTraditional
            default:
                return nil
            }

        case .blouse:
            switch label {
            case "Fluida":
                return .blouseFlowy
            case "Justa":
                return .blouseFitted
            case "Tradicional":
                return .blouseTraditional
            default:
                return nil
            }

        case .shirt:
            switch label {
            case "Oversized":
                return .shirtOversized
            case "Slim":
                return .shirtSlim
            case "Tradicional":
                return .shirtTraditional
            default:
                return nil
            }

        case .bodysuit:
            switch label {
            case "Cavado":
                return .bodysuitHighCut
            case "Tradicional":
                return .bodysuitTraditional
            case "Transpassado":
                return .bodysuitWrap
            default:
                return nil
            }

        case .sweater:
            switch label {
            case "Cropped":
                return .sweaterCropped
            case "Oversized":
                return .sweaterOversized
            case "Tradicional":
                return .sweaterTraditional
            default:
                return nil
            }

        default:
            return nil
        }
    }


    private func cutBottom(for category: GarmentCategory) -> GarmentCutBottom? {

        guard let label = analysis?.best?.label else {
            return nil
        }

        switch category {

        case .pants:
            switch label {
            case "Flare":
                return .pantsFlare
            case "Jogger":
                return .pantsJogger
            case "Reta":
                return .pantsStraight
            case "Skinny":
                return .pantsSkinny
            case "Wide_leg":
                return .pantsWideLeg
            default:
                return nil
            }

        case .shorts:
            switch label {
            case "Alfaiataria":
                return .shortsTailored
            case "Justo":
                return .shortsFitted
            case "Tradicional":
                return .shortsTraditional
            default:
                return nil
            }

        case .leggings:
            switch label {
            case "Flare":
                return .leggingsFlare
            case "Jogger":
                return .leggingsJogger
            case "Tradicional":
                return .leggingsTraditional
            default:
                return nil
            }

        case .bermudaShorts:
            switch label {
            case "Cargo":
                return .bermudaCargo
            case "Slim":
                return .bermudaSlim
            case "Tradicional":
                return .bermudaTraditional
            default:
                return nil
            }

        case .skirt:
            switch label {
            case "Evase":
                return .skirtALine
            case "Gode":
                return .skirtGodet
            case "Lapis":
                return .skirtPencil
            case "Plissada":
                return .skirtPleated
            default:
                return nil
            }

        default:
            return nil
        }
    }


    private func cutOnePiece(for category: GarmentCategory) -> GarmentCutOnePiece? {

        guard let label = analysis?.best?.label else {
            return nil
        }

        switch category {

        case .dress:
            switch label {
            case "Ajustado":
                return .dressBodycon
            case "Envelope":
                return .dressWrap
            case "Evase":
                return .dressALine
            case "Reto":
                return .dressStraight
            default:
                return nil
            }

        case .jumpsuit:
            switch label {
            case "Pantalona":
                return .jumpsuitPantalona
            case "Reto":
                return .jumpsuitStraight
            default:
                return nil
            }

        default:
            return nil
        }
    }
}
