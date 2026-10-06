//
//  LookImage.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 04/10/26.
//

import SwiftUI

struct LookImage: View {

    var imageName: String = ""
    var url: URL? = nil

    var body: some View {
        if let url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    placeholder(systemImage: "photo")
                default:
                    placeholder(systemImage: nil)   // carregando
                }
            }
        } else if let uiImage = UIImage(named: imageName) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            placeholder(systemImage: "photo")
        }
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
