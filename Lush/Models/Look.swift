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
    case party = "Festa"
    
    // Chave do estilo na API Lush (/looks?style=...)
    var apiKey: String {
        switch self {
        case .casual: "casual"
        case .work: "work"
        case .gym: "gym"
        case .party: "party"
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

    // Foto em pé com o dobro de resolução (dpr=2), para a sheet em tela cheia
    var highResImageURL: URL? {
        guard let imageURL,
              var components = URLComponents(url: imageURL, resolvingAgainstBaseURL: false) else {
            return imageURL
        }
        var items = (components.queryItems ?? []).filter { $0.name != "dpr" }
        items.append(URLQueryItem(name: "dpr", value: "2"))
        components.queryItems = items
        return components.url ?? imageURL
    }
    
}

extension Look {
    // Cria um look a partir de uma foto do Pexels
    init(photo: LookPhoto, style: LookStyle) {
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
        Look(imageName: "look3", photographer: "Nome do Fotógrafo", style: .work),
        Look(imageName: "look4", photographer: "Nome do Fotógrafo", style: .party),
        Look(imageName: "look5", photographer: "Nome do Fotógrafo", style: .casual),
        Look(imageName: "look6", photographer: "Nome do Fotógrafo", style: .gym)
    ]
}
