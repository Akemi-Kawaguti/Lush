//
//  SplashView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//

//  Splash com a animação do After Effects (.mov).
//  Quando o vídeo termina, chama `onFinish` (o RootView troca para o app).

import SwiftUI

struct SplashView: View {

    var onFinish: () -> Void = {}

    var body: some View {
        ZStack {
            Image("backgroundScreen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VideoPlayerView(
                fileName: "splash",
                fileExtension: "mov",
                onFinish: onFinish
            )
            .frame(width: 300, height: 300)
            .accessibilityLabel("Lush")
        }
    }
}

#Preview {
    SplashView()
}
