//
//  MainTabView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 05/10/26.
//

import SwiftUI

enum AppTab {
    case home, favorites, myArea
}

struct MainTabView: View {

    @State private var selectedTab: AppTab = .home
    @State private var favorites = FavoritesStore()

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Lush", image: "LushTabBar", value: .home) {
                // "Mais informações" na Home leva para a aba Minha área
                HomeView(onShowMyArea: { selectedTab = .myArea })
                    .tint(Color("textAttention"))
            }

            Tab("Favoritos", systemImage: "heart.fill", value: .favorites) {
                NavigationStack {
                    FavoritesView()
                }
                .tint(Color("textAttention"))
            }

            Tab("Minha área", systemImage: "person.fill", value: .myArea) {
                MyAreaView()
                    .tint(Color("textAttention"))
            }
        }
        // Rosa só na tab bar (aba selecionada). Dentro de cada aba, a cor padrão é escura,
        // para menus, alertas e opções como "Tirar foto" não ficarem rosa.
        .tint(Color("button"))
        .environment(favorites)
        
    }
}

// Fundo padrão do Lush: cobre a tela inteira, inclusive embaixo da tab bar
extension View {
    func lushBackground() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Image("backgroundLush")
                    .resizable()
                    .scaledToFill()
                    
                    .scaleEffect(1.05, anchor: .top)
                    .ignoresSafeArea()
            }
    }

    // Avisos de tela vazia (sem favoritos, sem conexão, sem roupas...):
    // ocupa a área abaixo do cabeçalho e fica centralizado nela
    func centeredEmptyState() -> some View {
        self
            .frame(maxWidth: .infinity)
            .containerRelativeFrame(.vertical, alignment: .center) { height, _ in
                height * 0.55
            }
    }
}

#Preview {
    MainTabView()
}
