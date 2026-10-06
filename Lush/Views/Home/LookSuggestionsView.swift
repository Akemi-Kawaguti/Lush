//
//  LookSuggestionsView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 04/10/26.
//

import SwiftUI

struct LookSuggestionsView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var looks = Look.samples
    @State private var selectedStyle: LookStyle? = nil   // nil = Todos
    @State private var favoriteIDs: Set<UUID> = []
    @State private var selectedLook: Look?

    let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]

    var filteredLooks: [Look] {
        guard let selectedStyle else { return looks }
        return looks.filter { $0.style == selectedStyle }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                ScreenHeader(
                    title: "Sugestões de looks",
                    subtitle: "Favorite as peças que te agradam"
                )
                .padding(.horizontal, 24)

                // Filtros
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        FilterChip(title: "Todos", isSelected: selectedStyle == nil) {
                            selectedStyle = nil
                        }
                        ForEach(LookStyle.allCases, id: \.self) { style in
                            FilterChip(title: style.rawValue, isSelected: selectedStyle == style) {
                                selectedStyle = style
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .scrollIndicators(.hidden)

                // Grade de looks
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredLooks) { look in
                        LookCard(
                            imageName: look.imageName,
                            credit: look.credit,
                            isFavorite: favoriteIDs.contains(look.id),
                            height: 260,
                            onFavorite: { toggleFavorite(look) }
                        )
                        .onTapGesture { selectedLook = look }
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 24)
            .animation(.easeInOut, value: selectedStyle)
        }
        .scrollIndicators(.hidden)
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .toolbar {
            Toolbar(
                action: .refresh,
                onBackClick: { dismiss() },
                onActionClick: {
                    // TODO: buscar novas sugestões; por enquanto embaralha
                    withAnimation { looks.shuffle() }
                }
            )
        }
        
        .task {
            print("Chave lida:", APIKeys.pexels)
            do {
                let photos = try await RequestAPI.searchPhotos(query: "casual outfit")
                print("Fotos encontradas:", photos.count)
            } catch {
                print("Erro na busca:", error)
            }
        }
        
        
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedLook) { look in
            LookDetailView(
                look: look,
                isFavorite: favoriteIDs.contains(look.id),
                onFavorite: { toggleFavorite(look) }
            )
        }
    }

    func toggleFavorite(_ look: Look) {
        if favoriteIDs.contains(look.id) {
            favoriteIDs.remove(look.id)
        } else {
            favoriteIDs.insert(look.id)
        }
    }
}

#Preview {
    NavigationStack {
        LookSuggestionsView()
    }
}
