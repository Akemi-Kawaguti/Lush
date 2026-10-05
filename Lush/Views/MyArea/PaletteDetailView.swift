//
//  PaletteDetailView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//

import SwiftUI

struct PaletteDetailView: View {

    @Environment(\.dismiss) private var dismiss

    // Dados de exemplo
    let photoName: String? = nil
    let palette = "Outono Profundo"
    let paletteDescription = "A paleta Outono Profundo é composta por cores quentes, profundas e intensas, que trazem harmonia e equilíbrio para a sua aparência natural."
    let paletteColors: [Color] = [
        Color(red: 0.0, green: 0.52, blue: 0.62),
        Color(red: 0.05, green: 0.36, blue: 0.29),
        Color(red: 0.53, green: 0.08, blue: 0.36),
        Color(red: 0.49, green: 0.13, blue: 0.16),
        Color(red: 0.98, green: 0.52, blue: 0.08),
        Color(red: 0.36, green: 0.26, blue: 0.14)
    ]

    let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // Foto com o anel de cores da paleta
                ZStack {
                    ZStack {
                        ForEach(paletteColors.indices, id: \.self) { index in
                            Circle()
                                .trim(
                                    from: CGFloat(index) / CGFloat(paletteColors.count),
                                    to: CGFloat(index + 1) / CGFloat(paletteColors.count)
                                )
                                .stroke(paletteColors[index], lineWidth: 22)
                        }
                    }
                    .rotationEffect(.degrees(-90))

                    UserPhoto(imageName: "user", size: 128, showsBorder: false)
                }
                .frame(width: 150, height: 150)
                .padding(.top, 8)

                // Card da paleta
                VStack(spacing: 12) {
                    Text("Sua paleta:")
                        .font(.subheadline)
                        .foregroundStyle(Color("textAttention").opacity(0.7))
                    Text(palette)
                        .font(.AppTypography.title2)
                        .foregroundStyle(Color("titles"))
                    Text(paletteDescription)
                        .font(.subheadline)
                        .foregroundStyle(Color("textAttention").opacity(0.5))
                        .multilineTextAlignment(.center)

                    Divider()
                        .frame(width: 120)
                        .padding(.vertical, 4)

                    HStack(spacing: 10) {
                        ForEach(paletteColors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 40, height: 40)
                        }
                    }
                    .padding(.bottom, 4)
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 24).fill(.white))
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color("borderLines"), lineWidth: 0.5))

                Text("Suas características")
                    .font(.AppTypography.title2)
                    .padding(.top, 8)
                    .foregroundStyle(Color("titles"))

                LazyVGrid(columns: columns, spacing: 12) {
                    CharacteristicCard(
                        title: "Temperatura", value: "Quente", icon: "thermometer.medium",
                        description: "Tons quentes e terrosos harmonizam melhor com você."
                    )
                    CharacteristicCard(
                        title: "Luminosidade", value: "Média", icon: "sun.max",
                        description: "Cores de intensidade média equilibram seus traços."
                    )
                    CharacteristicCard(
                        title: "Saturação", value: "Suave", icon: "drop.fill",
                        description: "Tons mais suaves e menos vibrantes te valorizam."
                    )
                    CharacteristicCard(
                        title: "Contraste", value: "Baixo", icon: "circle.lefthalf.filled",
                        description: "Combinações de cores próximas ficam mais harmônicas."
                    )
                }
            }
            .padding(.horizontal, 24)
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
            Toolbar(title: "Paleta de cores", action: nil, onBackClick: { dismiss() })
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        PaletteDetailView()
    }
}
