//
//  Look.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 04/10/26.
//

import Foundation

enum LookStyle: String, CaseIterable {
    case casual = "Casual"
    case work = "Trabalho"
    case gym = "Academia"
    case summer = "Verão"
    case party = "Festa"

    // Termo de busca no Pexels (em inglês, que traz mais resultados)
    var searchQuery: String {
        switch self {
        case .casual: "casual women outfit"
        case .work: "women office outfit"
        case .gym: "women gym outfit"
        case .summer: "summer women outfit"
        case .party: "women party dress"
        }
    }
}

struct Look: Identifiable {
    let id = UUID()
    var imageName: String = ""     // nome da imagem no Assets (looks de exemplo)
    let photographer: String
    let style: LookStyle
    var pexelsURL: URL? = nil      // página da foto no Pexels
    var reason = "Cores e modelagens alinhadas ao seu perfil"
    var imageURL: URL? = nil       // foto do card (vinda do Pexels)
    var largeImageURL: URL? = nil  // foto maior, para a tela de detalhe
    var altText: String? = nil     // descrição da foto, para o VoiceOver

    var credit: String {
        "Foto de \(photographer) no Pexels"
    }
}

extension Look {
    // Cria um look a partir de uma foto do Pexels
    init(photo: PexelsPhoto, style: LookStyle) {
        self.init(
            photographer: photo.photographer,
            style: style,
            pexelsURL: photo.url,
            imageURL: photo.src.portrait,
            largeImageURL: photo.src.large,
            altText: photo.alt
        )
    }

    // Dados de exemplo
    static let samples: [Look] = [
        Look(imageName: "look1", photographer: "Nome do Fotógrafo", style: .casual),
        Look(imageName: "look2", photographer: "Nome do Fotógrafo", style: .summer),
        Look(imageName: "look3", photographer: "Nome do Fotógrafo", style: .work),
        Look(imageName: "look4", photographer: "Nome do Fotógrafo", style: .party),
        Look(imageName: "look5", photographer: "Nome do Fotógrafo", style: .casual),
        Look(imageName: "look6", photographer: "Nome do Fotógrafo", style: .gym)
    ]
}
