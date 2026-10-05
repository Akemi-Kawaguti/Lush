//
//  SheetToolbar.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 02/10/26.
//

//
//  SheetToolbar.swift
//  Lush
//
//  Toolbar para telas abertas em sheet:
//  [ ✕ ]        Título        [ ✓ ]
//
//  Uso:
//  .toolbar {
//      SheetToolbar(
//          title: "Editar roupa",
//          isConfirmEnabled: formValido,
//          onClose: { dismiss() },
//          onConfirm: { salvar() }
//      )
//  }
//

import SwiftUI

struct SheetToolbar: ToolbarContent {
    var title: String
    var isConfirmEnabled: Bool = true
    var onClose: () -> Void = {}
    var onConfirm: () -> Void = {}

    var body: some ToolbarContent {

        // Fechar — no iOS 26 o item já ganha o círculo de vidro
        ToolbarItem(placement: .topBarLeading) {
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .fontWeight(.semibold)
            }
            .accessibilityLabel("Fechar")
        }

        // Título centralizado
        ToolbarItem(placement: .principal) {
            Text(title)
                .font(.AppTypography.title3)
                .accessibilityAddTraits(.isHeader)
        }

        // Confirmar
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: onConfirm) {
                Image(systemName: "checkmark")
                    .fontWeight(.semibold)
            }
            .buttonStyle(.glassProminent)
            .tint(Color("button"))
            .disabled(!isConfirmEnabled)
            .accessibilityLabel("Salvar")
        }
    }
}

#Preview {
    @Previewable @State var isShowing = true

    Text("Tela de fundo")
        .sheet(isPresented: $isShowing) {
            NavigationStack {
                Text("Conteúdo da sheet")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        SheetToolbar(title: "Editar roupa")
                    }
            }
        }
}
