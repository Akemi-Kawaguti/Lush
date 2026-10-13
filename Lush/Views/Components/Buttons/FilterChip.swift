//
//  FilterChip.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 04/10/26.
//

//  Botão de filtro em cápsula (Todos, Casual, Trabalho...).

import SwiftUI

struct FilterChip: View {

    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundStyle(isSelected ? .white : .textAttention.opacity(0.7))
                .padding(.horizontal, 20)
                .frame(height: 40)
                .background(Capsule().fill(isSelected ? Color("button") : .white))
                .overlay(Capsule().strokeBorder(isSelected ? .clear : Color("borderLines"), lineWidth: 0.5))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    HStack {
        FilterChip(title: "Todos", isSelected: true) {}
        FilterChip(title: "Casual", isSelected: false) {}
    }
}
