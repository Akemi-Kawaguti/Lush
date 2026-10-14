//
//  RequestAPI.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 13/10/26.
//

import Foundation

enum RequestAPI {
    static let lushAPI = URL(string: "https://cvfamnyvnvknnjyglqjz.supabase.co/functions/v1")!
    static func fetchLooks(palette: PaleteSeason, style: LookStyle?, limit: Int = 20) async throws -> [LookPhoto] {
        var components = URLComponents(url: lushAPI.appending(path: "looks"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "palette", value: String(describing: palette)),
            URLQueryItem(name: "style", value: style?.apiKey ?? "all"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]

        // Faz o pedido (sem chave nenhuma: a chave do Pexels fica só no servidor)
        let (data, response) = try await URLSession.shared.data(from: components.url!)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(LooksResponse.self, from: data).photos
    }
}
