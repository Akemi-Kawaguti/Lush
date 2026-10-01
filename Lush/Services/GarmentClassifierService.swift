//
//  GarmentClassifierService.swift
//  Lush
//
//  Classifica o corte de uma calça a partir de uma foto usando o modelo
//  CalcaClassifier.mlmodel (Resources/MLModels) via Vision.
//
//  O projeto usa "Default Actor Isolation = MainActor", então tudo é MainActor
//  por padrão. Os tipos abaixo são marcados `nonisolated` para que o Vision
//  possa rodar fora da main thread sem travar a interface.
//

import CoreML
import UIKit
import Vision

/// Um palpite do modelo já convertido para o enum do app.
nonisolated struct GarmentCutPrediction: Sendable {
    let cut: GarmentCutBottom
    let confidence: Float   // 0...1
}

/// Resultado pronto para a interface decidir o que mostrar.
nonisolated enum GarmentClassificationResult: Sendable {
    /// Modelo confiante: mostrar só este corte.
    case confident(GarmentCutPrediction)
    /// Modelo em dúvida: mostrar as duas opções ("Parece Flare ou Jogger").
    case uncertain(first: GarmentCutPrediction, second: GarmentCutPrediction)
    /// Nada reconhecido (imagem inválida ou rótulo sem correspondência).
    case none
}

nonisolated enum GarmentClassifierError: Error {
    case invalidImage
}

/// `@unchecked Sendable`: a única propriedade é um `let` (VNCoreMLModel) que só é lido,
/// então é seguro usar a mesma instância em outra thread.
nonisolated final class GarmentClassifierService: @unchecked Sendable {

    /// Abaixo deste valor a interface mostra as duas primeiras opções.
    static let confidenceThreshold: Float = 0.70

    private let model: VNCoreMLModel

    /// Criado na main thread (dentro da View/ViewModel), porque a classe gerada
    /// pelo Xcode para o .mlmodel também fica isolada na MainActor.
    @MainActor
    init() throws {
        let config = MLModelConfiguration()
        #if targetEnvironment(simulator)
        // O simulador não tem Neural Engine/GPU para modelos do Create ML
        // ("Could not create inference context"). No iPhone real usa o padrão (.all).
        config.computeUnits = .cpuOnly
        #endif
        let mlModel = try LastCalcaClassifier(configuration: config).model
        model = try VNCoreMLModel(for: mlModel)
    }

    // MARK: - Rótulos do Create ML → enum do app

    /// Os rótulos são os nomes das pastas usadas no treino (Calca/Reta, Calca/Skinny...).
    /// Se renomearem ou adicionarem pastas e treinarem de novo, atualizem aqui.
    /// As chaves ficam em minúsculas: a busca ignora maiúsculas/minúsculas
    /// ("Wide_leg", "Wide_Leg" e "wide_leg" funcionam igual).
    private static let labelToCut: [String: GarmentCutBottom] = [
        "reta": .pantsStraight,
        "skinny": .pantsSkinny,
        "flare": .pantsFlare,
        "wide_leg": .pantsWideLeg,
        "jogger": .pantsJogger
    ]

    // MARK: - API

    /// Faz a classificação fora da main thread. Pode ser chamada direto de uma View/ViewModel:
    /// `let resultado = try await service.classify(imagem)`
    func classify(_ image: UIImage) async throws -> GarmentClassificationResult {
        let model = self.model
        let predictions = try await Task.detached(priority: .userInitiated) {
            try Self.runVision(model: model, image: image)
        }.value
        return Self.interpret(predictions)
    }

    // MARK: - Internos

    private static func runVision(model: VNCoreMLModel, image: UIImage) throws -> [GarmentCutPrediction] {
        guard let cgImage = image.cgImage else { throw GarmentClassifierError.invalidImage }

        let request = VNCoreMLRequest(model: model)
        //request.imageCropAndScaleOption = .centerCrop
        request.imageCropAndScaleOption = .scaleFit

        #if targetEnvironment(simulator)
        // Força o Vision a rodar na CPU no simulador (mesmo motivo do init).
        if let cpu = MLComputeDevice.allComputeDevices.first(where: {
            if case .cpu = $0 { return true } else { return false }
        }) {
            request.setComputeDevice(cpu, for: .main)
        }
        #endif

        // Sem isso, fotos tiradas com o iPhone em pé chegam "deitadas" para o modelo.
        let handler = VNImageRequestHandler(
            cgImage: cgImage,
            orientation: CGImagePropertyOrientation(image.imageOrientation)
        )
        try handler.perform([request])

        let observations = request.results as? [VNClassificationObservation] ?? []
        // Já vem ordenado da maior para a menor confiança.
        return observations.compactMap { observation in
            guard let cut = labelToCut[observation.identifier.lowercased()] else {
                // Só avisa no console (não derruba o app): esse rótulo é ignorado.
                print("⚠️ Rótulo do modelo sem correspondência no enum: \(observation.identifier)")
                return nil
            }
            return GarmentCutPrediction(cut: cut, confidence: observation.confidence)
        }
    }

    private static func interpret(_ predictions: [GarmentCutPrediction]) -> GarmentClassificationResult {
        guard let first = predictions.first else { return .none }

        if first.confidence >= confidenceThreshold || predictions.count < 2 {
            return .confident(first)
        }
        return .uncertain(first: first, second: predictions[1])
    }
}

// MARK: - Orientação UIKit → Vision

extension CGImagePropertyOrientation {
    nonisolated init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .up: self = .up
        case .down: self = .down
        case .left: self = .left
        case .right: self = .right
        case .upMirrored: self = .upMirrored
        case .downMirrored: self = .downMirrored
        case .leftMirrored: self = .leftMirrored
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}
