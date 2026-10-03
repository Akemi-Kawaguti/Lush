//
//  BodyShape.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 29/09/26.
//

enum BodyShape: String, Codable, CaseIterable {
    case hourglass = "Ampulheta"
    case triangle = "Triângulo"
    case invertedTriangle = "Triângulo invertido"
    case rectangle = "Retângulo"
    case oval = "Oval"
}

extension BodyShape {
    // Nome da imagem no Assets (pasta BodyShapes)
    var imageName: String {
        switch self {
        case .hourglass: return "ampulheta"
        case .triangle: return "triangulo"
        case .invertedTriangle: return "trianguloinvertido"
        case .rectangle: return "retangulo"
        case .oval: return "oval"
        }
    }
}
