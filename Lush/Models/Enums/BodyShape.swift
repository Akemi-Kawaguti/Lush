//
//  BodyShape.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 29/09/26.
//

import Foundation

enum BodyShape: String, Codable, CaseIterable {
    case hourglass = "Ampulheta"
    case triangle = "Triângulo"
    case invertedTriangle = "Triângulo invertido"
    case rectangle = "Retângulo"
    case oval = "Oval"
}

struct BodyShapeFeature {
    let title: String
    let description: String
    let imageName: String
}

extension BodyShape {
        
        // Nome da imagem ilustrativa principal do biotipo
        var imageName: String {
            switch self {
            case .hourglass: return "tipo-ampulheta"
            case .triangle: return "tipo-triangulo"
            case .invertedTriangle: return "tipo-trianguloinvertido"
            case .oval: return "tipo-oval"
            case .rectangle: return "tipo-retangulo"
            }
        }
    
    var shapeCardDescription: String {
        switch self {
        case .hourglass:
            return "Seus ombros e quadris estão perfeitamente alinhados, com uma cintura bem marcada e evidente."
        case .triangle:
            return "Seu quadril é mais largo que os ombros, criando uma silhueta suave e delicada na parte superior."
        case .invertedTriangle:
            return "Seus ombros são mais largos que o quadril, destacando a parte superior do corpo."
        case .oval:
            return "A região da cintura possui volume maior ou semelhante aos ombros e quadris, com formas arredondadas e fluidas."
        case .rectangle:
            return "Ombros, cintura e quadris possuem larguras muito parecidas, com curvas discretas."
        }
    }
    
    // Lista de características detalhadas para o carrossel (ombro, cintura, quadril)
    var features: [BodyShapeFeature] {
        switch self {
        case .hourglass:
            return [
                BodyShapeFeature(title: "Ombros", description: "Alinhados com o quadril.", imageName: "ombros"),
                BodyShapeFeature(title: "Cintura", description: "Bem definida e marcada.", imageName: "cintura"),
                BodyShapeFeature(title: "Quadril", description: "Proporcional aos ombros.", imageName: "quadril")
            ]
        case .triangle:
            return [
                BodyShapeFeature(title: "Ombros", description: "Mais estreitos que o quadril.", imageName: "ombros"),
                BodyShapeFeature(title: "Cintura", description: "Delicada e perceptível.", imageName: "cintura"),
                BodyShapeFeature(title: "Quadril", description: "Mais largo e evidente.", imageName: "quadril")
            ]
        case .invertedTriangle:
            return [
                BodyShapeFeature(title: "Ombros", description: "Mais largos e marcantes.", imageName: "ombros"),
                BodyShapeFeature(title: "Cintura", description: "Reta ou suavemente marcada.", imageName: "cintura"),
                BodyShapeFeature(title: "Quadril", description: "Mais estreito que os ombros.", imageName: "quadril")
            ]
        case .oval:
            return [
                BodyShapeFeature(title: "Ombros", description: "Proporcionais e fluidos.", imageName: "ombros"),
                BodyShapeFeature(title: "Cintura", description: "Volume maior e arredondado.", imageName: "cintura"),
                BodyShapeFeature(title: "Quadril", description: "Suave e alinhado ao tronco.", imageName: "quadril")
            ]
        case .rectangle:
            return [
                BodyShapeFeature(title: "Ombros", description: "Retos e alinhados.", imageName: "ombros"),
                BodyShapeFeature(title: "Cintura", description: "Pouco marcada ou reta.", imageName: "cintura"),
                BodyShapeFeature(title: "Quadril", description: "Alinhado com os ombros.", imageName: "quadril")
            ]
        }
    }
}
