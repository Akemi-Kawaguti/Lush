//
//  RootView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//

//  Primeira tela do app: mostra a splash por cima da tela inicial
//  e, quando a animação termina, some com um fade.
//  A tela inicial já carrega por baixo enquanto a splash toca.

import SwiftUI

struct RootView: View {

    @State private var isShowingSplash = true

    // Fica salvo no iPhone: depois da primeira análise, o app abre direto nas abas
    @AppStorage("hasFinishedOnboarding") private var hasFinishedOnboarding = false

    var body: some View {
        ZStack {
            if hasFinishedOnboarding {
                MainTabView()
                    .transition(.opacity)
            } else {
                // Apresentação → termos → análise → resultado → "Sobre você"
                PresentationView()
                    .environment(\.finishAnalysis) {
                        withAnimation {
                            hasFinishedOnboarding = true
                        }
                    }
            }

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
