//
//  GarmentAnalysisTestView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 02/10/26.
//

//
//  Tela TEMPORÁRIA que simula o fluxo de cadastro de roupa para TESTAR os
//  classificadores: Parte → Categoria → Foto → ✓ → resultado da modelagem.
//  Depois de cada teste, marque qual era a modelagem certa e toque em
//  "Registrar teste": a tela monta a tabela de acertos por categoria
//  e permite exportar em texto (botão de compartilhar).
//
//  ⚠️ Rode em um iPhone de verdade (no simulador o Vision não funciona).
//  ⚠️ Os resultados ficam só na memória: fechar o app apaga a lista.
//  Apagar este arquivo antes de subir para a loja.
//

import SwiftUI

struct GarmentAnalysisTestView: View {

    // Só as três partes do fluxo de cadastro (sem "Sobreposição")
    private let positions: [GarmentPosition] = [.top, .bottom, .onePiece]

    @State private var image: UIImage?
    @State private var position: GarmentPosition?
    @State private var category: GarmentCategory?

    @State private var analysis: GarmentAnalysis?
    @State private var errorMessage: String?
    @State private var isAnalyzing = false

    @State private var actualLabel = ""
    @State private var records: [TestRecord] = []

    private var categories: [GarmentCategory] {
        guard let position else { return [] }
        return GarmentCategory.allCases.filter { $0.position == position }
    }

    private var canAnalyze: Bool {
        image != nil && category?.classifierModelName != nil && !isAnalyzing
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header

                PhotoPicker(
                    image: $image,
                    title: "Adicione uma foto da sua peça de roupa",
                    width: 320,
                    height: 380
                )
                .frame(maxWidth: .infinity)

                pickers
                resultSection
                summarySection
            }
            .padding()
        }
        .onChange(of: position) {
            category = nil
            analysis = nil
        }
        .onChange(of: category) { analysis = nil }
        .onChange(of: image) { analysis = nil }
    }

    // MARK: - Cabeçalho com o botão ✓

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Testar análise")
                    .font(.largeTitle.bold())
                Text("Simula o cadastro e mostra o que o classificador identificou.")
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: analyze) {
                Image(systemName: "checkmark")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(Circle().fill(canAnalyze ? Color.pink : Color.gray.opacity(0.5)))
            }
            .disabled(!canAnalyze)
        }
    }

    // MARK: - Pickers Parte → Categoria

    private var pickers: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Selecione a parte").font(.headline)
                Picker("Parte", selection: $position) {
                    Text("Selecione a parte…").tag(GarmentPosition?.none)
                    ForEach(positions, id: \.self) { item in
                        Text(item.rawValue).tag(Optional(item))
                    }
                }
                .pickerStyle(.menu)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Categoria").font(.headline)
                Picker("Categoria", selection: $category) {
                    Text("Selecione uma categoria").tag(GarmentCategory?.none)
                    ForEach(categories, id: \.self) { item in
                        Text(item.rawValue).tag(Optional(item))
                    }
                }
                .pickerStyle(.menu)
                .disabled(position == nil)
            }

            if let category, category.classifierModelName == nil {
                Text("Ainda não há classificador para \(category.rawValue).")
                    .font(.footnote)
                    .foregroundStyle(.orange)
            } else if image == nil || category == nil {
                Text("Escolha a foto, a parte e a categoria e toque no ✓.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Resultado da análise

    @ViewBuilder
    private var resultSection: some View {
        if isAnalyzing {
            ProgressView("Analisando a peça…")
                .frame(maxWidth: .infinity)
        } else if let errorMessage {
            Text(errorMessage)
                .foregroundStyle(.red)
        } else if let analysis, let best = analysis.best {
            VStack(alignment: .leading, spacing: 12) {
                Text("Resultado").font(.title3.bold())

                // O que a usuária veria no app
                HStack {
                    Text("Modelagem").foregroundStyle(.secondary)
                    Spacer()
                    if analysis.isConfident {
                        Text(best.label).bold()
                    } else if let second = analysis.second {
                        Text("\(best.label) ou \(second.label)?").bold()
                    }
                }

                Divider()

                // Detalhe técnico para avaliar o modelo
                Text("Top 3 – \(analysis.modelName)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                ForEach(analysis.predictions) { prediction in
                    HStack {
                        Text(prediction.label)
                        Spacer()
                        Text(percent(prediction.confidence))
                            .foregroundStyle(.secondary)
                    }
                }

                Divider()

                // Avaliação manual
                Text("Qual era a modelagem certa?").font(.subheadline.bold())
                Picker("Modelagem real", selection: $actualLabel) {
                    ForEach(analysis.allLabels, id: \.self) { label in
                        Text(label).tag(label)
                    }
                }
                .pickerStyle(.menu)

                Button("Registrar teste", action: recordTest)
                    .buttonStyle(.borderedProminent)
                    .tint(.pink)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(Color(.secondarySystemBackground)))
        }
    }

    // MARK: - Tabela de resultados

    @ViewBuilder
    private var summarySection: some View {
        if !records.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Resultados (\(records.count) testes)").font(.title3.bold())
                    Spacer()
                    ShareLink(item: exportText) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }

                // Acertos por categoria
                ForEach(summaryRows, id: \.category) { row in
                    HStack {
                        Text(row.category)
                        Spacer()
                        Text("\(row.correct)/\(row.total)").bold()
                        if row.inTopTwo > row.correct {
                            Text("(\(row.inTopTwo) no top 2)")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Divider()

                // Histórico: real → previsto
                ForEach(records.reversed()) { record in
                    Text("\(record.symbol) \(record.category): \(record.actual) → \(record.predicted) (\(percent(record.confidence)))")
                        .font(.footnote)
                }

                Button("Limpar resultados", role: .destructive) {
                    records.removeAll()
                }
                .font(.footnote)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(Color(.secondarySystemBackground)))
        }
    }

    // MARK: - Ações

    private func analyze() {
        guard let image, let modelName = category?.classifierModelName else { return }
        isAnalyzing = true
        errorMessage = nil
        analysis = nil

        Task {
            do {
                let result = try await Task.detached(priority: .userInitiated) {
                    try GarmentAnalysisService.analyze(image: image, modelName: modelName)
                }.value
                analysis = result
                actualLabel = result.best?.label ?? ""   // começa assumindo que acertou
            } catch {
                errorMessage = error.localizedDescription
            }
            isAnalyzing = false
        }
    }

    private func recordTest() {
        guard let analysis, let best = analysis.best, let category else { return }
        records.append(
            TestRecord(
                category: category.rawValue,
                actual: actualLabel,
                predicted: best.label,
                confidence: best.confidence,
                secondLabel: analysis.isConfident ? nil : analysis.second?.label
            )
        )
        // Limpa só a foto para o próximo teste da mesma categoria
        image = nil
        self.analysis = nil
    }

    // MARK: - Apoio

    private var summaryRows: [(category: String, correct: Int, inTopTwo: Int, total: Int)] {
        Dictionary(grouping: records, by: \.category)
            .map { category, items in
                (category,
                 items.filter(\.isCorrect).count,
                 items.filter(\.isCorrectInTopTwo).count,
                 items.count)
            }
            .sorted { $0.category < $1.category }
    }

    private var exportText: String {
        var lines = ["categoria;real;previsto;confianca;resultado"]
        for record in records {
            let result = record.isCorrect ? "acerto" : (record.isCorrectInTopTwo ? "duvida_com_certa" : "erro")
            lines.append("\(record.category);\(record.actual);\(record.predicted);\(percent(record.confidence));\(result)")
        }
        lines.append("")
        for row in summaryRows {
            lines.append("\(row.category): \(row.correct)/\(row.total) acertos (\(row.inTopTwo)/\(row.total) no top 2)")
        }
        return lines.joined(separator: "\n")
    }

    private func percent(_ value: Float) -> String {
        Double(value).formatted(.percent.precision(.fractionLength(0)))
    }
}

// MARK: - Registro de um teste

struct TestRecord: Identifiable {
    let id = UUID()
    let category: String
    let actual: String
    let predicted: String
    let confidence: Float
    /// Segunda opção, só quando o app mostraria "Parece X ou Y".
    let secondLabel: String?

    var isCorrect: Bool { predicted == actual }
    var isCorrectInTopTwo: Bool { isCorrect || secondLabel == actual }

    var symbol: String {
        if isCorrect { return "✅" }
        if isCorrectInTopTwo { return "⚠️" }
        return "❌"
    }
}

#Preview {
    GarmentAnalysisTestView()
}
