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
}

struct Look: Identifiable {
    let id = UUID()
    let imageName: String          // nome da imagem no Assets
    let photographer: String
    let style: LookStyle
    var pexelsURL: URL? = nil
    var reason = "Cores e modelagens alinhadas ao seu perfil"

    var credit: String {
        "Foto de \(photographer) no Pexels"
    }
}

extension Look {
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
