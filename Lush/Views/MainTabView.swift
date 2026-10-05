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

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Início", systemImage: "house.fill", value: .home) {
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
    }
}

#Preview {
    MainTabView()
}
