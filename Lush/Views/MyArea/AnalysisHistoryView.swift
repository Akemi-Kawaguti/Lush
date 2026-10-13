//
//  AnalysisHistoryView.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 08/10/26.
//


//  "Minhas avaliações": lista as avaliações da usuária.
//  - A avaliação "Em uso" define a paleta e o biotipo usados no app inteiro
//  - "Usar esta avaliação" troca na hora (sem botão de confirmar)
//  - Menu "..." de cada card: Renomear e Excluir
//  - Numeração pela ordem de criação: a primeira feita é a "Avaliação 1"
//  - "+" na barra abre uma nova avaliação
//  Tela empurrada a partir da Minha área (não é sheet).
//

import SwiftUI
import SwiftData

struct AnalysisHistoryView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [UserModel]

    // Chamado ao tocar em "+": a Minha área abre o fluxo de avaliação por cima desta tela
    var onNewAnalysis: () -> Void = {}

    // Alertas de renomear e excluir
    @State private var analysisToRename: AnalysisModel?
    @State private var newName = ""
    @State private var analysisToDelete: AnalysisModel?

    private var user: UserModel? { users.first }

    // Lista: da mais recente para a mais antiga
    private var analyses: [AnalysisModel] {
        user?.completedAnalyses ?? []
    }

    // Avaliação usada no app agora
    private var activeID: UUID? {
        user?.currentAnalysis?.id
    }

    // Número de cada avaliação pela ordem de criação (a mais antiga é a 1)
    private var numbers: [UUID: Int] {
        let oldestFirst = analyses.sorted { $0.date < $1.date }
        var result: [UUID: Int] = [:]
        for (index, analysis) in oldestFirst.enumerated() {
            result[analysis.id] = index + 1
        }
        return result
    }

    private func displayName(of analysis: AnalysisModel) -> String {
        if let name = analysis.customName, !name.isEmpty {
            return name
        }
        return "Avaliação \(numbers[analysis.id] ?? 1)"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                ScreenHeader(
                    title: "Minhas avaliações",
                    subtitle: "Escolha qual avaliação o Lush usa para você"
                )

                if analyses.isEmpty {
                    ContentUnavailableView(
                        "Nenhuma avaliação ainda",
                        systemImage: "sparkles",
                        description: Text("Faça sua primeira avaliação para ver sua paleta e seu biotipo aqui.")
                    )
                    .padding(.top, 60)
                } else {
                    explanation

                    ForEach(analyses) { analysis in
                        AnalysisHistoryCard(
                            name: displayName(of: analysis),
                            analysis: analysis,
                            isActive: analysis.id == activeID,
                            canDelete: analyses.count > 1,
                            onUse: { use(analysis) },
                            onRename: {
                                newName = analysis.customName ?? ""
                                analysisToRename = analysis
                            },
                            onDelete: { analysisToDelete = analysis }
                        )
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 24)
            .animation(.easeInOut(duration: 0.25), value: activeID)
        }
        .scrollIndicators(.hidden)
        .lushBackground()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Voltar e "+" (nova avaliação), como nas outras telas
            Toolbar(
                action: .add,
                onBackClick: { dismiss() },
                onActionClick: onNewAnalysis
            )
        }
        .navigationBarBackButtonHidden(true)
        // Vibração leve ao trocar a avaliação em uso
        .sensoryFeedback(.selection, trigger: activeID)

        // Renomear
        .alert("Renomear avaliação", isPresented: isRenaming) {
            TextField("Nome da avaliação", text: $newName)
            Button("Cancelar", role: .cancel) {}
            Button("Salvar") {
                if let analysis = analysisToRename {
                    AnalysisService.rename(analysis, to: newName, in: modelContext)
                }
            }
        } message: {
            Text("Deixe em branco para voltar ao nome padrão.")
        }

        // Excluir (com confirmação)
        .alert(
            "Excluir \(analysisToDelete.map { displayName(of: $0) } ?? "avaliação")?",
            isPresented: isDeleting
        ) {
            Button("Cancelar", role: .cancel) {}
            Button("Excluir", role: .destructive) {
                if let user, let analysis = analysisToDelete {
                    AnalysisService.delete(analysis, from: user, in: modelContext)
                }
            }
        } message: {
            if analysisToDelete?.id == activeID {
                Text("Esta é a avaliação em uso. O app passará a usar a avaliação mais recente. Essa ação não pode ser desfeita.")
            } else {
                Text("Essa ação não pode ser desfeita.")
            }
        }
    }

    // MARK: - Explicação no topo

    private var explanation: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "sparkles")
                .font(.title3)
                .foregroundStyle(Color("button"))
                .accessibilityHidden(true)

            Text("A avaliação **em uso** define a paleta, o biotipo, as sugestões de looks e a compatibilidade das suas roupas em todo o app.")
                .font(.subheadline)
                .foregroundStyle(Color("textAttention"))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 20).fill(.white.opacity(0.7)))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color("borderLines"), lineWidth: 0.5))
    }

    // MARK: - Ações

    private func use(_ analysis: AnalysisModel) {
        guard let user else { return }
        AnalysisService.select(analysis, for: user, in: modelContext)
    }

    // Bindings dos alertas
    private var isRenaming: Binding<Bool> {
        Binding(
            get: { analysisToRename != nil },
            set: { if !$0 { analysisToRename = nil } }
        )
    }

    private var isDeleting: Binding<Bool> {
        Binding(
            get: { analysisToDelete != nil },
            set: { if !$0 { analysisToDelete = nil } }
        )
    }
}

// MARK: - Card de uma avaliação

private struct AnalysisHistoryCard: View {

    let name: String
    let analysis: AnalysisModel
    let isActive: Bool
    let canDelete: Bool
    let onUse: () -> Void
    let onRename: () -> Void
    let onDelete: () -> Void

    private var palette: PaleteSeason {
        PaleteSeason.allCases.first { $0.rawValue == analysis.userPalette.first } ?? .autumnDeep
    }

    private var bodyShape: BodyShape {
        BodyShape(rawValue: analysis.userSilhouette) ?? .hourglass
    }

    private var dateText: String {
        analysis.date.formatted(.dateTime.day(.twoDigits).month(.twoDigits).year())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // Nome, selo "Em uso", data e menu
            HStack(alignment: .top, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(name)
                            .font(.AppTypography.title3)
                            .foregroundStyle(Color("titles"))
                            .lineLimit(1)

                        if isActive {
                            activeBadge
                        }
                    }

                    Text("Feita em \(dateText)")
                        .font(.footnote)
                        .foregroundStyle(Color("quartenary"))
                }

                Spacer(minLength: 0)

                Menu {
                    Button(action: onRename) {
                        Label("Renomear", systemImage: "pencil")
                    }
                    Button(role: .destructive, action: onDelete) {
                        Label("Excluir", systemImage: "trash")
                    }
                    .disabled(!canDelete)
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .foregroundStyle(Color("titles"))
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .accessibilityLabel("Opções de \(name)")
            }

            // Paleta e biotipo (mesma altura)
            HStack(spacing: 12) {
                paletteCard
                bodyShapeCard
            }
            .fixedSize(horizontal: false, vertical: true)

            // Rodapé: em uso ou botão para usar
            if isActive {
                Text("Sua paleta e seu biotipo no app vêm desta avaliação.")
                    .font(.footnote)
                    .foregroundStyle(Color("textAttention").opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            } else {
                Button(action: onUse) {
                    Text("Usar esta avaliação")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Color("button"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Capsule().fill(.white))
                        .overlay(Capsule().stroke(Color("button"), lineWidth: 1.5))
                }
                .buttonStyle(.plain)
                .accessibilityHint("A paleta e o biotipo do app passam a ser os desta avaliação")
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(
                    LinearGradient(
                        colors: [
                            Color("button").opacity(isActive ? 0.30 : 0.10),
                            Color("tertiary").opacity(isActive ? 0.40 : 0.15)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(isActive ? Color("button") : Color("borderLines"), lineWidth: isActive ? 2 : 0.5)
        )
        .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(name), \(isActive ? "em uso, " : "")\(palette.rawValue), \(bodyShape.rawValue)")
    }

    // Selo "Em uso"
    private var activeBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark")
                .font(.caption2.weight(.bold))
            Text("Em uso")
                .font(.caption.weight(.semibold))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(Capsule().fill(Color("button")))
    }

    // Card da paleta
    private var paletteCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Paleta:")
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
            Text("Biotipo:")
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
