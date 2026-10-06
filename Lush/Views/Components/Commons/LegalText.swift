//
//  LegalText.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 05/10/26.
//

import SwiftUI

struct LegalText: View {

    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(content.components(separatedBy: "\n\n"), id: \.self) { paragraph in
                let isTitle = paragraph.first?.isNumber == true

                Text(withEmailLink(paragraph))
                    .font(isTitle ? .callout.weight(.semibold) : .subheadline)
                    .foregroundStyle(isTitle ? Color("titles") : Color("quartenary"))
                    .lineSpacing(isTitle ? 0 : 6)
                    .padding(.top, isTitle ? 8 : 0)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .tint(Color("button"))   // cor do link
    }

    // Transforma o e-mail de contato em link: toque abre o app de e-mail
    func withEmailLink(_ text: String) -> AttributedString {
        var result = AttributedString(text)
        let email = PrivacyPolicy.contactEmail
        if let range = result.range(of: email) {
            result[range].link = URL(string: "mailto:\(email)")
        }
        return result
    }
}

#Preview {
    ScrollView {
        LegalText(content: PrivacyPolicy.content)
            .padding(24)
    }
}
