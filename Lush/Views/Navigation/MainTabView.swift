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
            Tab("Lush", systemImage: "house.fill", value: .home) {
                // "Mais informações" na Home leva para a aba Minha área
                HomeView(onShowMyArea: { selectedTab = .myArea })
            }

            Tab("Favoritos", systemImage: "heart.fill", value: .favorites) {
                NavigationStack {
                    FavoritesView()
                }
            }

            Tab("Minha área", systemImage: "person.fill", value: .myArea) {
                MyAreaView()
            }
        }
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
}

#Preview {
    MainTabView()
}
