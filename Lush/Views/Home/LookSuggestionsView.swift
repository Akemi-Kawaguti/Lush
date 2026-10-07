//
//  LookSuggestionsView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 04/10/26.
//

import SwiftUI

struct LookSuggestionsView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var looks: [Look] = []
    @State private var selectedStyle: LookStyle? = nil   // nil = Todos
    @State private var page = 1
    @State private var isLoading = true    // já abre carregando
    @State private var errorMessage: String?
    @Environment(FavoritesStore.self) private var favorites
    @State private var selectedLook: Look?
    var palette: PaleteSeason = .autumnDeep

    let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]

    // Muda quando troca o filtro ou pede novas sugestões: dispara uma nova busca
    var searchID: String {
        "\(selectedStyle?.rawValue ?? "Todos")-\(page)"
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
                            selectStyle(nil)
                        }
                        ForEach(LookStyle.allCases, id: \.self) { style in
                            FilterChip(title: style.rawValue, isSelected: selectedStyle == style) {
                                selectStyle(style)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .scrollIndicators(.hidden)

                content
                    .padding(.horizontal, 24)
            }
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
            Toolbar(
                action: .refresh,
                isActionEnabled: !isLoading,
                onBackClick: { dismiss() },
                onActionClick: { page += 1 }   // próxima página do Pexels
            )
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        // Busca ao abrir a tela e sempre que o searchID mudar
        .task(id: searchID) {
            await loadLooks()
        }
        .sheet(item: $selectedLook) { look in
            LookDetailView(
                look: look,
                isFavorite: favorites.contains(look),
                onFavorite: { toggleFavorite(look) }
            )
        }
    }

    // Carregando, erro, vazio ou a grade de looks
    @ViewBuilder
    var content: some View {
        if isLoading {
            ProgressView("Buscando sugestões...")
                .frame(maxWidth: .infinity)
                .padding(.top, 80)
        } else if let errorMessage {
            ContentUnavailableView {
                Label("Sem sugestões agora", systemImage: "wifi.exclamationmark")
            } description: {
                Text(errorMessage)
            } actions: {
                Button("Tentar de novo") {
                    Task { await loadLooks() }
                }
                .tint(Color("button"))
            }
        } else if looks.isEmpty {
            ContentUnavailableView(
                "Nenhum look encontrado",
                systemImage: "hanger",
                description: Text("Tente outro estilo.")
            )
        } else {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(looks) { look in
                    LookCard(
                        imageName: look.imageName,
                        imageURL: look.imageURL,
                        credit: look.credit,
                        isFavorite: favorites.contains(look),
                        height: 260,
                        onFavorite: { toggleFavorite(look) }
                    )
                    .onTapGesture { selectedLook = look }
                }
            }
        }
    }

    func selectStyle(_ style: LookStyle?) {
        selectedStyle = style
        page = 1
    }

    func loadLooks() async {
        isLoading = true
        errorMessage = nil

        let query = selectedStyle?.searchQuery ?? "women fashion outfit"
        let colors = palette.fashionColors
        let style = selectedStyle ?? .casual
        let currentPage = page

        // Uma busca por cor da paleta, todas ao mesmo tempo (3 fotos cada)
        var photos: [PexelsPhoto] = []
        await withTaskGroup(of: [PexelsPhoto].self) { group in
            for color in colors {
                group.addTask {
                    // Nome da cor no texto da busca: foca na roupa, não no fundo
                    let photos = (try? await RequestAPI.searchPhotos(
                        query: "\(color.name) \(query)",
                        color: color.hex,
                        perPage: 8,
                        page: currentPage
                    )) ?? []

                    // Prefere fotos cuja descrição cita a cor ("woman in burgundy dress")
                    let matching = photos.filter { photo in
                        let description = (photo.alt ?? "").lowercased()
                        return color.keywords.contains { description.contains($0) }
                    }

                    // Até 3 fotos por cor; se nenhuma descrição citar a cor, usa as outras
                    return Array((matching.isEmpty ? photos : matching).prefix(3))
                }
            }
            for await result in group {
                photos += result
            }
        }

        if Task.isCancelled { return }

        // A mesma foto pode aparecer em duas cores: mantém só uma vez
        var seenIDs: Set<Int> = []
        let uniquePhotos = photos.filter { seenIDs.insert($0.id).inserted }

        if uniquePhotos.isEmpty {
            errorMessage = "Verifique sua conexão com a internet e tente novamente."
        } else {
            looks = uniquePhotos.shuffled().map { Look(photo: $0, style: style) }
        }

        isLoading = false
    }

    func toggleFavorite(_ look: Look) {
        favorites.toggle(look)
    }
}

#Preview {
    NavigationStack {
        LookSuggestionsView()
    }
    .environment(FavoritesStore())
}
