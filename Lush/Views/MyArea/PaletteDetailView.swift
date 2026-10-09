//
//  PaletteDetailView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//


import SwiftUI
import SwiftData

struct PaletteDetailView: View {

    @Environment(\.dismiss) private var dismiss

    // Usuária do app e a análise escolhida em "Minhas avaliações" (ou a mais recente)
    @Query private var users: [UserModel]

    private var currentAnalysis: AnalysisModel? {
        users.first?.currentAnalysis
    }

    var body: some View {
        
        // Extrai os dados da análise ou usa valores padrão caso ainda não haja análise
                let paletteName = currentAnalysis?.userPalette.first ?? "Outono Profundo"
                let details = PaletteDescriptionProvider.details(for: paletteName)
                
                // Mapeia os nomes das cores do enum PaleteSeason para as Color do SwiftUI
                let colorNames = PaleteSeason.allCases.first { $0.rawValue == paletteName }?.colorPaletes ?? PaleteSeason.autumnDeep.colorPaletes
                let paletteColors: [Color] = colorNames.map { Color($0) }
                
                // Foto do usuário vinda do banco (UserModel associado à análise)
                let userPhotoData = currentAnalysis?.user?.photoData

                return ScrollView {
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

                    // Renderiza a foto do usuário do banco se existir, caso contrário usa a padrão
                                        if let data = userPhotoData, let uiImage = UIImage(data: data) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 128, height: 128)
                                                .clipShape(Circle())
                                        } else {
                                            UserPhoto(imageName: "user", size: 128, showsBorder: false)
                                        }
                }
                .frame(width: 150, height: 150)
                .padding(.top, 8)

                // Card da paleta
                VStack(spacing: 12) {
                    Text("Sua paleta:")
                        .font(.subheadline)
                        .foregroundStyle(Color("textAttention").opacity(0.7))
                    Text(paletteName)
                        .font(.AppTypography.title2)
                        .foregroundStyle(Color("titles"))
                    Text(details.description)
                        .font(.subheadline)
                        .foregroundStyle(Color("textAttention").opacity(0.5))
                        .multilineTextAlignment(.center)

                    Divider()
                        .frame(width: 120)
                        .padding(.vertical, 4)

                    // As bolinhas encolhem se não couberem (até 40 de diâmetro)
                    HStack(spacing: 8) {
                        ForEach(paletteColors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(maxWidth: 40)
                                .aspectRatio(1, contentMode: .fit)
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

                LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                    CharacteristicCard(
                                            title: "Temperatura", value: details.temperature, icon: "thermometer.medium",
                                            description: details.temperatureDesc
                                        )
                                        CharacteristicCard(
                                            title: "Luminosidade", value: details.brightness, icon: "sun.max",
                                            description: details.brightnessDesc
                                        )
                                        CharacteristicCard(
                                            title: "Saturação", value: details.saturation, icon: "drop.fill",
                                            description: details.saturationDesc
                                        )
                                        CharacteristicCard(
                                            title: "Contraste", value: details.contrast, icon: "circle.lefthalf.filled",
                                            description: details.contrastDesc
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
            .modelContainer(for: [AnalysisModel.self, UserModel.self], inMemory: true)
    }
}
