//
//  GarmentClassifier.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 13/10/26.
//


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
