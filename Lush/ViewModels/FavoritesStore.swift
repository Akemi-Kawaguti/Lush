//
//  FavoritesStore.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 06/10/26.
//

//  Looks favoritados, compartilhados entre as telas (Home, Sugestões e Favoritos).
//  Ficam salvos no iPhone (UserDefaults), então continuam lá ao fechar o app.

import Foundation
import Observation

@Observable
final class FavoritesStore {

    var looks: [Look] = []

    // Nome da "gaveta" onde a lista fica salva no UserDefaults
    private let storageKey = "favoriteLooks"

    // Ao criar o store (ao abrir o app), carrega os favoritos salvos
    init() {
        load()
    }

    func contains(_ look: Look) -> Bool {
        looks.contains { isSame($0, look) }
    }

    // Favorita ou desfavorita, e salva a lista
    func toggle(_ look: Look) {
        if let index = looks.firstIndex(where: { isSame($0, look) }) {
            looks.remove(at: index)
        } else {
            looks.insert(look, at: 0)   // o mais recente aparece primeiro
        }
        save()
    }

    // Descobre se dois looks são a mesma foto:
    // 1. mesmo id (o mesmo look na tela)
    // 2. mesmo photoID (a mesma foto do Pexels, mesmo que tenha vindo em outra busca)
    // 3. mesmo endereço da foto (reserva, para looks sem photoID)
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

    // Lê o JSON salvo e reconstrói a lista
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let saved = try? JSONDecoder().decode([Look].self, from: data) else {
            return   // primeira vez ou nada salvo: começa com a lista vazia
        }
        looks = saved
    }
}
