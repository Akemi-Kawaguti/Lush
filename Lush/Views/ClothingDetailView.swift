//
//  ClothingDetailView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 02/10/26.
//

import SwiftUI

struct ClothingDetailView: View {

    @Environment(\.dismiss) private var dismiss

    // Peça
    let name: String
    let category: GarmentCategory
    let photo: UIImage?

    // Biotipo
    let cut: String
    let userBodyShape: String
    let bodyCompatibility: CompatibilityLevel
    let bodyTip: String?

    // Paleta
    let colors: [GarmentColor]
    let userPalette: String
    let colorCompatibility: CompatibilityLevel
    let colorTip: String?

    @State private var isShowingEdit = false

    init(
        name: String = "Vestido longo",
        category: GarmentCategory = .dress,
        photo: UIImage? = nil,
        cut: String = "Evasê",
        userBodyShape: String = "Ampulheta",
        bodyCompatibility: CompatibilityLevel = .high,
        bodyTip: String? = "A modelagem evasê marca a cintura e equilibra quadril e ombros, valorizando a silhueta ampulheta.",
        colors: [GarmentColor] = ClothingDetailView.sampleColors,
        userPalette: String = "Outono Suave",
        colorCompatibility: CompatibilityLevel = .medium,
        colorTip: String? = "Os tons quentes combinam com você. Evite o azul perto do rosto."
    ) {
        self.name = name
        self.category = category
        self.photo = photo
        self.cut = cut
        self.userBodyShape = userBodyShape
        self.bodyCompatibility = bodyCompatibility
        self.bodyTip = bodyTip
        self.colors = colors
        self.userPalette = userPalette
        self.colorCompatibility = colorCompatibility
        self.colorTip = colorTip
    }

    // Cores de exemplo (até ligar a análise de cor)
    static let sampleColors: [GarmentColor] = [
        GarmentColor(color: .yellow, matchesPalette: true),
        GarmentColor(color: .orange, matchesPalette: true),
        GarmentColor(color: .pink, matchesPalette: true),
        GarmentColor(color: .indigo, matchesPalette: false)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    ScreenHeader(title: name, subtitle: "Detalhes da peça")

                    photoView
                        .frame(maxWidth: .infinity)

                    Text("Compatibilidade com você")
                        .font(.AppTypography.title2)
                        .accessibilityAddTraits(.isHeader)
                        .padding(.top, 8)

                    // Biotipo
                    CompatibilitySection(
                        title: "Biotipo",
                        level: bodyCompatibility,
                        footer: bodyTip
                    ) {
                        DetailRow(label: "Modelagem da peça", value: cut)
                        Divider().padding(.horizontal, 16)
                        DetailRow(label: "Seu biotipo", value: userBodyShape)
                    }

                    // Paleta
                    CompatibilitySection(
                        title: "Paleta",
                        level: colorCompatibility,
                        footer: colorTip
                    ) {
                        DetailRow(label: "Cores da peça") {
                            colorDots
                        }
                        Divider().padding(.horizontal, 16)
                        DetailRow(label: "Sua paleta de cor", value: userPalette)
                        Divider().padding(.horizontal, 16)
                        DetailRow(
                            label: "Combinam com você",
                            value: "\(colors.filter(\.matchesPalette).count) de \(colors.count)"
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
                AddClothingView(
                    isEditMode: true,
                    name: name,
                    category: category,
                    photo: photo
                )
            }
        }
    }

    //MARK: - Foto
    @ViewBuilder
    private var photoView: some View {
        let shape = RoundedRectangle(cornerRadius: 24)

        if let photo {
            Image(uiImage: photo)
                .resizable()
                .scaledToFill()
                .frame(width: 345, height: 360)
                .clipShape(shape)
                .accessibilityLabel("Foto de \(name)")
        } else {
            shape
                .fill(.white)
                .frame(width: 345, height: 360)
                .overlay {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 42))
                        .foregroundStyle(Color("quartenary"))
                }
        }
    }

    // MARK: - Bolinhas de cor
    // As que não combinam com a paleta ficam com um "x" branco.
    private var colorDots: some View {
        HStack(spacing: 6) {
            ForEach(colors) { item in
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
        .accessibilityLabel("\(colors.count) cores na peça")
    }
}

#Preview("Alta e média") {
    ClothingDetailView()
}

#Preview("Baixa") {
    ClothingDetailView(
        name: "Calça skinny",
        category: .pants,
        cut: "Skinny",
        userBodyShape: "Triângulo",
        bodyCompatibility: .low,
        bodyTip: "A skinny destaca o quadril e as coxas.",
        colors: [
            GarmentColor(color: .black, matchesPalette: false),
            GarmentColor(color: .gray, matchesPalette: false)
        ],
        colorCompatibility: .low,
        colorTip: "Cores frias apagam o seu tom de pele."
    )
}
