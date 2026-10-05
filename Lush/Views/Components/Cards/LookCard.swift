//
//  LookCard.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//

//  Card de sugestão de look: foto, botão de favoritar e crédito da foto.

import SwiftUI

struct LookCard: View {

    let imageName: String          // nome da imagem no Assets
    let credit: String
    let isFavorite: Bool
    var height: CGFloat = 220
    let onFavorite: () -> Void

    var body: some View {
        Color.clear
            .frame(maxWidth: .infinity)
            .frame(height: height)
            // Foto
            .overlay(alignment: .top) {
                LookImage(imageName: imageName)
            }
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color("borderLines"), lineWidth: 0.5))
            // Botão de favoritar
            .overlay(alignment: .topLeading) {
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
    LookCard(imageName: "look1", credit: "Foto de Nome no Pexels", isFavorite: false, onFavorite: {})
        .frame(width: 170)
}
