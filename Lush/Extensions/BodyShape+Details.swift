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
    
    // Ilustração da tela de resultado (pasta "bodys" no Assets)
    var resultImageName: String {
        "tipo-" + imageName
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

    // Frase curta do card de biotipo (tela de resultado) — REVISAR
    var summary: String {
        switch self {
        case .hourglass:
            return "Seus ombros e quadril são proporcionais e sua cintura é bem definida."
        case .triangle:
            return "Seu quadril é mais largo que os ombros."
        case .invertedTriangle:
            return "Seus ombros são mais largos que o quadril."
        case .rectangle:
            return "Seus ombros, cintura e quadril têm medidas parecidas."
        case .oval:
            return "O meio do seu corpo tem mais volume que ombros e quadril."
        }
    }

    // Texto do card "O que isso significa?" (tela de resultado)
    var meaning: String {
        switch self {
        case .hourglass:
            return "Você possui um equilíbrio natural entre a parte superior e inferior do corpo, com uma cintura marcada."
        case .triangle:
            return "Seus quadris são proporcionalmente mais largos que os ombros, com uma cintura que pode ser bem definida."
        case .invertedTriangle:
            return "Seus ombros são proporcionalmente mais largos que os quadris, criando uma maior presença na parte superior do corpo."
        case .rectangle:
            return "Seus ombros e quadris apresentam proporções semelhantes, com uma cintura menos marcada."
        case .oval:
            return "A região central do corpo apresenta maior volume proporcional, enquanto a cintura tende a ser menos definida."
        }
    }
}
