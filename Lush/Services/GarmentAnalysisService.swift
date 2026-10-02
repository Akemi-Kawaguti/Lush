//
//  GarmentAnalysisService.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 02/10/26.
//

//
//  Analisa a foto de uma peça usando o classificador da categoria escolhida
//  (Camiseta → CamisetaClassifier, Calça → LastCalcaClassifier, ...).
//  Devolve a modelagem com os rótulos "crus" do modelo (nomes das pastas do dataset).
//
//  Esta etapa NÃO faz análise de cor/paleta.
//  A conversão dos rótulos para os enums do app (GarmentCutTop, GarmentCutBottom...)
//  fica para a integração, depois que os modelos forem validados.
//

import CoreML
import UIKit
import Vision

// MARK: - Categoria → modelo

extension GarmentCategory {
    /// Nome do arquivo .mlmodel (sem a extensão) que analisa esta categoria.
    /// `nil` = ainda não existe classificador para ela.
    /// Se renomearem algum modelo em Resources/MLModels, atualizem aqui.
    var classifierModelName: String? {
        switch self {
        // Parte de cima
        case .tShirt: "CamisetaClassifier"
        case .tankTop: "RegataClassifier"
        case .croppedTop: "CroppedClassifier"
        case .blouse: "BlusaClassifier"
        case .shirt: "CamisaClassifier"
        case .bodysuit: "BodyClassifier"
        case .sweater: "SueterClassifier"
        // Parte de baixo
        case .pants: "LastCalcaClassifier"
        case .shorts: "ShortClassifier"
        case .skirt: "SaiaClassifier"
        case .leggings: "LeggingClassifier"
        case .bermudaShorts: "BermudaClassifier"
        // Peça única
        case .dress: "VestidoClassifier"
        case .jumpsuit: "MacacaoClassifier"
        // Ainda sem classificador
        default: nil
        }
    }
}

// MARK: - Resultado

nonisolated struct LabelPrediction: Sendable, Identifiable, Hashable {
    let label: String
    let confidence: Float   // 0...1
    var id: String { label }
}

nonisolated struct GarmentAnalysis: Sendable {
    let modelName: String
    /// Os 3 rótulos mais prováveis, do maior para o menor.
    let predictions: [LabelPrediction]
    /// Todos os rótulos que o modelo conhece (para marcar a resposta certa no teste).
    let allLabels: [String]

    var best: LabelPrediction? { predictions.first }
    var second: LabelPrediction? { predictions.dropFirst().first }

    /// true = mostrar só a melhor opção; false = mostrar "Parece X ou Y".
    var isConfident: Bool {
        (best?.confidence ?? 0) >= GarmentAnalysisService.confidenceThreshold
    }
}

nonisolated enum GarmentAnalysisError: LocalizedError {
    case invalidImage
    case modelNotFound(String)

    var errorDescription: String? {
        switch self {
        case .invalidImage:
            "Não foi possível ler a imagem."
        case .modelNotFound(let name):
            "Modelo \(name) não encontrado no app. Confira o nome do arquivo em Resources/MLModels."
        }
    }
}

// MARK: - Serviço

nonisolated enum GarmentAnalysisService {

    /// Abaixo deste valor a interface mostra as duas primeiras opções.
    static let confidenceThreshold: Float = 0.70

    /// Roda o classificador `modelName` na foto. Chame fora da main thread.
    static func analyze(image: UIImage, modelName: String) throws -> GarmentAnalysis {
        guard let cgImage = image.cgImage else { throw GarmentAnalysisError.invalidImage }
        guard let url = modelURL(named: modelName) else {
            throw GarmentAnalysisError.modelNotFound(modelName)
        }

        let config = MLModelConfiguration()
        #if targetEnvironment(simulator)
        config.computeUnits = .cpuOnly
        #endif

        let mlModel = try MLModel(contentsOf: url, configuration: config)
        let request = VNCoreMLRequest(model: try VNCoreMLModel(for: mlModel))
        request.imageCropAndScaleOption = .scaleFit   // usa a foto inteira, sem cortar

        // CGImagePropertyOrientation(_:) está definido em GarmentClassifierService.swift
        let handler = VNImageRequestHandler(
            cgImage: cgImage,
            orientation: CGImagePropertyOrientation(image.imageOrientation)
        )
        try handler.perform([request])

        let observations = request.results as? [VNClassificationObservation] ?? []
        let labels = (mlModel.modelDescription.classLabels as? [String])
            ?? observations.map(\.identifier)

        return GarmentAnalysis(
            modelName: modelName,
            predictions: observations.prefix(3).map {
                LabelPrediction(label: $0.identifier, confidence: $0.confidence)
            },
            allLabels: labels.sorted()
        )
    }

    /// Procura o modelo compilado (.mlmodelc) dentro do app.
    private static func modelURL(named name: String) -> URL? {
        if let url = Bundle.main.url(forResource: name, withExtension: "mlmodelc") {
            return url
        }
        guard let enumerator = FileManager.default.enumerator(
            at: Bundle.main.bundleURL,
            includingPropertiesForKeys: nil
        ) else { return nil }

        while let url = enumerator.nextObject() as? URL {
            if url.pathExtension == "mlmodelc",
               url.deletingPathExtension().lastPathComponent == name {
                return url
            }
        }
        return nil
    }
}
