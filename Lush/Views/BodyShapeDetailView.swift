//
//  BodyShapeDetailView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//

import SwiftUI

struct BodyShapeDetailView: View {

    @Environment(\.dismiss) private var dismiss

    // Dados de exemplo
    let bodyShape: BodyShape = .hourglass
    let features: [(title: String, description: String, imageName: String)] = [
        ("Ombros", "Alinhados com o quadril.", "ombros"),
        ("Cintura", "Bem definida e marcada.", "cintura"),
        ("Quadril", "Proporcional aos ombros.", "quadril")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // Card do biotipo
                VStack(spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        Image(bodyShape.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                            .frame(height: 284, alignment: .top)
                            .clipped()
                            .background(.white)

                        // Ícone desenhado pela designer (ampulhetaIcon, trianguloIcon...)
                        Image(bodyShape.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 52, height: 52)
                            .padding(20)
                    }

                    VStack(spacing: 12) {
                        Text("Seu biotipo é:")
                            .font(.subheadline)
                        Text(bodyShape.rawValue)
                            .font(.AppTypography.title)
                            .padding(.bottom, 4)

                        Text(bodyShape.description)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.25), radius: 2, y: 1)   // contraste do texto
                    .padding(24)
                    .background {
                        Image("cardBodyShape")
                            .resizable()
                            .scaledToFill()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 32))
                .overlay(RoundedRectangle(cornerRadius: 32).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                .padding(.horizontal, 24)
                .padding(.top, 10)

                // Título mais perto dos cards
                VStack(spacing: 12) {
                    Text("Suas características")
                        .font(.AppTypography.title2)

                    // Carrossel de características
                    ScrollView(.horizontal) {
                        HStack(spacing: 12) {
                            ForEach(features, id: \.title) { feature in
                                BodyFeatureCard(
                                    imageName: feature.imageName,
                                    title: feature.title,
                                    description: feature.description
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .scrollIndicators(.hidden)
                    .defaultScrollAnchor(.center)   // abre com o card do meio (Cintura)
                }
            }
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .toolbar {
            Toolbar(title: "Biotipo de silhueta", action: nil, onBackClick: { dismiss() })
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)   // tira o espaço grande abaixo da toolbar
    }
}

#Preview {
    NavigationStack {
        BodyShapeDetailView()
    }
}
