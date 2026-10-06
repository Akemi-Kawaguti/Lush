//
//  MeasurementField.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 04/10/26.
//

import SwiftUI

struct MeasurementField: View {

    let imageName: String
    let title: String
    let description: String
    @Binding var value: String

    var body: some View {
        HStack(spacing: 12) {

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 88, height: 88)
                .clipShape(Circle())
                .overlay(Circle().strokeBorder(.black, lineWidth: 1))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color("titles"))

                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(Color("quartenary"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)

                HStack {
                    TextField(
                        "Ex: 48 cm",
                        text: $value,
                        prompt: Text("Ex: 48 cm").foregroundStyle(Color("placeholders"))
                    )
                    .foregroundStyle(Color("textAttention"))
                    .keyboardType(.decimalPad)
                    // Aceita só números e vírgula/ponto (bloqueia letras coladas ou digitadas)
                    .onChange(of: value) { _, newValue in
                        let filtered = newValue.filter { $0.isNumber || $0 == "," || $0 == "." }
                        if filtered != newValue {
                            value = filtered
                        }
                    }
                    .accessibilityLabel("\(title) em centímetros")

                    Text("cm")
                        .foregroundStyle(Color("placeholders"))
                }
                .padding(.horizontal, 20)
                .frame(height: 48)
                .background(Capsule().fill(.white))
                .overlay(Capsule().strokeBorder(Color("borderLines"), lineWidth: 1))
            }
        }
    }
}

#Preview {
    @Previewable @State var value = ""

    MeasurementField(
        imageName: "ombros",
        title: "Ombros",
        description: "Meça o comprimento dos ombros",
        value: $value
    )
    .padding()
}
