//
//  BodyFeatureCard.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//


import SwiftUI

struct BodyFeatureCard: View {

    var imageName: String? = nil   // ilustração no Assets
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            Group {
                if let imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "figure.stand")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray.opacity(0.4), lineWidth: 1))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.AppTypography.headline)
                    .foregroundStyle(Color("titles"))
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(Color("titles").opacity(0.7))
            }
        }
        .padding(16)
        .frame(width: 340, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 24).fill(.white))
        .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(Color("borderLines"), lineWidth: 0.5))
    }
}

#Preview {
    BodyFeatureCard(title: "Cintura", description: "Bem definida e marcada.")
        .padding()
}
