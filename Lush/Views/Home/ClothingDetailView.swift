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
    @Environment(\.modelContext) private var modelContext
    
    // Conecta com o SwiftData para buscar o usuário atual e suas análises de biotipo/paleta
    @Query private var users: [UserModel]

    var currentUser: UserModel? {
        users.first
    }

    // Recebe a peça de roupa selecionada do SwiftData
    let clothingItem: ClothesModel

    /// Ação do botão voltar. Vindo do cadastro, fecha o cadastro inteiro; senão, só volta.
    var onClose: (() -> Void)?

    @State private var isShowingEdit = false
    @State private var isShowingDeleteConfirmation = false

    // Inicializador que recebe a peça real
    init(clothingItem: ClothesModel, onClose: (() -> Void)? = nil) {
        self.clothingItem = clothingItem
        self.onClose = onClose
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
        currentUser?.currentAnalysis?.userSilhouette ?? "Não definido"
    }

    private var userPaletteText: String {
        if let paletteArray = currentUser?.currentAnalysis?.userPalette, let firstPalette = paletteArray.first {
            return firstPalette
        }
        return "Não definida"
    }

    // Biotipo e paleta da análise atual (nil se ainda não houver análise)
    private var userBodyShape: BodyShape? {
        currentUser?.currentAnalysis == nil ? nil : currentUser?.currentBodyShape
    }

    private var userPalette: PaleteSeason? {
        currentUser?.currentAnalysis == nil ? nil : currentUser?.currentPalette
    }

    // Compatibilidade calculada pelo CompatibilityService
    private var bodyResult: CompatibilityService.BodyResult {
        CompatibilityService.bodyCompatibility(of: clothingItem, with: userBodyShape)
    }

    private var paletteResult: CompatibilityService.PaletteResult {
        CompatibilityService.paletteCompatibility(of: clothingItem, with: userPalette)
    }

    private var garmentColors: [GarmentColor] {
        paletteResult.colors
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                ScreenHeader(title: clothingItem.name, subtitle: clothingItem.garmentCategory.rawValue)

                photoView
                    .frame(maxWidth: .infinity)

                Text("Compatibilidade com você")
                    .font(.AppTypography.title2)
                    .foregroundStyle(Color("titles"))
                    .accessibilityAddTraits(.isHeader)
                    .padding(.top, 8)

                // Biotipo
                let bodyCompat = bodyResult
                CompatibilitySection(
                    title: "Biotipo",
                    level: bodyCompat.level,
                    footer: bodyCompat.explanation
                ) {
                    DetailRow(label: "Modelagem da peça", value: cutDescription)
                    Divider().padding(.horizontal, 16)
                    DetailRow(label: "Seu biotipo", value: userBodyShapeText)
                }

                // Paleta
                let paletteCompat = paletteResult
                CompatibilitySection(
                    title: "Paleta",
                    level: paletteCompat.level,
                    footer: paletteCompat.explanation
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
        .lushBackground()
        .toolbar {
            // Excluir, à esquerda do editar
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                        .fontWeight(.semibold)
                        .frame(width: 32, height: 32)
                        .contentShape(Circle())
                }
                .buttonStyle(.glassProminent)
                .tint(Color("quartenary"))   // círculo cinza: ação secundária, ao lado do editar
                .accessibilityLabel("Excluir roupa")
            }

            // Separa os dois botões (cada um no seu círculo)
            ToolbarSpacer(.fixed, placement: .topBarTrailing)

            Toolbar(
                action: .edit,
                onBackClick: { close() },
                onActionClick: { isShowingEdit = true }
            )
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isShowingEdit) {
            NavigationStack {
                AddClothingView(
                    isEditMode: true,
                    clothingToEdit: clothingItem
                )
            }
        }
        .confirmationDialog(
            "Excluir esta roupa?",
            isPresented: $isShowingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Excluir", role: .destructive) {
                deleteClothing()
            }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("Essa ação não pode ser desfeita.")
        }
    }

    private func close() {
        if let onClose {
            onClose()
        } else {
            dismiss()
        }
    }

    // Exclusão: sai da tela de detalhes e só então apaga a peça
    // (apagar antes faria esta tela tentar ler uma peça que não existe mais)
    private func deleteClothing() {
        let clothing = clothingItem
        let context = modelContext
        close()

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(500))
            ClothingService.deleteClothing(clothing, in: context)
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
