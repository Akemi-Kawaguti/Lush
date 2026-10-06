//
//  FavoritesView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 04/10/26.
//

//
//  FavoritesView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 04/10/26.
//

import SwiftUI

struct FavoritesView: View {

    @Environment(FavoritesStore.self) private var favoritesStore
    @State private var selectedLook: Look?

    var favorites: [Look] { favoritesStore.looks }

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
                    let items = Array(favorites.enumerated())
                    
                    HStack(alignment: .top, spacing: 16) {
                        column(items.filter { $0.offset.isMultiple(of: 2) })
                        column(items.filter { !$0.offset.isMultiple(of: 2) })
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
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedLook) { look in
            LookDetailView(
                look: look,
                isFavorite: true,
                onFavorite: {
                    // Desfavoritar: tira da lista e fecha os detalhes
                    favoritesStore.toggle(look)
                    selectedLook = nil
                }
            )
        }
    }

    func column(_ items: [(offset: Int, element: Look)]) -> some View {
        VStack(spacing: 16) {
            ForEach(items, id: \.element.id) { item in
                let look = item.element

                Color.clear
                    .frame(maxWidth: .infinity)
                    .frame(height: heights[item.offset % heights.count])
                    .overlay {
                        LookImage(imageName: look.imageName, url: look.imageURL)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .contentShape(RoundedRectangle(cornerRadius: 16))
                    .onTapGesture { selectedLook = look }
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel(look.altText ?? "Look \(look.style.rawValue)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
    .environment(FavoritesStore())
}
