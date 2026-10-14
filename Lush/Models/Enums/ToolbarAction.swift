//
//  ToolbarAction.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 13/10/26.
//

enum ToolbarAction {
    case add       // "+"  → Minhas roupas
    case confirm   // "✓"  → Cadastrar roupa
    case edit      // "✎"  → Detalhes da peça
    case refresh   // "⇄"  → Sugestões de looks

    var systemImage: String {
        switch self {
        case .add: "plus"
        case .confirm: "checkmark"
        case .edit: "pencil"
        case .refresh: "repeat"
        }
    }

    var accessibilityLabel: String {
        switch self {
        case .add: "Adicionar"
        case .confirm: "Salvar"
        case .edit: "Editar"
        case .refresh: "Novas sugestões"
        }
    }
}
