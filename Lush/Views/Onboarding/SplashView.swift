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
    
    private let duration: Double = 3.0
    
    private let textDelay: Double = 0.6
    private let textDuration: Double = 0.8
    
    @State private var showText = false
    @State private var hasFinished = false
    
    var body: some View {
        ZStack {
            Image("backgroundScreen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                VideoPlayerView(
                    fileName: "splash",
                    fileExtension: "mov",
                    onFinish: finish
                )
                .frame(width: 300, height: 150)
                .accessibilityLabel("Lush")

                Text("Descubra seu estilo")
                    .font(.callout)
                    .foregroundStyle(Color("lightText"))
                    .mask(alignment: .leading) {
                        Rectangle()
                            .scaleEffect(x: showText ? 1 : 0, anchor: .leading)
                    }
                    .opacity(showText ? 1 : 0)
                    .padding(.top, -30)
            }
            .padding(.bottom, 80)
        }
        .onAppear {
            withAnimation(.easeOut(duration: textDuration).delay(textDelay)) {
                showText = true
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(duration))
            finish()
        }
    
    }
    
    private func finish() {
        guard !hasFinished else { return }
        hasFinished = true
        onFinish()
    }
}

#Preview {
    SplashView()
}
