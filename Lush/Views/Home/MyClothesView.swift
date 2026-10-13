//
//  MyClothesView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 02/10/26.
//

import SwiftUI
import SwiftData

struct MyClothesView: View {

    @Environment(\.dismiss) private var dismiss

    @Query private var users: [UserModel]

    @State private var showAddClothing = false
    @State private var selectedCloth: ClothesModel?
    @State private var searchText = ""

    var currentUser: UserModel? {
        users.first
    }

    private var filteredClothes: [ClothesModel] {
        let clothes = currentUser?.userClothes ?? []

        let text = searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        if text.isEmpty {
            return clothes
        }

        return clothes.filter { cloth in
            cloth.name.localizedCaseInsensitiveContains(text)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {


                ScreenHeader(
                    title: "Minhas roupas",
                    subtitle: "Adicione suas roupas e faça escolhas assertivas"
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 8)


                // Busca (estilo suave)
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color("quartenary").opacity(0.7))

                    TextField("Buscar minhas roupas", text: $searchText)
                        .font(.body)
                        .foregroundStyle(Color("titles"))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .submitLabel(.search)

                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Color("quartenary").opacity(0.5))
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Limpar busca")
                    }
                }
                .padding(.horizontal, 16)
                .frame(height: 44)
                .background(Capsule().fill(.white.opacity(0.7)))
                .overlay(Capsule().stroke(Color("borderLines"), lineWidth: 0.5))
                .padding(.horizontal, 24)
                .padding(.bottom, 8)


                if searchText
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .isEmpty {

                    categoriesView

                } else {

                    searchResultsView
                }
            }
            .padding(.bottom, 20)
        }
        .scrollIndicators(.hidden)
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }


        .toolbar {
            Toolbar(action: .add,onBackClick: { dismiss() }, onActionClick: { showAddClothing = true })
        }
        .navigationBarBackButtonHidden(true)


        .navigationDestination(item: $selectedCloth) { cloth in
            ClothingDetailView(clothingItem: cloth)
        }


        .fullScreenCover(isPresented: $showAddClothing) {
            NavigationStack {
                AddClothingView()
            }
        }
    }


    // Uma seção por categoria (Camisetas, Camisas, Calças...), só as que têm peças
    private var categoriesView: some View {

        // Mais recentes primeiro
        let userClothes = Array((currentUser?.userClothes ?? []).reversed())

        let groups = GarmentCategory.allCases.compactMap { category -> (category: GarmentCategory, clothes: [ClothesModel])? in
            let clothes = userClothes.filter { $0.garmentCategory == category }
            return clothes.isEmpty ? nil : (category, clothes)
        }

        return Group {
            if groups.isEmpty {
                emptyClothesView
            } else {
                ForEach(groups, id: \.category) { group in
                    ClothesCategorySection(
                        title: group.category.pluralName,
                        photos: group.clothes.map { cloth in
                            cloth.photo.flatMap { UIImage(data: $0) }
                        },
                        onItemClick: { index in
                            if index < group.clothes.count {
                                selectedCloth = group.clothes[index]
                            }
                        }
                    )
                }
            }
        }
    }

    // Nenhuma roupa cadastrada ainda (mesmo estilo do aviso de Favoritos)
    private var emptyClothesView: some View {
        ContentUnavailableView(
            "Nenhuma roupa ainda",
            systemImage: "hanger",
            description: Text("Toque no + para adicionar suas peças e saber quais combinam com seu biotipo e sua paleta.")
        )
        .centeredEmptyState()
    }


    private var searchResultsView: some View {

        VStack(alignment: .leading, spacing: 12) {

            if filteredClothes.isEmpty {

                ContentUnavailableView(
                    "Nenhuma roupa encontrada",
                    systemImage: "hanger",
                    description: Text("Tente buscar por outro nome.")
                )
                .centeredEmptyState()

            } else {

                ForEach(filteredClothes) { cloth in

                    Button {
                        selectedCloth = cloth
                    } label: {

                        HStack(spacing: 16) {

                            if let data = cloth.photo,
                               let image = UIImage(data: data) {

                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80,height: 90)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))

                            } else {

                                Image(systemName: "hanger")
                                    .font(.title2)
                                    .frame(width: 80,height: 90)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }

                            VStack(alignment: .leading,spacing: 6) {

                                Text(cloth.name)
                                    .font(.AppTypography.title3)
                                    .foregroundStyle(Color("titles"))

                                Text(cloth.garmentCategory.rawValue)
                                .font(.AppTypography.body)
                                .foregroundStyle(Color("titles").opacity(0.7))
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                            .foregroundStyle(Color("titles"))
                        }
                        .padding(12)
                        .background(.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .overlay {
                            RoundedRectangle(cornerRadius: 18)
                            .stroke(Color("borderLines"),lineWidth: 0.5)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

// Nome da categoria no plural, para os títulos das seções
private extension GarmentCategory {
    var pluralName: String {
        switch self {
        case .tShirt: "Camisetas"
        case .tankTop: "Regatas"
        case .croppedTop: "Croppeds"
        case .blouse: "Blusas"
        case .shirt: "Camisas"
        case .bodysuit: "Bodies"
        case .sweater: "Suéteres"
        case .pants: "Calças"
        case .shorts: "Shorts"
        case .skirt: "Saias"
        case .leggings: "Leggings"
        case .bermudaShorts: "Bermudas"
        case .dress: "Vestidos"
        case .jumpsuit: "Macacões"
        }
    }
}

#Preview {
    NavigationStack {
        MyClothesView()
    }
}
