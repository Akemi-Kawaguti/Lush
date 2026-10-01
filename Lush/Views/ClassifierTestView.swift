//
//  Classifiertestview.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 01/10/26.
//

//  Tela TEMPORÁRIA para testar o CalcaClassifier com fotos reais
//  (galeria ou câmera) antes de ligar no fluxo de cadastro de peças.
//  Pode apagar quando a integração estiver pronta.
//

import SwiftUI

struct ClassifierTestView: View {

    @State private var image: UIImage?
    @State private var result: GarmentClassificationResult?
    @State private var errorMessage: String?
    @State private var isClassifying = false
    @State private var service: GarmentClassifierService?

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                Text("Teste do classificador de calças")
                    .font(.title2.bold())

                // Reaproveita o componente do app (câmera + galeria)
                PhotoPicker(
                    image: $image,
                    title: "Escolha a foto de uma calça",
                    width: 300,
                    height: 380
                )

                resultView
            }
            .padding()
        }
        .task {
            loadService()
        }
        .onChange(of: image) {
            guard let image else { return }
            Task { await classify(image) }
        }
    }

    // MARK: - Resultado

    @ViewBuilder
    private var resultView: some View {
        if isClassifying {
            ProgressView("Analisando…")
        } else if let errorMessage {
            Text(errorMessage)
                .foregroundStyle(.red)
        } else if let result {
            switch result {
            case .confident(let p):
                VStack(spacing: 8) {
                    Text("Calça \(p.cut.displayName)")
                        .font(.title3.bold())
                    Text(percent(p.confidence))
                        .foregroundStyle(.secondary)
                }

            case .uncertain(let first, let second):
                VStack(spacing: 8) {
                    Text("Parece \(first.cut.displayName) ou \(second.cut.displayName)")
                        .font(.title3.bold())
                    Text("\(first.cut.displayName): \(percent(first.confidence))  ·  \(second.cut.displayName): \(percent(second.confidence))")
                        .foregroundStyle(.secondary)
                    Text("Dica: tente uma foto com a perna inteira visível.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

            case .none:
                Text("Não foi possível reconhecer a peça.")
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Lógica

    private func loadService() {
        do {
            service = try GarmentClassifierService()
        } catch {
            errorMessage = "Erro ao carregar o modelo: \(error.localizedDescription)"
        }
    }

    private func classify(_ image: UIImage) async {
        guard let service else { return }
        isClassifying = true
        errorMessage = nil
        defer { isClassifying = false }

        do {
            result = try await service.classify(image)
        } catch {
            result = nil
            errorMessage = "Erro ao classificar: \(error.localizedDescription)"
        }
    }

    private func percent(_ value: Float) -> String {
        (Double(value)).formatted(.percent.precision(.fractionLength(0)))
    }
}

#Preview {
    ClassifierTestView()
}
