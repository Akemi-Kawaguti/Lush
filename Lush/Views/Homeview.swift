//
//  Homeview.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//

import SwiftUI

struct HomeView: View {

    // Dados de exemplo (depois virão do UserModel)
    let palette = "Outono Profundo"
    let bodyShape: BodyShape = .hourglass
    let paletteColors: [Color] = [
        Color(red: 0.0, green: 0.52, blue: 0.62),
        Color(red: 0.05, green: 0.36, blue: 0.29),
        Color(red: 0.53, green: 0.08, blue: 0.36),
        Color(red: 0.49, green: 0.13, blue: 0.16),
        Color(red: 0.98, green: 0.52, blue: 0.08),
        Color(red: 0.36, green: 0.26, blue: 0.14)
    ]

    let looks = ["look1", "look1", "look1"]
    @State private var favoriteLooks: [String] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {

                    Text("Lush")
                        .font(.AppTypography.largeTitle)
                        .padding(.horizontal, 24)

                    // Mais informações
                    VStack(alignment: .leading, spacing: 16) {
                        sectionTitle("Mais Informações")
                        profileCard
                    }
                    .padding(.horizontal, 24)

                    // Sugestões de looks
                    VStack(alignment: .leading, spacing: 16) {
                        sectionTitle("Sugestões de looks")
                            .padding(.horizontal, 24)

                        ScrollView(.horizontal) {
                            HStack(spacing: 12) {
                                ForEach(looks, id: \.self) { look in
                                    LookCard(
                                        imageName: look,
                                        credit: "Photo by Nome on Pexels",
                                        isFavorite: favoriteLooks.contains(look),
                                        onFavorite: { toggleFavorite(look) }
                                    )
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        .scrollIndicators(.hidden)
                    }

                    // Minhas roupas (componente que já existe)
                    ClothesCategorySection(
                        title: "Minhas roupas",
                        photos: [nil, nil, nil, nil]
                    )
                }
                .padding(.vertical, 24)
            }
            .scrollIndicators(.hidden)
            .background {
                Image("backgroundLush")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
        }
    }

    // Título de seção com seta: "Mais Informações >"
    func sectionTitle(_ title: String) -> some View {
        Button {
            // TODO: abrir a tela da seção
        } label: {
            HStack(spacing: 12) {
                Text(title)
                    .font(.AppTypography.title2)
                Image(systemName: "chevron.right")
                    .font(.headline)
            }
            .foregroundStyle(.primary)
        }
        .buttonStyle(.plain)
    }

    // Card com o biotipo e a paleta da usuária
    var profileCard: some View {
        HStack(spacing: 20) {
            Image(bodyShape.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 130)

            VStack(alignment: .leading, spacing: 2) {
                Text("Seu biotipo:")
                    .font(.footnote)
                    .foregroundStyle(Color(.black).opacity(0.7))
            
                Text(bodyShape.rawValue)
                    .font(.AppTypography.headline)

                // Faixa com as cores da paleta
                HStack(spacing: 0) {
                    ForEach(paletteColors, id: \.self) { color in
                        Rectangle().fill(color)
                    }
                }
                .frame(height: 6)
                .clipShape(Capsule())
                .padding(.vertical, 10)

                Text("Sua paleta:")
                    .font(.footnote)
                    .foregroundStyle(Color(.black).opacity(0.7))
                Text(palette)
                    .font(.AppTypography.headline)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 24).fill(.white))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.gray.opacity(0.2), lineWidth: 1))
    }

    func toggleFavorite(_ look: String) {
        if favoriteLooks.contains(look) {
            favoriteLooks.removeAll { $0 == look }
        } else {
            favoriteLooks.append(look)
        }
    }
}

#Preview {
    HomeView()
}
