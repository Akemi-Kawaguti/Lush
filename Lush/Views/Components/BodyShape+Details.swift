//
//  BodyShape+Details.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//

extension BodyShape {

    var iconName: String {
        imageName + "Icon"
    }

    // Ícone SF Symbol (não usado mais na tela de detalhes)
    var symbolName: String {
        switch self {
        case .hourglass: return "hourglass"
        case .triangle: return "arrowtriangle.up.fill"
        case .invertedTriangle: return "arrowtriangle.down.fill"
        case .rectangle: return "rectangle.portrait.fill"
        case .oval: return "oval.portrait.fill"
        }
    }

    // Texto explicativo — REVISAR
    var description: String {
        switch self {
        case .hourglass:
            return "O biotipo ampulheta é caracterizado pelo equilíbrio entre ombros e quadris, com a cintura bem definida, criando uma silhueta proporcional e harmoniosa."
        case .triangle:
            return "O biotipo triângulo tem o quadril mais largo que os ombros, com a parte de baixo do corpo mais marcada que a de cima."
        case .invertedTriangle:
            return "O biotipo triângulo invertido tem os ombros mais largos que o quadril, com a parte de cima do corpo em destaque."
        case .rectangle:
            return "O biotipo retângulo tem ombros, cintura e quadril com medidas parecidas, formando uma silhueta mais reta."
        case .oval:
            return "O biotipo oval tem a região do meio do corpo mais arredondada, com ombros e quadril mais estreitos que a cintura."
        }
    }
}
