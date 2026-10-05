//
//  ScreenHeader.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 02/10/26.
//

import SwiftUI

struct ScreenHeader: View {

    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.AppTypography.largeTitle)
                .accessibilityAddTraits(.isHeader)
                .foregroundStyle(Color("titles"))

            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Color("subtitles"))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

#Preview {
    VStack(spacing: 32) {
        ScreenHeader(
            title: "Cadastrar roupa",
            subtitle: "O Lush analisará as cores e modelagem para você!"
        )
        ScreenHeader(
            title: "Minhas roupas",
            subtitle: "Adicione suas roupas e faça escolhas assertivas"
        )
        ScreenHeader(title: "Favoritos")
    }
    .padding(24)
}
