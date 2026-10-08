//
//  AnalysisHistoryView.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 08/10/26.
//

import SwiftUI

struct AnalysisHistoryView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var selectedAnalysisID: UUID?

    private let analyses = [
        MockAnalysis(
            title: "Avaliação 1",
            date: "28/09/2026",
            palette: "Outono Profundo",
            bodyShape: "Ampulheta",
            bodyShapeImage: "ampulheta"
        ),
        MockAnalysis(
            title: "Avaliação 2",
            date: "12/04/2026",
            palette: "Primavera Clara",
            bodyShape: "Triângulo Invertido",
            bodyShapeImage: "trianguloinvertido"
        )
    ]

    var body: some View {
        VStack(spacing: 0) {

            header
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 16)

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(analyses) { analysis in
                        analysisCard(analysis)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
        }
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            if selectedAnalysisID == nil {
                selectedAnalysisID = analyses.first?.id
            }
        }
    }

    private var header: some View {
        HStack(spacing: 0) {

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color("titles"))
                    .frame(width: 48, height: 48)
                    .background(.white.opacity(0.85))
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(
                                Color("borderLines"),
                                lineWidth: 0.5
                            )
                    }
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Minhas Avaliações")
                .font(.AppTypography.title3)
                .foregroundStyle(Color("titles"))

            Spacer()

            Button {
                dismiss()
            } label: {
                Image(systemName: "checkmark")
                    .font(.system(size: 21, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(Color("button"))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Analysis Card

    private func analysisCard(
        _ analysis: MockAnalysis
    ) -> some View {

        let isSelected = selectedAnalysisID == analysis.id

        return VStack(spacing: 12) {

            // Título + data
            HStack(spacing: 8) {

                Button {
                    selectedAnalysisID = analysis.id
                } label: {
                    Image(
                        systemName: isSelected
                        ? "checkmark.circle.fill"
                        : "circle"
                    )
                    .font(.system(size: 22))
                    .foregroundStyle(.black)
                }
                .buttonStyle(.plain)

                Text(analysis.title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color("titles"))

                Spacer()

                Text(analysis.date)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color("titles"))
            }

            // Resultados
            HStack(spacing: 9) {

                paletteResultCard(
                    palette: analysis.palette
                )

                bodyShapeResultCard(
                    bodyShape: analysis.bodyShape,
                    imageName: analysis.bodyShapeImage
                )
            }

            // Refazer
            PrimaryButton(title: "Refazer análise") {
                // Por enquanto é apenas visual.
                // O fluxo será conectado quando a persistência
                // estiver implementada.
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 12)
        .padding(.bottom, 10)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.white.opacity(0.48))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    Color("borderLines"),
                    lineWidth: 0.5
                )
        }
    }

    // MARK: - Palette Card

    private func paletteResultCard(
        palette: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 8) {

            Text("Sua paleta:")
                .font(.system(size: 15))
                .foregroundStyle(
                    Color("textAttention").opacity(0.7)
                )

            Text(palette)
                .font(.AppTypography.title3)
                .foregroundStyle(Color("titles"))
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )

            Spacer(minLength: 8)

            paletteWheel(for: palette)
                .frame(maxWidth: .infinity)
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .frame(height: 250)
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    Color("borderLines"),
                    lineWidth: 0.5
                )
        }
    }

    // MARK: - Body Shape Card

    private func bodyShapeResultCard(
        bodyShape: String,
        imageName: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 8) {

            Text("Seu biotipo:")
                .font(.system(size: 15))
                .foregroundStyle(
                    Color("textAttention").opacity(0.7)
                )

            Text(bodyShape)
                .font(.AppTypography.title3)
                .foregroundStyle(Color("titles"))
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )

            Spacer(minLength: 4)

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 168)
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .frame(height: 250)
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    Color("borderLines"),
                    lineWidth: 0.5
                )
        }
    }

    // MARK: - Color Wheel

    private func paletteWheel(
        for paletteName: String
    ) -> some View {

        let paletteColors: [Color] = {

            guard let season = PaleteSeason.allCases.first(
                where: { $0.rawValue == paletteName }
            ) else {
                return PaleteSeason.autumnDeep.colorPaletes.map {
                    Color($0)
                }
            }

            return season.colorPaletes.map {
                Color($0)
            }
        }()

        return ZStack {

            ForEach(
                paletteColors.indices,
                id: \.self
            ) { index in

                Circle()
                    .trim(
                        from: CGFloat(index) /
                            CGFloat(paletteColors.count),

                        to: CGFloat(index + 1) /
                            CGFloat(paletteColors.count)
                    )
                    .stroke(
                        paletteColors[index],
                        lineWidth: 28
                    )
            }

            Circle()
                .fill(.white)
                .frame(
                    width: 72,
                    height: 72
                )
        }
        .rotationEffect(.degrees(-90))
        .frame(
            width: 105,
            height: 105
        )
    }
}

// MARK: - Mock Data

private struct MockAnalysis: Identifiable {

    let id = UUID()

    let title: String
    let date: String
    let palette: String
    let bodyShape: String
    let bodyShapeImage: String
}

#Preview {
    AnalysisHistoryView()
        .presentationDetents([.fraction(0.88)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(32)
}
