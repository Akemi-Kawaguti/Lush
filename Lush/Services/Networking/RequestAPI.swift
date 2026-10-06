//
//  RequestAPI.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 22/09/26.
//

import Foundation

// Lê a chave do Info.plist (que vem do Secrets.xcconfig)
enum APIKeys {
    static var pexels: String {
        Bundle.main.object(forInfoDictionaryKey: "PEXELS_API_KEY") as? String ?? ""
    }
}

// Resposta da busca do Pexels
struct PexelsResponse: Decodable {
    let photos: [PexelsPhoto]
}

struct PexelsPhoto: Decodable, Identifiable {
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

    // Busca fotos no Pexels. Ex.: searchPhotos(query: "casual outfit")
    static func searchPhotos(query: String, page: Int = 1) async throws -> [PexelsPhoto] {
        var components = URLComponents(string: "https://api.pexels.com/v1/search")!
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "orientation", value: "portrait"),
            URLQueryItem(name: "per_page", value: "20"),
            URLQueryItem(name: "page", value: "\(page)")
        ]

        var request = URLRequest(url: components.url!)
        request.setValue(APIKeys.pexels, forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(PexelsResponse.self, from: data).photos
    }
}
