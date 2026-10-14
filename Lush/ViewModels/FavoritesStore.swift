//
//  FavoritesStore.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 06/10/26.
//

import Foundation
import Observation

@Observable
final class FavoritesStore {

    var looks: [Look] = []

    private let storageKey = "favoriteLooks"
    init() { load() }

    func contains(_ look: Look) -> Bool {
        looks.contains { isSame($0, look) }
    }

    func toggle(_ look: Look) {
        if let index = looks.firstIndex(where: { isSame($0, look) }) {
            looks.remove(at: index)
        } else {
            looks.insert(look, at: 0)   // o mais recente aparece primeiro
        }
        save()
    }

    private func isSame(_ first: Look, _ second: Look) -> Bool {
        if first.id == second.id { return true }
        if let firstPhoto = first.photoID, let secondPhoto = second.photoID {
            return firstPhoto == secondPhoto
        }
        guard let firstURL = first.imageURL else { return false }
        return firstURL == second.imageURL
    }

    // MARK: - Salvar no iPhone
    // Converte a lista em JSON e guarda no UserDefaults
    private func save() {
        guard let data = try? JSONEncoder().encode(looks) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let saved = try? JSONDecoder().decode([Look].self, from: data) else {
            return   // primeira vez ou nada salvo: começa com a lista vazia
        }
        looks = saved
    }
}
