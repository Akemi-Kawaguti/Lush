//
//  Homeview.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    // Contexto e Query para buscar o usuário no SwiftData
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [UserModel]
    
    @State private var selectedClothingItem: ClothesModel?
    @State private var showClothingDetail = false
    
    var currentUser: UserModel? {
        users.first
    }
    
    var latestAnalysis: AnalysisModel? {
        currentUser?.analysis.sorted(by: { $0.date > $1.date }).first
    }
    
    // Biotipo integrado com o BodyShape
    var bodyShape: BodyShape {
        if let silhouetteName = latestAnalysis?.userSilhouette,
           let shape = BodyShape.allCases.first(where: { $0.rawValue == silhouetteName }) {
            return shape
        }
        return .hourglass
    }
    
    var paleteSeason: PaleteSeason {
        // Tenta buscar pelo nome salvo no userPalette (ex: "Outono Profundo")
        if let seasonName = latestAnalysis?.userPalette.first,
           let season = PaleteSeason.allCases.first(where: { $0.rawValue == seasonName }) {
            return season
        }
        return .autumnDeep // Fallback padrão caso não haja análise
    }
    
    var paletteColors: [Color] {
        return paleteSeason.colorPaletes.map { colorName in
            Color(colorName)
        }
    }
    
    // Looks de exemplo (os 3 primeiros)
    @State private var looks: [Look] = []
    @State private var isLoadingLooks = true
    @State private var loadedPalette: PaleteSeason? //paleta de looks
    @Environment(FavoritesStore.self) private var favorites
    
    // Navegação
    var onShowMyArea: () -> Void = {}
    @State private var showLookSuggestions = false
    @State private var showMyClothes = false
    @State private var selectedLook: Look?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    
                    Text("Lush")
                        .font(.AppTypography.largeTitle)
                        .padding(.horizontal, 24)
                        .foregroundStyle(Color("titles"))
                    
                    // Mais informações
                    VStack(alignment: .leading, spacing: 16) {
                        sectionTitle("Mais Informações") {
                            onShowMyArea()
                        }
                        profileCard
                    }
                    .padding(.horizontal, 24)
                    
                    // Sugestões de looks
                    VStack(alignment: .leading, spacing: 16) {
                        sectionTitle("Sugestões de looks") {
                            showLookSuggestions = true
                        }
                        .padding(.horizontal, 24)
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 12) {
                                if looks.isEmpty {
                                    // Carregando: 3 cards cinza com o indicador
                                    // Sem conexão: 3 cards cinza com o ícone de wi-fi
                                    ForEach(0..<3, id: \.self) { _ in
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: 170, height: 220)
                                            .overlay {
                                                if isLoadingLooks {
                                                    ProgressView()
                                                } else {
                                                    Image(systemName: "wifi.exclamationmark")
                                                        .font(.title2)
                                                        .foregroundStyle(.secondary)
                                                }
                                            }
                                    }
                                } else {
                                    ForEach(looks) { look in
                                        LookCard(
                                            imageName: look.imageName,
                                            imageURL: look.imageURL,
                                            fallbackURL: look.largeImageURL,
                                            credit: look.credit,
                                            isFavorite: favorites.contains(look),
                                            onFavorite: { toggleFavorite(look) }
                                        )
                                        .frame(width: 170)
                                        // Toque no card abre os detalhes
                                        .onTapGesture { selectedLook = look }
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        .scrollIndicators(.hidden)
                        
                        // Aviso quando não foi possível carregar as sugestões
                        if looks.isEmpty && !isLoadingLooks {
                            HStack(spacing: 8) {
                                Text("Não foi possível carregar as sugestões. Verifique sua conexão.")
                                    .font(.footnote)
                                    .foregroundStyle(Color("quartenary"))
                                    .fixedSize(horizontal: false, vertical: true)

                                Spacer()

                                Button("Tentar de novo") {
                                    Task { await loadHomeLooks() }
                                }
                                .font(.footnote.weight(.semibold))
                                .tint(Color("button"))
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    
                    // Minhas roupas conectadas ao SwiftData (`currentUser?.userClothes`)
                    let userClothes = currentUser?.userClothes ?? []
                    let clothesPhotos: [UIImage?] = userClothes.prefix(4).map { item in
                        if let data = item.photo {
                            return UIImage(data: data)
                        }
                        return nil
                    }
                    let displayPhotos = clothesPhotos.isEmpty ? [nil, nil, nil, nil] : clothesPhotos
                    
                    ClothesCategorySection(
                        title: "Minhas roupas",
                        photos: displayPhotos,
                        onSeeAllClick: { showMyClothes = true },
                        onItemClick: { index in
                            if index < userClothes.count {
                                selectedClothingItem = userClothes[index]
                                showClothingDetail = true
                            }}
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
            .navigationDestination(isPresented: $showLookSuggestions) {
                LookSuggestionsView(palette: paleteSeason)
            }
            .navigationDestination(isPresented: $showMyClothes) {
                MyClothesView()
            }
            .navigationDestination(isPresented: $showClothingDetail) {
                if let item = selectedClothingItem {
                    ClothingDetailView(clothingItem: item)
                }
            
            }
            .sheet(item: $selectedLook) { look in
                LookDetailView(
                    look: look,
                    isFavorite: favorites.contains(look),
                    onFavorite: { toggleFavorite(look) }
                )
            }
            .task(id: paleteSeason) {
                await loadHomeLooks()
            }
        }
    }
    
    // Título de seção com seta: "Mais Informações >"
    func sectionTitle(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(title)
                    .font(.AppTypography.title2)
                Image(systemName: "chevron.right")
                    .font(.headline)
            }
            .foregroundStyle(Color("titles"))
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
                    .foregroundStyle(Color("textAttention").opacity(0.7))
                
                Text(bodyShape.rawValue)
                    .font(.AppTypography.headline)
                    .foregroundStyle(Color("titles"))
                
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
                    .foregroundStyle(Color("textAttention").opacity(0.7))
                Text(paleteSeason.rawValue)
                    .font(.AppTypography.headline)
                    .foregroundStyle(Color("titles"))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 24).fill(.white))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color("borderLines"), lineWidth: 0.5))
    }
    
    func toggleFavorite(_ look: Look) {
        favorites.toggle(look)
    }
    
    func loadHomeLooks() async {
        //já tem looks desta paleta: n busca dnv
        if loadedPalette == paleteSeason, !looks.isEmpty { return }
        
        isLoadingLooks = true
        do {
            let photos = try await RequestAPI.fetchLooks(palette: paleteSeason, style: nil, limit: 6)
            looks = photos.map { Look(photo: $0, style: .casual) }
            loadedPalette = paleteSeason
        } catch {
            if Task.isCancelled { return }   // saiu da tela no meio da busca
        }
        isLoadingLooks = false
    }
}

#Preview {
    HomeView()
        .environment(FavoritesStore())
}
