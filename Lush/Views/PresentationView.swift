//
//  PresentationView.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 29/09/26.
//

import SwiftUI

struct PresentationView: View {

    var body: some View {
        ZStack {

            Image("presentationImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ZStack {
                Image("presentationImage")
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 18)

                Color.gray.opacity(0.35)
            }
            .mask {
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0.50),
                        .init(color: .black, location: 0.68),
                        .init(color: .black, location: 1.0)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .ignoresSafeArea()

            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.45),
                    .init(color: .black.opacity(0.75), location: 0.78),
                    .init(color: .black.opacity(0.9), location: 1.0)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(alignment: .leading) {

                Spacer()

                VStack(alignment: .leading, spacing: 20) {

                    Text("Seja bem-vinda\nao app Lush!")
                        .font(.AppTypography.largeTitle)
                        .foregroundStyle(.white)

                    Text("""
                    O Lush ajuda você a descobrir sua paleta de cores ideal e seu biotipo corporal de forma totalmente personalizada para que faça escolhas de looks assertivas e elegantes.
                    """)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.white)
                    .lineSpacing(4)

                    HStack {
                        Spacer()

                        PrimaryButton(title: "Continuar") {
                            print("Continuar")
                        }

                        Spacer()
                    }
                    .padding(.top, 18)
                }
                .padding(.horizontal, 36)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    PresentationView()
}
