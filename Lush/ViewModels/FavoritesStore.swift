//
//  FavoritesStore.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 06/10/26.
//

//  Looks favoritados, compartilhados entre as telas (Sugestões e Favoritos).
//  Por enquanto ficam só na memória: somem ao fechar o app.
//  TODO: salvar com SwiftData.

import Foundation
import Observation

@Observable
final class FavoritesStore {

    var looks: [Look] = []

    func contains(_ look: Look) -> Bool {
        looks.contains { isSame($0, look) }
    }

    // Favorita ou desfavorita
    func toggle(_ look: Look) {
        if let index = looks.firstIndex(where: { isSame($0, look) }) {
            looks.remove(at: index)
        } else {
            looks.insert(look, at: 0)   // o mais recente aparece primeiro
        }
    }

    // A mesma foto do Pexels pode voltar com outro id numa nova busca:
    // por isso também compara pelo endereço da foto
    private func isSame(_ first: Look, _ second: Look) -> Bool {
        if first.id == second.id { return true }
        guard let firstURL = first.imageURL else { return false }
        return firstURL == second.imageURL
    }
}
