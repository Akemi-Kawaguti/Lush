//
//  CharacteristicCard.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//

//  Card de característica da paleta (Temperatura, Luminosidade...).

import SwiftUI

struct CharacteristicCard: View {

    let title: String
    let value: String
    let icon: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(.subheadline, design: .serif))
                        
                    Text(value)
                        .font(.AppTypography.headline)
                }
                Spacer()
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(Color("button"))
            }

            Spacer(minLength: 16)

            Text(description)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 150, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.3), lineWidth: 1))
    }
}

#Preview {
    CharacteristicCard(
        title: "Temperatura",
        value: "Quente",
        icon: "thermometer.medium",
        description: "Tons quentes e terrosos harmonizam melhor com você."
    )
    .frame(width: 180)
    .padding()
}
