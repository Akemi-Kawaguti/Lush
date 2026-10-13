//
//  LookImage.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 04/10/26.
//

//  Foto de um look: do Assets (exemplos) ou da internet (Pexels).
//  Se a foto da internet falhar, tenta de novo e depois tenta o endereço reserva.

import SwiftUI

struct LookImage: View {

    var imageName: String = ""
    var url: URL? = nil
    var fallbackURL: URL? = nil      // outra versão da mesma foto, se a primeira falhar

    @State private var image: UIImage?
    @State private var failed = false
    @State private var loadedURL: URL?

    var body: some View {
        Color.clear
            .overlay {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else if url == nil, let uiImage = UIImage(named: imageName) {
                    // Looks de exemplo (Assets)
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    // Sem foto (ícone) ou ainda carregando
                    placeholder(systemImage: failed || url == nil ? "photo" : nil)
                }
            }
            // Carrega quando aparece na tela e sempre que o endereço mudar
            .task(id: url) {
                await load()
            }
    }

    func load() async {
        guard let url else { return }
        if url == loadedURL, image != nil { return }   // já carregada: não baixa de novo
        image = nil
        failed = false

        // Endereço principal e, se houver, o reserva
        let candidates = [url, fallbackURL].compactMap { $0 }

        for candidate in candidates {
            for _ in 1...2 {                       // até 2 tentativas por endereço
                if Task.isCancelled { return }     // saiu da tela: para de tentar
                if let (data, _) = try? await URLSession.shared.data(from: candidate),
                   let loaded = await UIImage(data: data)?.byPreparingForDisplay() {
                    image = loaded
                    loadedURL = url
                    return
                }
            }
        }

        if !Task.isCancelled { failed = true }
    }

    // Fundo cinza: com ícone (sem foto) ou com carregamento
    func placeholder(systemImage: String?) -> some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .overlay {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                } else {
                    ProgressView()
                }
            }
    }
}

#Preview {
    LookImage(imageName: "look1")
        .frame(width: 170, height: 220)
        .clipped()
}
