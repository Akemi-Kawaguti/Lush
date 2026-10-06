//
//  LushToggleStyle.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 05/10/26.
//

import SwiftUI

struct LushToggleStyle: ToggleStyle {

    var onColor: Color = Color("textAttention").opacity(0.7)
    var offColor: Color = Color("borderLines")

    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            Button {
                withAnimation(.snappy) {
                    configuration.isOn.toggle()
                }
            } label: {
                Capsule()
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 51, height: 31)
                    .overlay(alignment: configuration.isOn ? .trailing : .leading) {
                        Circle()
                            .fill(.white)
                            .padding(2)
                            .shadow(color: .black.opacity(0.15), radius: 2, y: 1)
                    }
            }
            .buttonStyle(.plain)
            .opacity(isEnabled ? 1 : 0.5)
            .accessibilityValue(configuration.isOn ? "Ativado" : "Desativado")
        }
    }
}
