//
//  FavoritesView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 04/10/26.
//

import SwiftUI

struct FavoritesView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var favorites = Look.samples
    @State private var selectedLook: Look?

    // Alturas que se repetem para formar o mosaico
    let heights: [CGFloat] = [240, 320, 130, 150, 240, 240]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                ScreenHeader(
                    title: "Favoritos",
                    subtitle: "Verifique as sugestões de looks favoritadas"
                )

                if favorites.isEmpty {
                    ContentUnavailableView(
                        "Nenhum favorito ainda",
                        systemImage: "heart",
                        description: Text("Toque no coração das sugestões de looks para salvar aqui.")
                    )
                    .padding(.top, 40)
                } else {
                    // Duas colunas: índices pares na esquerda, ímpares na direita
                    HStack(alignment: .top, spacing: 16) {
                        column(favorites.indices.filter { $0.isMultiple(of: 2) })
                        column(favorites.indices.filter { !$0.isMultiple(of: 2) })
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .toolbar {
            Toolbar(action: nil, onBackClick: { dismiss() })
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedLook) { look in
            LookDetailView(
                look: look,
                isFavorite: true,
                onFavorite: {
                    // Desfavoritar: tira da lista e fecha os detalhes
                    favorites.removeAll { $0.id == look.id }
                    selectedLook = nil
                }
            )
        }
    }

    func column(_ indices: [Int]) -> some View {
        VStack(spacing: 16) {
            ForEach(indices, id: \.self) { index in
                Color.clear
                    .frame(maxWidth: .infinity)
                    .frame(height: heights[index % heights.count])
                    .overlay {
                        LookImage(imageName: favorites[index].imageName)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .contentShape(RoundedRectangle(cornerRadius: 16))
                    .onTapGesture { selectedLook = favorites[index] }
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel("Look \(favorites[index].style.rawValue)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}
