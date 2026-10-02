//
//  Toolbar.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 02/10/26.

import SwiftUI

enum ToolbarAction {
    case add       // "+"  → Minhas roupas
    case confirm   // "✓"  → Cadastrar roupa
    case edit      // "✎"  → Detalhes da peça

    var systemImage: String {
        switch self {
        case .add: "plus"
        case .confirm: "checkmark"
        case .edit: "pencil"
        }
    }

    var accessibilityLabel: String {
        switch self {
        case .add: "Adicionar"
        case .confirm: "Salvar"
        case .edit: "Editar"
        }
    }
}

//toolbar
struct Toolbar: ToolbarContent {
    var action: ToolbarAction? = .add
    var isActionEnabled: Bool = true
    var onBackClick: () -> Void = {}
    var onActionClick: () -> Void = {}

    var body: some ToolbarContent {

        // Voltar
        ToolbarItem(placement: .topBarLeading) {
            Button(action: onBackClick) {
                Image(systemName: "chevron.left")
                    .fontWeight(.semibold)
            }
            .accessibilityLabel("Voltar")
        }

        // Ação da direita (opcional)
        if let action {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: onActionClick) {
                    Image(systemName: action.systemImage)
                        .fontWeight(.semibold)
                }
                .buttonStyle(.glassProminent)
                .tint(Color("button"))
                .disabled(!isActionEnabled)
                .accessibilityLabel(action.accessibilityLabel)
            }
        }
    }
}

#Preview {
    NavigationStack {
        VStack(alignment: .leading, spacing: 6) {
            Text("Cadastrar roupa")
                .font(.AppTypography.largeTitle)

            Text("O Lush analisará as cores e modelagem para você!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 24)
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .toolbar {
            Toolbar(action: .confirm)
        }
    }
}
