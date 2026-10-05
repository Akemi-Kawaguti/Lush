//
//  ClothesCategorySection.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 02/10/26.
//

//  Seção de uma categoria na tela "Minhas roupas":
//  título com seta ("Camisas >") + carrossel horizontal com as fotos das peças.
//
//  Uso:
//  ClothesCategorySection(
//      title: "Camisas",
//      photos: fotosDasCamisas,          // [UIImage?] — nil mostra um placeholder
//      onSeeAllClick: { ... },           // toque no título
//      onItemClick: { index in ... }     // toque em uma peça
//  )
//

import SwiftUI

struct ClothesCategorySection: View {

    let title: String
    let photos: [UIImage?]
    var onSeeAllClick: () -> Void = {}
    var onItemClick: (Int) -> Void = { _ in }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // Título
            Button(action: onSeeAllClick) {
                HStack(spacing: 16) {
                    Text(title)
                        .font(.AppTypography.title2)
                    Image(systemName: "chevron.right")
                        .font(.headline)
                }
                .foregroundStyle(Color("titles"))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 24)
            .accessibilityHint("Ver todas as peças de \(title)")

            // Carrossel de peças
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(photos.indices, id: \.self) { index in
                        Button {
                            onItemClick(index)
                        } label: {
                            ClothingCard(photo: photos[index])
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 6) // espaço para a sombra não ser cortada
            }
            .padding(.bottom, 24)
            .scrollIndicators(.hidden)
            .contentMargins(.horizontal, 24, for: .scrollContent)
        }
    }
}

//Card da peça
private struct ClothingCard: View {
    let photo: UIImage?

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.white)
            .frame(width: 90, height: 120)
            .overlay {
                if let photo {
                    Image(uiImage: photo)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "hanger")
                        .font(.title)
                        .foregroundStyle(.black)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
    }
}

#Preview {
    ClothesCategorySection(
        title: "Camisas",
        photos: [nil, nil, nil, nil, nil]
    )
    .padding(.vertical)
    .background(Color.pink.opacity(0.05))
}
