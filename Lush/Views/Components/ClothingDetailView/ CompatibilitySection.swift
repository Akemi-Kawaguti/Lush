//
//   CompatibilitySection.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 02/10/26.
//

//  Cartão de resultado de uma análise
//
//  CompatibilitySection.swift
//  Lush
//
//  Cartão de resultado de uma análise (layout da designer):
//  ┌───────────────────────────────────────┐
//  │ ( Biotipo: Alta compatibilidade   ● ) │  ← cabeçalho em destaque (cápsula cinza)
//  │   Modelagem da peça          Evasê    │  ← linhas de detalhe
//  │   ─────────────────────────────────   │
//  │   Seu biotipo            Ampulheta    │
//  └───────────────────────────────────────┘
//    rodapé curto (opcional), fora do cartão
//
//  Uso:
//  CompatibilitySection(title: "Biotipo", level: .high, footer: "Texto curto") {
//      DetailRow(label: "Modelagem da peça", value: "Evasê")
//      Divider().padding(.horizontal, 16)
//      DetailRow(label: "Seu biotipo", value: "Ampulheta")
//  }
//

import SwiftUI

struct CompatibilitySection<Content: View>: View {

    let title: String
    let level: CompatibilityLevel
    var footer: String? = nil
    let content: Content

    init(
        title: String,
        level: CompatibilityLevel,
        footer: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.level = level
        self.footer = footer
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            VStack(spacing: 0) {

                // 1º nível: resultado (cápsula cinza em destaque)
                HStack(spacing: 12) {
                    Text("\(Text("\(title):").font(.AppTypography.title3)) \(Text(level.title))")
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Spacer(minLength: 8)
                    CompatibilityIndicator(level: level)
                }
                .padding(.horizontal, 24)
                .frame(minHeight: 56)
                .background(Capsule().fill(Color(.systemGray6)))
                .padding(12)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(title): \(level.title)")
                .accessibilityAddTraits(.isHeader)

                // 2º nível: detalhes
                content
                    .padding(.horizontal, 8)
            }
            .padding(.bottom, 12)
            .background(RoundedRectangle(cornerRadius: 32).fill(.white))
            .overlay(RoundedRectangle(cornerRadius: 32).stroke(Color.gray.opacity(0.2), lineWidth: 1))

            // 3º nível: explicação
            if let footer {
                Text(footer)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)
            }
        }
    }
}

// Linha "rótulo ........ valor" dentro do cartão.
struct DetailRow<Trailing: View>: View {

    let label: String
    let trailing: Trailing

    init(label: String, @ViewBuilder trailing: () -> Trailing) {
        self.label = label
        self.trailing = trailing()
    }

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            trailing
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 52)
        .accessibilityElement(children: .combine)
    }
}

extension DetailRow where Trailing == Text {
    // Atalho para valor em texto: DetailRow(label: "Modelagem", value: "Evasê")
    init(label: String, value: String) {
        self.init(label: label) { Text(value) }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 24) {
            CompatibilitySection(
                title: "Biotipo",
                level: .high,
                footer: "A modelagem evasê marca a cintura e equilibra quadril e ombros, valorizando a silhueta ampulheta."
            ) {
                DetailRow(label: "Modelagem da peça", value: "Evasê")
                Divider().padding(.horizontal, 16)
                DetailRow(label: "Seu biotipo", value: "Ampulheta")
            }

            CompatibilitySection(title: "Paleta", level: .low) {
                DetailRow(label: "Sua paleta de cor", value: "Outono Suave")
                Divider().padding(.horizontal, 16)
                DetailRow(label: "Combinam com você", value: "3 de 4")
            }
        }
        .padding(24)
    }
    .background(Color("tertiary").opacity(0.2))
}
