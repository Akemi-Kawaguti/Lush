//
//  ResultView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 04/10/26.
//

import SwiftUI

struct ResultView: View {

    @Environment(\.dismiss) private var dismiss

    let palette: PalleteSeason
    let bodyShape: BodyShape
    var onExplore: () -> Void = {}

    @State private var showUserIntro = false   // novo

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                Text("Parabéns! Você está a um passo à frente na sua jornada de descoberta de estilo pessoal.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)

                paletteCard
                bodyShapeCard
                meaningCard
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        // Botão fixo embaixo
        .safeAreaInset(edge: .bottom) {
            PrimaryButton(title: "Explorar meu estilo") {
                showUserIntro = true   // novo: abre a tela "Sobre você"
            }
            .padding(.bottom, 16)
        }
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .toolbar {
            Toolbar(title: "Seu Resultado", action: nil, onBackClick: { dismiss() })
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        // novo: tela opcional de nome e foto
        .navigationDestination(isPresented: $showUserIntro) {
            UserIntroView { name, photo in
                // TODO: salvar nome e foto no UserModel e ir para a Home
                onExplore()
            }
        }
    }

    // Card da paleta
    var paletteCard: some View {
        VStack(spacing: 4) {
            Text("Sua paleta")
                .font(.body)
                .foregroundStyle(.black.opacity(0.7))
            Text(palette.rawValue)
                .font(.AppTypography.title2)

            HStack(spacing: 12) {
                ForEach(palette.colorPalletes.prefix(6), id: \.self) { colorName in
                    Circle()
                        .fill(Color(colorName))
                        .frame(width: 38, height: 38)
                }
            }
            .padding(.top, 16)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 32).fill(.white.opacity(0.8)))
        .overlay(RoundedRectangle(cornerRadius: 32).strokeBorder(Color.gray.opacity(0.3), lineWidth: 1))
    }

    // Card do biotipo
    var bodyShapeCard: some View {
        HStack(spacing: 16) {
            Image(bodyShape.resultImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 150)

            VStack(alignment: .leading, spacing: 4) {
                Text("Seu Biotipo")
                    .font(.body)
                    .foregroundStyle(.black.opacity(0.7))
                Text(bodyShape.rawValue)
                    .font(.AppTypography.title2)
                    .padding(.bottom, 18)

                Text(bodyShape.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .overlay(alignment: .topTrailing) {
            Image(bodyShape.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(20)
        }
        .background(RoundedRectangle(cornerRadius: 32).fill(.white.opacity(0.8)))
        .overlay(RoundedRectangle(cornerRadius: 32).strokeBorder(Color.gray.opacity(0.3), lineWidth: 1))
    }

    // Card "O que isso significa?"
    var meaningCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("O que isso significa?")
                .font(.AppTypography.title3)
            Text(bodyShape.meaning)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 32).fill(.white.opacity(0.8)))
        .overlay(RoundedRectangle(cornerRadius: 32).strokeBorder(Color.gray.opacity(0.3), lineWidth: 1))
    }
}

#Preview {
    NavigationStack {
        ResultView(palette: .autumnDeep, bodyShape: .hourglass)
    }
}

