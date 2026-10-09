//
//  AnalysisHistoryView.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 08/10/26.
//


import SwiftUI
import SwiftData

struct AnalysisHistoryView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [UserModel]

    // Chamado ao tocar em "Refazer análise": a Minha área fecha a sheet e abre o fluxo
    var onNewAnalysis: () -> Void = {}

    // Análise marcada na tela (só é salva ao tocar no ✓)
    @State private var selectedID: UUID?

    private var user: UserModel? { users.first }

    private var analyses: [AnalysisModel] {
        user?.completedAnalyses ?? []
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if analyses.isEmpty {
                    ContentUnavailableView(
                        "Nenhuma avaliação ainda",
                        systemImage: "sparkles",
                        description: Text("Faça sua primeira avaliação para ver sua paleta e seu biotipo aqui.")
                    )
                    .padding(.top, 60)
                } else {
                    // Avaliação 1 = a mais recente
                    ForEach(Array(analyses.enumerated()), id: \.element.id) { index, analysis in
                        AnalysisHistoryCard(
                            number: index + 1,
                            analysis: analysis,
                            isSelected: analysis.id == selectedID,
                            onSelect: { selectedID = analysis.id },
                            onNewAnalysis: {
                                dismiss()
                                onNewAnalysis()
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            SheetToolbar(
                title: "Minhas Avaliações",
                isConfirmEnabled: selectedID != nil,
                onClose: { dismiss() },
                onConfirm: {
                    if let user,
                       let chosen = analyses.first(where: { $0.id == selectedID }) {
                        AnalysisService.select(chosen, for: user, in: modelContext)
                    }
                    dismiss()
                }
            )
        }
        // Começa com a análise que o app já usa
        .onAppear {
            if selectedID == nil {
                selectedID = user?.currentAnalysis?.id
            }
        }
    }
}

// MARK: - Card de uma avaliação

private struct AnalysisHistoryCard: View {

    let number: Int
    let analysis: AnalysisModel
    let isSelected: Bool
    let onSelect: () -> Void
    let onNewAnalysis: () -> Void

    private var palette: PaleteSeason {
        PaleteSeason.allCases.first { $0.rawValue == analysis.userPalette.first } ?? .autumnDeep
    }

    private var bodyShape: BodyShape {
        BodyShape(rawValue: analysis.userSilhouette) ?? .hourglass
    }

    var body: some View {
        VStack(spacing: 16) {

            // Seleção, número e data
            Button(action: onSelect) {
                HStack(spacing: 10) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundStyle(Color("titles"))

                    Text("Avaliação \(number)")
                        .font(.body)

                    Spacer()

                    Text(analysis.date.formatted(.dateTime.day(.twoDigits).month(.twoDigits).year()))
                        .font(.callout)
                        .padding(.horizontal, 10)
        
                }
                .foregroundStyle(Color("titles"))
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Avaliação \(number), \(palette.rawValue), \(bodyShape.rawValue)")
            .accessibilityAddTraits(isSelected ? .isSelected : [])

            // Paleta e biotipo (mesma altura)
            HStack(spacing: 12) {
                paletteCard
                bodyShapeCard
            }
            .fixedSize(horizontal: false, vertical: true)

            PrimaryButton(title: "Refazer análise", action: onNewAnalysis)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(
                    LinearGradient(
                        colors: [
                            Color("button").opacity(isSelected ? 0.30 : 0.16),
                            Color("tertiary").opacity(isSelected ? 0.40 : 0.22)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(isSelected ? Color("button").opacity(0.5) : Color("borderLines"), lineWidth: isSelected ? 1.5 : 0.5)
        )
        .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
        .contentShape(RoundedRectangle(cornerRadius: 32))
        .onTapGesture(perform: onSelect)   // tocar em qualquer parte do card também seleciona
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }

    // Card da paleta
    private var paletteCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Sua paleta:")
                .font(.footnote)
                .foregroundStyle(Color("quartenary"))

            Text(palette.rawValue)
                .font(.AppTypography.title3)
                .foregroundStyle(Color("titles"))
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 8)

            PaletteRing(colors: palette.colorPaletes.map { Color($0) })
                .frame(maxWidth: .infinity)

            Spacer(minLength: 8)
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 24).fill(.white))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color("borderLines"), lineWidth: 0.5))
    }

    // Card do biotipo
    private var bodyShapeCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Seu biotipo:")
                .font(.footnote)
                .foregroundStyle(Color("quartenary"))

            Text(bodyShape.rawValue)
                .font(.AppTypography.title3)
                .foregroundStyle(Color("titles"))
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 8)

            Image(bodyShape.resultImageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 128)
                .accessibilityHidden(true)

            Spacer(minLength: 8)
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 24).fill(.white))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color("borderLines"), lineWidth: 0.5))
    }
}

// MARK: - Anel com as cores da paleta

private struct PaletteRing: View {
    let colors: [Color]
    var size: CGFloat = 92
    var lineWidth: CGFloat = 20

    var body: some View {
        ZStack {
            ForEach(colors.indices, id: \.self) { index in
                Circle()
                    .trim(
                        from: CGFloat(index) / CGFloat(colors.count),
                        to: CGFloat(index + 1) / CGFloat(colors.count)
                    )
                    .stroke(colors[index], lineWidth: lineWidth)
            }
        }
        .rotationEffect(.degrees(-90))
        .frame(width: size, height: size)
        .padding(lineWidth / 2)
        .accessibilityHidden(true)
    }
}

#Preview {
    NavigationStack {
        AnalysisHistoryView()
    }
    .modelContainer(for: [UserModel.self, AnalysisModel.self], inMemory: true)
}
