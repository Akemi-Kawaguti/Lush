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
    
    // Dados de exemplo até ligar no SwiftData (nil = placeholder no card)
    private let sections: [(title: String, photos: [UIImage?])] = [
        ("Camisas", [nil, nil, nil, nil]),
        ("Calças", [nil, nil, nil, nil]),
        ("Saias", [nil, nil]),
        ("Vestidos", [nil, nil, nil])
    ]
 
    var body: some View {
        NavigationStack {
            ScrollView {
                
                VStack(alignment: .leading, spacing: 6) {
                    //Título e subtítulo
                    ScreenHeader(
                        title: "Minhas roupas",
                        subtitle: "Adicione suas roupas e faça escolhas assertivas"
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                    
                    // Seções por categoria (já têm margem lateral própria)
                    ForEach(sections, id: \.title) { section in
                        ClothesCategorySection(
                            title: section.title,
                            photos: section.photos,
                            onSeeAllClick: {
                                // TODO: abrir lista completa da categoria
                            },
                            onItemClick: { _ in
                                // TODO: abrir detalhes da peça
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
                        // TODO: abrir o cadastro de roupa
                    }
                )
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
 
#Preview {
    MyClothesView()
}



