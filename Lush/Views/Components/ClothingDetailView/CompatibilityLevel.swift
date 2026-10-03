//
//  CompatibilityLevel.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 02/10/26.
//

//  Nível de compatibilidade da peça com a usuária (biotipo ou paleta).

//
//  CompatibilityLevel.swift
//  Lush
//
//  Nível de compatibilidade da peça com a usuária (biotipo ou paleta):
//  Alta, Média ou Baixa — cada um com a cor da bolinha indicadora.
//

import SwiftUI

enum CompatibilityLevel: Int, CaseIterable {
    case low = 1
    case medium = 2
    case high = 3

    var title: String {
        switch self {
        case .high: "Alta compatibilidade"
        case .medium: "Média compatibilidade"
        case .low: "Baixa compatibilidade"
        }
    }

    /// Cor da bolinha. ⚠️ Confirmar com a designer (principalmente a de Média).
    var color: Color {
        switch self {
        case .high: Color("button")                           // rosa da marca
        case .medium: Color("assistant")                      // lilás da marca
        case .low: Color(red: 0.0, green: 0.76, blue: 0.80)   // ciano do protótipo
        }
    }
}

/// Bolinha que indica o nível (só visual — o texto já diz o nível).
struct CompatibilityIndicator: View {

    let level: CompatibilityLevel

    var body: some View {
        Circle()
            .fill(level.color)
            .frame(width: 24, height: 24)
            .accessibilityHidden(true)
    }
}

/// Uma cor encontrada na peça e se ela faz parte da paleta da usuária.
struct GarmentColor: Identifiable {
    let id = UUID()
    let color: Color
    let matchesPalette: Bool
}

#Preview {
    VStack(alignment: .leading, spacing: 20) {
        ForEach(CompatibilityLevel.allCases.reversed(), id: \.self) { level in
            HStack {
                Text(level.title)
                Spacer()
                CompatibilityIndicator(level: level)
            }
        }
    }
    .padding(24)
}
