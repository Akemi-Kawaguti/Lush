//
//  ClothingDetailView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 02/10/26.
//

import SwiftUI
import SwiftData

struct ClothingDetailView: View {

    @Environment(\.dismiss) private var dismiss
    
    // Conecta com o SwiftData para buscar o usuário atual e suas análises de biotipo/paleta
    @Query private var users: [UserModel]

    var currentUser: UserModel? {
        users.first
    }

    // Recebe a peça de roupa selecionada do SwiftData
    let clothingItem: ClothesModel
    @State private var isShowingEdit = false

    // Inicializador que recebe a peça real
    init(clothingItem: ClothesModel) {
        self.clothingItem = clothingItem
    }

    // Helper para extrair o texto descritivo do corte, independente se é Top, Bottom ou OnePiece
    private var cutDescription: String {
        if let cutTop = clothingItem.cutTop {
            return formattedCutName(cutTop.rawValue)
        } else if let cutBottom = clothingItem.cutBottom {
            return formattedCutName(cutBottom.rawValue)
        } else if let cutOnePiece = clothingItem.cutOnePiece {
            return formattedCutName(cutOnePiece.rawValue)
        }

        return "Não especificado"
    }

    private func formattedCutName(_ rawValue: String) -> String {
        let specialNames: [String: String] = [
            "traditional": "Tradicional",
            "fitted": "Justa",
            "oversized": "Oversized",
            "cropped": "Cropped",
            "flowy": "Fluida",
            "slim": "Slim",
            "boxy": "Boxy",
            "longline": "Longline",
            "baby_look": "Baby look",
            "raglan": "Raglan",
            "peplum": "Peplum",
            "asymmetric": "Assimétrica",
            "ultra_cropped": "Ultra cropped",
            "tube": "Tubinho/Faixa",
            "halter": "Frente única",
            "tie": "Amarração/Nó",
            "high_cut": "Cavado",
            "wrap": "Transpassado",
            "flare": "Flare",
            "jogger": "Jogger",
            "straight": "Reta",
            "skinny": "Skinny",
            "wide_leg": "Wide Leg",
            "tailored": "Alfaiataria",
            "godet": "Godê",
            "pencil": "Lápis",
            "pleated": "Plissada",
            "cargo": "Cargo",
            "a_line": "Evasê",
            "bodycon": "Ajustado",
            "pantalona": "Pantalona"
        ]

        let suffix = rawValue.split(separator: "_", maxSplits: 1)
            .dropFirst()
            .joined(separator: "_")

        return specialNames[suffix] ?? suffix
            .replacingOccurrences(of: "_", with: " ")
            .capitalized
    }
    // Dados dinâmicos baseados no perfil do usuário e na análise mais recente
    private var userBodyShapeText: String {
        currentUser?.analysis.first?.userSilhouette ?? "Não definido"
    }

    private var userPaletteText: String {
        if let paletteArray = currentUser?.analysis.first?.userPalette, let firstPalette = paletteArray.first {
            return firstPalette
        }
        return "Não definida"
    }

    // Exemplo de lógica de compatibilidade de biotipo
    private var calculatedBodyCompatibility: CompatibilityLevel {
        return .high
    }
    
    private var bodyTipText: String {
        return "A modelagem \(cutDescription.lowercased()) interage com o seu biotipo \(userBodyShapeText.lowercased()), valorizando a silhueta."
    }

    private var garmentColors: [GarmentColor] {
        clothingItem.predominantColors.compactMap { hex in
            guard let uiColor = UIColor(hex: hex) else {
                return nil
            }

            return GarmentColor(
                color: Color(uiColor: uiColor),
                matchesPalette: true
            )
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                ScreenHeader(title: clothingItem.name, subtitle: "Detalhes da peça")

                photoView
                    .frame(maxWidth: .infinity)

                Text("Compatibilidade com você")
                    .font(.AppTypography.title2)
                    .foregroundStyle(Color("titles"))
                    .accessibilityAddTraits(.isHeader)
                    .padding(.top, 8)

                // Biotipo
                CompatibilitySection(
                    title: "Biotipo",
                    level: calculatedBodyCompatibility,
                    footer: bodyTipText
                ) {
                    DetailRow(label: "Modelagem da peça", value: cutDescription)
                    Divider().padding(.horizontal, 16)
                    DetailRow(label: "Seu biotipo", value: userBodyShapeText)
                }

                // Paleta
                CompatibilitySection(
                    title: "Paleta",
                    level: calculatedBodyCompatibility,
                    footer: bodyTipText
                ) {
                    DetailRow(label: "Cores da peça") {
                        colorDots
                    }
                    Divider().padding(.horizontal, 16)
                    DetailRow(label: "Sua paleta de cor", value: userPaletteText)
                    Divider().padding(.horizontal, 16)
                    DetailRow(
                        label: "Combinam com você",
                        value: "\(garmentColors.filter(\.matchesPalette).count) de \(garmentColors.count)"
                    )
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .scrollIndicators(.hidden)
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .toolbar {
            Toolbar(
                action: .edit,
                onBackClick: { dismiss() },
                onActionClick: { isShowingEdit = true }
            )
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isShowingEdit) {
            NavigationStack {
                AddClothingView(
                    isEditMode: true,
                    name: clothingItem.name,
                    category: clothingItem.garmentCategory,
                    photo: clothingItem.photo != nil ? UIImage(data: clothingItem.photo!) : nil
                )
            }
        }
    }

    //MARK: - Foto
    @ViewBuilder
    private var photoView: some View {
        let shape = RoundedRectangle(cornerRadius: 24)

        if let photoData = clothingItem.photo, let uiImage = UIImage(data: photoData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 345, height: 360)
                .clipShape(shape)
                .accessibilityLabel("Foto de \(clothingItem.name)")
        } else {
            shape
                .fill(.white)
                .frame(width: 345, height: 360)
                .overlay {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 42))
                        .foregroundStyle(Color("quartenary"))
                }
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color("borderLines"), lineWidth: 0.5))
        }
    }

    // MARK: - Bolinhas de cor
    private var colorDots: some View {
        HStack(spacing: 6) {
            ForEach(garmentColors) { item in
                Circle()
                    .fill(item.color)
                    .frame(width: 24, height: 24)
                    .overlay {
                        if !item.matchesPalette {
                            Image(systemName: "xmark")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
            }
        }
        .accessibilityLabel("\(garmentColors.count) cores na peça")
    }
}

