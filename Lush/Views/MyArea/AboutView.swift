//
//  AboutView.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 16/10/26.
//

import SwiftUI

struct AboutView: View {

    @Environment(\.dismiss) private var dismiss

    private let teamImages = ["agatha", "sarah", "mariana", "tais"]

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("O Lush tem como objetivo auxiliar mulheres na exploração do estilo pessoal, oferecendo referências de roupas e combinações alinhadas às suas características, preferências e identidade. Por meio da análise de coloração pessoal e do biotipo de silhueta.")
                    .font(.body)
                    .foregroundStyle(.primary)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 18)

                HStack {
                    Text("Versão atual")
                        .foregroundStyle(.primary)
                    Spacer()
                    Text(appVersion)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                }
                .font(.body)
                .padding(.horizontal, 16)
                .frame(height: 50)
                .background(.white, in: RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color("borderLines"), lineWidth: 0.5))
                .padding(.top, 24)

                Image("team")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 4)
                    .padding(.top, 38)
                    .accessibilityHidden(true)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(teamImages, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 160)
                            .scaleEffect(imageScale(for: imageName))
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 24)
        }
        .scrollIndicators(.hidden)
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .toolbar {
            Toolbar(title: "Sobre o app", action: nil, onBackClick: { dismiss() })
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }

    private func imageScale(for imageName: String) -> CGFloat {
        switch imageName {
        case "mariana": 1.1
        case "tais": 1.08
        default: 1
        }
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
