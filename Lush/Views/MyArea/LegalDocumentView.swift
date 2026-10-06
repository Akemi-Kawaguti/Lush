//
//  LegalDocumentView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 05/10/26.
//

import SwiftUI

struct LegalDocumentView: View {

    @Environment(\.dismiss) private var dismiss

    let title: String
    let lastUpdated: String
    let content: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(lastUpdated)
                    .font(.footnote)
                    .foregroundStyle(Color("quartenary"))

                LegalText(content: content)
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)
        }
        .scrollIndicators(.hidden)
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .toolbar {
            Toolbar(title: title, action: nil, onBackClick: { dismiss() })
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        LegalDocumentView(
            title: "Política de Privacidade",
            lastUpdated: PrivacyPolicy.lastUpdated,
            content: PrivacyPolicy.content
        )
    }
}
