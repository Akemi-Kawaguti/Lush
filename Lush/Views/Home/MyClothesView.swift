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

    // Conecta com o SwiftData para buscar o usuário atual
    @Query private var users: [UserModel]
         
    var currentUser: UserModel? {
        users.first
    }

    @State private var showAddClothing = false
    @State private var selectedCloth: ClothesModel? // Controla a seleção e a navegação automaticamente
    
    // Dados de exemplo até ligar no SwiftData (nil = placeholder no card)
    private let sections: [(title: String, photos: [UIImage?])] = [
        ("Camisas", [nil, nil, nil, nil]),
        ("Calças", [nil, nil, nil, nil]),
        ("Saias", [nil, nil]),
        ("Vestidos", [nil, nil, nil])
    ]
 
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Título e subtítulo
                ScreenHeader(
                    title: "Minhas roupas",
                    subtitle: "Adicione suas roupas e faça escolhas assertivas"
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
                 
                // Agrupando as roupas do usuário por GarmentCategory
                let userClothes = currentUser?.userClothes ?? []
                 
                let categoriesToDisplay: [(title: String, categories: [GarmentCategory])] = [
                    ("Camisas", [.tShirt, .tankTop, .croppedTop, .blouse, .shirt, .bodysuit, .sweater]),
                    ("Calças", [.pants, .shorts, .skirt, .leggings, .bermudaShorts]),
                    ("Saias", [.skirt]),
                    ("Vestidos", [.dress, .jumpsuit])
                ]

                ForEach(categoriesToDisplay, id: \.title) { group in
                    // Filtra as roupas do usuário que pertencem a este grupo de categorias
                    let filteredClothes = userClothes.filter { group.categories.contains($0.garmentCategory) }
                     
                    // Converte os dados salvos (Data?) em UIImage? para o componente exibir
                    let photos: [UIImage?] = filteredClothes.map { cloth in
                        if let data = cloth.photo {
                            return UIImage(data: data)
                        }
                        return nil
                    }
                     
                    // Exibe a seção apenas se houver roupas ou mantemos a estrutura com placeholders se preferir
                    ClothesCategorySection(
                        title: group.title,
                        photos: photos.isEmpty ? [nil, nil, nil, nil] : photos,
                        onSeeAllClick: {
                            // TODO: abrir lista completa da categoria
                        },
                        onItemClick: { index in
                            if index < filteredClothes.count {
                                selectedCloth = filteredClothes[index] // Atribuir aqui já dispara a navegação
                            }
                        }
                    )
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
            Toolbar(
                action: .add,
                onBackClick: { dismiss() },
                onActionClick: {
                    showAddClothing = true
                }
            )
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(item: $selectedCloth) { cloth in
            ClothingDetailView(clothingItem: cloth)
            // Passa o item selecionado corretamente para a tela de detalhe
        }
        // Cadastro abre por cima da tela; o "voltar" dele fecha
        .fullScreenCover(isPresented: $showAddClothing) {
            NavigationStack {
                AddClothingView()
            }
        }
    }
}
 
#Preview {
    NavigationStack {
        MyClothesView()
    }
}
