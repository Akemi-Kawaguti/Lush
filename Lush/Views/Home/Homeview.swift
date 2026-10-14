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
    
    // Análise escolhida em "Minhas avaliações" (ou a mais recente)
    var latestAnalysis: AnalysisModel? {
        currentUser?.currentAnalysis
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
    @State private var showAddClothing = false
    @State private var selectedLook: Look?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    
                    header
                        .padding(.horizontal, 24)
                    
                    // Mais informações
                    VStack(alignment: .leading, spacing: 16) {
                        sectionTitle("Mais Informações") {
                            onShowMyArea()
                        }
                        // Toque no card abre a Minha área
                        Button {
                            onShowMyArea()
                        } label: {
                            profileCard
                        }
                        .buttonStyle(.plain)
                        .accessibilityHint("Abre a Minha área")
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
                                    // Carregando: 3 cards brancos com o indicador
                                    // Sem conexão: 3 cards brancos com o ícone de wi-fi
                                    ForEach(0..<3, id: \.self) { _ in
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.white.opacity(0.6))
                                            .frame(width: 170, height: 220)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color("borderLines"), lineWidth: 0.5)
                                            )
                                            .overlay {
                                                if isLoadingLooks {
                                                    ProgressView()
                                                        .tint(Color("button"))
                                                } else {
                                                    Image(systemName: "wifi.exclamationmark")
                                                        .font(.title2)
                                                        .foregroundStyle(Color("quartenary").opacity(0.6))
                                                }
                                            }
                                    }
                                } else {
                                    ForEach(looks) { look in
                                        LookCard(
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
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Não foi possível carregar as sugestões. Verifique sua conexão.")
                                    .font(.footnote)
                                    .foregroundStyle(Color("quartenary"))
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)

                                Button("Tentar de novo") {
                                    Task { await loadHomeLooks() }
                                }
                                .font(.footnote.weight(.semibold))
                                .tint(Color("button"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)   // alinhado à esquerda, como os títulos
                            .padding(.horizontal, 24)
                        }
                    }
                    
                    // Minhas roupas (SwiftData): as 4 últimas cadastradas.
                    // Sem roupas, aparece o card para cadastrar a primeira.
                    let recentClothes = Array((currentUser?.userClothes ?? []).reversed().prefix(4))
                    let clothesPhotos: [UIImage?] = recentClothes.map { item in
                        item.photo.flatMap { UIImage(data: $0) }
                    }

                    ClothesCategorySection(
                        title: "Minhas roupas",
                        photos: clothesPhotos,
                        onSeeAllClick: { showMyClothes = true },
                        onItemClick: { index in
                            if index < recentClothes.count {
                                selectedClothingItem = recentClothes[index]
                                showClothingDetail = true
                            }
                        },
                        onAddClick: { showAddClothing = true }
                    )
                }
                .padding(.vertical, 24)
            }
            .scrollIndicators(.hidden)
            .lushBackground()
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
            .fullScreenCover(isPresented: $showAddClothing) {
                NavigationStack {
                    AddClothingView()
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
    
    // Saudação com o primeiro nome da usuária
    var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(firstName.isEmpty ? "Olá!" : "Olá, \(firstName)")
                .font(.AppTypography.largeTitle)
                .foregroundStyle(Color("titles"))
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text("Descubra o que valoriza o seu estilo")
                .font(.subheadline)
                .foregroundStyle(Color("quartenary"))
        }
    }

    var firstName: String {
        (currentUser?.name ?? "")
            .split(separator: " ")
            .first
            .map(String.init) ?? ""
    }

    // Card com o biotipo e a paleta da usuária (todo branco):
    // silhueta no lado esquerdo, separada por uma linha fina das informações
    var profileCard: some View {
        HStack(spacing: 0) {
 
            // Lado esquerdo: painel branco com a silhueta centralizada
            ZStack {
                Color.white
 
                Image(bodyShape.imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(.vertical, 16)
                    .padding(.horizontal, 18)
            }
            .frame(width: 124)
            .frame(maxHeight: .infinity)
            .accessibilityHidden(true)
 
            Rectangle()
                .fill(Color("borderLines").opacity(0.3))
                .frame(width: 0.5)
 
            // Lado direito: biotipo e paleta
            VStack(alignment: .leading, spacing: 14) {
 
                VStack(alignment: .leading, spacing: 2) {
                    Text("Seu biotipo")
                        .font(.footnote)
                        .foregroundStyle(Color("textAttention").opacity(0.6))
                    Text(bodyShape.rawValue)
                        .font(.AppTypography.headline)
                        .foregroundStyle(Color("titles"))
                }
 
                VStack(alignment: .leading, spacing: 2) {
                    Text("Sua paleta")
                        .font(.footnote)
                        .foregroundStyle(Color("textAttention").opacity(0.6))
                    Text(paleteSeason.rawValue)
                        .font(.AppTypography.headline)
                        .foregroundStyle(Color("titles"))
 
                    // Cores da paleta em bolinhas, distribuídas na largura toda
                    let dots = Array(paletteColors.prefix(8))
                    HStack(spacing: 0) {
                        ForEach(dots.indices, id: \.self) { index in
                            Circle()
                                .fill(dots[index])
                                .frame(width: 18, height: 18)
                            
 
                            if index < dots.count - 1 {
                                Spacer(minLength: 4)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(.white)
        }
        .fixedSize(horizontal: false, vertical: true)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color("borderLines"), lineWidth: 0.5))
        .shadow(color: .black.opacity(0.06), radius: 10, y: 4)
        .contentShape(RoundedRectangle(cornerRadius: 28))
        .accessibilityElement(children: .combine)
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
