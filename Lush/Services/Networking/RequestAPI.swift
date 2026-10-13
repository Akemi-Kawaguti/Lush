//
//  RequestAPI.swift
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

enum RequestAPI {
    // Endereço da API Lush (Supabase)
    static let lushAPI = URL(string: "https://cvfamnyvnvknnjyglqjz.supabase.co/functions/v1")!

    // Busca sugestões de looks na API Lush.
    // Ex.: fetchLooks(palette: .autumnDeep, style: .work)
    static func fetchLooks(palette: PaleteSeason, style: LookStyle?, limit: Int = 20) async throws -> [LookPhoto] {
        // 1. Monta a URL: .../looks?palette=autumnDeep&style=work&limit=20
        var components = URLComponents(url: lushAPI.appending(path: "looks"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "palette", value: String(describing: palette)),
            URLQueryItem(name: "style", value: style?.apiKey ?? "all"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]

        // 2. Faz o pedido (sem chave nenhuma: a chave do Pexels fica só no servidor)
        let (data, response) = try await URLSession.shared.data(from: components.url!)

        // 3. Só aceita resposta de sucesso
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        // 4. Converte o JSON nas structs que já existem
        return try JSONDecoder().decode(LooksResponse.self, from: data).photos
    }
}
