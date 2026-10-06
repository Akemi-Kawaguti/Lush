//
//  TermsView.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 29/09/26.
//

import SwiftUI

struct TermsView: View {

    @State private var viewModel = TermsViewModel()
    @State private var showColorimetryPhoto = false
    @State private var pendingURL: URL?
    @Environment(\.openURL) private var openURL

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        VStack(spacing: 0) {

            //termos
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {

                    ForEach(TermsOfUse.content.components(separatedBy: "\n\n"), id: \.self) { paragraph in
                        let isTitle = paragraph.first?.isNumber == true

                        Text(textWithLink(paragraph))
                            .font(isTitle ? .callout.weight(.semibold) : .footnote)
                            .foregroundStyle(isTitle ? Color("textAttention") : Color("textAttention").opacity(0.5))
                            .lineSpacing(isTitle ? 0 : 6)
                            .padding(.top, isTitle ? 8 : 0)
                    }
                }
                .padding(32)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
            }
            .onScrollGeometryChange(for: Bool.self) { geometry in
                geometry.visibleRect.maxY >= geometry.contentSize.height - 40
            } action: { _, reachedBottom in
                if reachedBottom {
                    viewModel.reachedEndOfTerms()
                }
            }
            .tint(Color("button"))
            .environment(\.openURL, OpenURLAction { url in
                pendingURL = url
                return .handled
            })
            .background(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 24)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        Color("borderLines"),
                        lineWidth: 0.5
                    )
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 16)

            HStack {

                Text(viewModel.hasReachedEnd ? "Li e aceito os termos de uso" : "Role e leia os termos para aceitar")
                    .foregroundStyle(Color("textAttention"))
                    .fontWeight(.medium)
                    .font(.subheadline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    
                Spacer()

                Toggle("", isOn: $viewModel.hasAcceptedTerms)
                    .labelsHidden()
                    .toggleStyle(LushToggleStyle())
                    .disabled(!viewModel.hasReachedEnd)
            }
            .padding(.horizontal, 35)
            .padding(.vertical, 20)

            PrimaryButton(title: "Continuar") {
                showColorimetryPhoto = true
            }
            .disabled(!viewModel.canContinue)
            .opacity(viewModel.canContinue ? 1 : 0.5)
            .padding(.horizontal, 32)
            .padding(.top, 20)
            .padding(.bottom, 10)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .navigationDestination(isPresented: $showColorimetryPhoto) {
            ColorimetryPhotoView()
        }
        .alert(
            "Abrir app de e-mail?",
            isPresented: Binding(
                get: { pendingURL != nil },
                set: { if !$0 { pendingURL = nil } }
            )
        ) {
            Button("Cancelar", role: .cancel) {}
            Button("Abrir") {
                if let pendingURL {
                    openURL(pendingURL)
                }
            }
        } message: {
            Text("Você vai sair do Lush para enviar um e-mail para \(PrivacyPolicy.contactEmail).")
        }
        .toolbar {
            Toolbar(title: "Termo de Uso", action: nil, onBackClick: { dismiss() })
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)

    }
    
    private func textWithLink(_ paragraph: String) -> AttributedString {
        var text = AttributedString(paragraph)
        let email = PrivacyPolicy.contactEmail

        if let range = text.range(of: email) {
            text[range].link = URL(string: "mailto:\(email)")
        }
        return text
    }
}

#Preview {
    NavigationStack {
        TermsView()
    }
}
