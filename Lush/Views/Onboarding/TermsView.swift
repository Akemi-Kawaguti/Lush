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

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        VStack(spacing: 0) {

            

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {

                    ForEach(TermsOfUse.content.components(separatedBy: "\n\n"), id: \.self) { paragraph in
                        let isTitle = paragraph.first?.isNumber == true

                        Text(paragraph)
                            .font(isTitle ? .callout.weight(.semibold) : .subheadline)
                            .foregroundStyle(isTitle ? .primary : .secondary)
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
            .background(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 24)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        Color.gray.opacity(0.25),
                        lineWidth: 1
                    )
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 16)

            HStack {

                Text(viewModel.hasReachedEnd ? "Li e aceito os termos de uso" : "Role e leia os termos para aceitar")
                    .font(.subheadline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    
                Spacer()

                Toggle(
                    "",
                    isOn: $viewModel.hasAcceptedTerms
                )
                .labelsHidden()
                .tint(Color.black.opacity(0.7))
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
        .toolbar {
            Toolbar(title: "Termo de Uso", action: nil, onBackClick: { dismiss() })
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)

    }
}

#Preview {
    NavigationStack {
        TermsView()
    }
}
