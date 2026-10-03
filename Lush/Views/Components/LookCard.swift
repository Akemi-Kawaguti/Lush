//
//  LookCard.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//

//  Card de sugestão de look: foto, botão de favoritar e crédito da foto.

import SwiftUI

struct LookCard: View {

    var imageName: String? = nil   // nome da imagem no Assets
    let credit: String
    let isFavorite: Bool
    let onFavorite: () -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {

            // Foto
            if let imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 170, height: 220, alignment: .top)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 170, height: 180)
                    .overlay {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                    }
            }

            // Botão de favoritar
            Button(action: onFavorite) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(.black.opacity(0.7)))
                    .shadow(color: .black.opacity(0.25), radius: 4, y: 4)
            }
            .padding(10)
            .accessibilityLabel(isFavorite ? "Remover dos favoritos" : "Favoritar")
        }
        // Crédito da foto
        .overlay(alignment: .bottom) {
            Text(credit)
                .font(.caption)
                .foregroundStyle(.white)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.black.opacity(0.7))
                .overlay(alignment: .bottom) {
                    Text(credit)
                        .font(.caption)
                        .foregroundStyle(.white)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .glassEffect(.regular.tint(.black.opacity(0.5)), in: Rectangle())
                }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    LookCard(credit: "Photo by Nome on Pexels", isFavorite: false, onFavorite: {})
}
