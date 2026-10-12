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
//      photos: fotosDasCamisas,          // [UIImage?] — nil mostra o cabide (peça sem foto)
//      onSeeAllClick: { ... },           // toque no título
//      onItemClick: { index in ... },    // toque em uma peça
//      onAddClick: { ... }               // opcional: sem peças, mostra o card "Adicionar"
//  )
//

import SwiftUI

struct ClothesCategorySection: View {

    let title: String
    let photos: [UIImage?]
    var onSeeAllClick: () -> Void = {}
    var onItemClick: (Int) -> Void = { _ in }
    var onAddClick: (() -> Void)? = nil
    var emptyMessage: String = "Cadastre sua primeira peça de roupa e descubra se ela combina com você."

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

            // Sem peças: card "Adicionar" + mensagem
            if photos.isEmpty, let onAddClick {
                HStack(spacing: 16) {
                    Button(action: onAddClick) {
                        AddClothingCard()
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Cadastrar roupa")

                    Text(emptyMessage)
                        .font(.subheadline)
                        .foregroundStyle(Color("textAttention"))
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 24).fill(.white.opacity(0.7)))
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color("borderLines"), lineWidth: 0.5))
                .padding(.horizontal, 24)
                .padding(.vertical, 6)
                .padding(.bottom, 24)
            } else {
                carousel
            }
        }
    }

    // Carrossel de peças
    private var carousel: some View {
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
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("borderLines"), lineWidth: 0.5))
    }
}

// Card "Adicionar" (aparece quando ainda não há peças)
private struct AddClothingCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.white.opacity(0.6))
            .frame(width: 90, height: 120)
            .overlay {
                VStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.title2.weight(.semibold))
                    Text("Adicionar")
                        .font(.caption)
                }
                .foregroundStyle(Color("button"))
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color("button"), style: StrokeStyle(lineWidth: 1, dash: [5]))
            )
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
