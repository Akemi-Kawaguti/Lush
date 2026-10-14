//
//  PhotoBodyError.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 14/10/26.
//

import Foundation

nonisolated enum PhotoBodyError: LocalizedError {
    case noPerson
    case bodyNotVisible
    case notFacingFront
    case armsTouchingBody
    case segmentationFailed

    var errorDescription: String? {
        switch self {
        case .noPerson:
            "Não encontramos uma pessoa na foto. Tente uma foto de corpo inteiro, com boa iluminação."
        case .bodyNotVisible:
            "Não conseguimos ver seus ombros e quadril. Tire a foto de corpo inteiro, com a câmera um pouco mais longe."
        case .notFacingFront:
            "Parece que a foto está de lado. Fique de frente para a câmera."
        case .armsTouchingBody:
            "Seus braços estão encostados no corpo. Afaste um pouco os braços para medirmos sua cintura e quadril."
        case .segmentationFailed:
            "Não conseguimos analisar a foto. Tente outra foto, com fundo liso e boa iluminação."
        }
    }
}
