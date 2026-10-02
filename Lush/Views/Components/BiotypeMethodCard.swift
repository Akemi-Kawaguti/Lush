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
                            : Color.gray.opacity(0.5),
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
                        .font(.system(size: 17,weight: .medium))
                        .foregroundStyle(.black)

                    Text(subtitle)
                        .font(.system(size: 12,weight: .regular))
                        .foregroundStyle(.quartenary)
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity,minHeight: 100)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.35),lineWidth: 0.8)
            }
        }
        .buttonStyle(.plain)
    }
}
#Preview {
    BiotypeMethodCard(
        title: "Análise por foto",
        subtitle: "Análise automática e com maior precisão",
        isSelected: true
    ) {
        print("Selecionado")
    }
    .padding()
}
