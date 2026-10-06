//
//  BiotypeMethodCard.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 02/10/26.
//
//
//  BiotypeMethodCard.swift
//  Lush
//

import SwiftUI

struct BiotypeMethodCard: View {

    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {

        Button(action: action) {

            HStack(spacing: 20) {

                Circle()
                    .stroke(
                        isSelected
                            ? Color.button
                            : Color("borderLines"),
                        lineWidth: 1
                    )
                    .frame(width: 28, height: 28)
                    .overlay {

                        if isSelected {
                            Circle()
                                .fill(Color.button)
                                .frame(width: 20, height: 20)
                                .overlay {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 11,weight: .bold))
                                        .foregroundStyle(.white)
                                }
                        }
                    }

                VStack(alignment: .leading, spacing: 8) {

                    Text(title)
                        .font(.body.weight(.medium))
                        .foregroundStyle(Color("textAttention"))

                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.quartenary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity,minHeight: 100)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("borderLines"),lineWidth: 0.5)
            }
        }
        .buttonStyle(.plain)
    }
}
#Preview {
    VStack {
        BiotypeMethodCard(
            title: "Análise por foto",
            subtitle: "Análise automática e com maior precisão",
            isSelected: true
        ) {
            print("Selecionado")
        }
        .padding()
    }
    .padding(.horizontal, 10)
}
