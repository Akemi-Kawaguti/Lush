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

    var body: some View {
        GeometryReader { geometry in
            // Calcula a largura disponível para o grid (Considerando padding lateral 24 e spacing 16 entre colunas)
            let totalHorizontalPadding: CGFloat = 48 // 24 de cada lado
            let spacing: CGFloat = 16
            let availableWidth = geometry.size.width - totalHorizontalPadding
            let columnWidth = (availableWidth - spacing) / 2

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
                        .centeredEmptyState()
                    } else {
                        // Distribuição dinâmica nas 2 colunas usando a altura real calculada
                        let columnsData = factoredData(for: favorites, columnsCount: 2, columnWidth: columnWidth)
                        
                        HStack(alignment: .top, spacing: spacing) {
                            ForEach(0..<2, id: \.self) { columnIndex in
                                VStack(spacing: spacing) {
                                    ForEach(columnsData[columnIndex], id: \.element.id) {(item: (element: Look, height: CGFloat)) in
                                        let look = item.element
                                        let height = item.height
                                        
                                        LookImage(url: look.highResImageURL, fallbackURL: look.largeImageURL)
                                            .scaledToFill()
                                            .frame(width: columnWidth, height: height)
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                            .contentShape(RoundedRectangle(cornerRadius: 16))
                                            .onTapGesture { selectedLook = look }
                                            .accessibilityAddTraits(.isButton)
                                            .accessibilityLabel(look.altText ?? "Look \(look.style.rawValue)")
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .lushBackground()
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedLook) { look in
            LookDetailView(
                look: look,
                isFavorite: true,
                onFavorite: {
                    favoritesStore.toggle(look)
                    selectedLook = nil
                }
            )
        }
    }

    /// Calcula a altura baseada na proporção real da imagem ou usa um fallback proporcional padrão se a proporção não estiver salva no Look.
    private func heightFor(look: Look, columnWidth: CGFloat) -> CGFloat {
        // Se o seu modelo Look já tiver a proporção (aspectRatio = largura / altura) salva, use-a:
        // if let ratio = look.aspectRatio { return columnWidth / ratio }
        
        // Caso contrário, se você tiver as dimensões originais (width e height):
        // if let w = look.originalWidth, let h = look.originalHeight { return columnWidth * (h / w) }
        
        // Se não tiver nenhuma proporção salva no banco/modelo, você pode definir um valor padrão proporcional
        // (por exemplo, fotos verticais de estilo costumam ter proporção 4:5 ou 2:3)
        let defaultAspectRatio: CGFloat = 4.0 / 5.0 // Largura / Altura
        return columnWidth / defaultAspectRatio
    }

    /// Distribui os itens na coluna mais curta dinamicamente, acumulando as alturas reais
    private func factoredData(for items: [Look], columnsCount: Int, columnWidth: CGFloat) -> [[(element: Look, height: CGFloat)]] {
        var colData = Array(repeating: [(element: Look, height: CGFloat)](), count: columnsCount)
        var colHeights = Array(repeating: CGFloat(0), count: columnsCount)
        
        for item in items {
            let shortestColumn = colHeights.firstIndex(of: colHeights.min()!) ?? 0
            let itemHeight = heightFor(look: item, columnWidth: columnWidth)
            
            colData[shortestColumn].append((element: item, height: itemHeight))
            colHeights[shortestColumn] += itemHeight + 16 // 16 é o espaçamento vertical entre os cards
        }
        
        return colData
    }
}
