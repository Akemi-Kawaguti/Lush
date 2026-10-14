//
//  RequestAPIRest.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 22/09/26.
//

import Foundation

// Resposta da API Lush (/looks): mesmo formato do Pexels, de onde as fotos vêm
struct LooksResponse: Decodable {
    let photos: [LookPhoto]
}

// Uma foto sugerida (os links e o fotógrafo são do Pexels)
struct LookPhoto: Decodable, Identifiable {
    let id: Int
    let url: URL              // página da foto no Pexels (para o crédito)
    let photographer: String
    let alt: String?          // descrição da foto (acessibilidade)
    let src: Source

    struct Source: Decodable {
        let portrait: URL     // foto em pé, boa para os cards
        let large: URL        // foto maior, para a tela de detalhe
    }
}
