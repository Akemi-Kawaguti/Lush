//
//  RootView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//

//
//  RootView.swift
//  Lush
//
//  Primeira tela do app: mostra a splash por cima da tela inicial
//  e, quando a animação termina, some com um fade.
//  A tela inicial já carrega por baixo enquanto a splash toca.
//

import SwiftUI

struct RootView: View {

    @State private var isShowingSplash = true

    var body: some View {
        ZStack {
            // Tela inicial real do app (troque pela que vocês usam)
            ContentView()

            if isShowingSplash {
                SplashView {
                    withAnimation(.easeOut(duration: 0.4)) {
                        isShowingSplash = false
                    }
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
    }
}

#Preview {
    RootView()
}
