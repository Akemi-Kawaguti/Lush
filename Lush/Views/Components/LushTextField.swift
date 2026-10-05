//
//  LushTextField.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 02/10/26.
//

import SwiftUI

struct LushTextField: View {

    let title: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
                .foregroundStyle(Color("labels"))

            TextField(
                placeholder,
                text: $text,
                // Mesma cor de placeholder dos LushPickerField
                prompt: Text(placeholder).foregroundStyle(Color("placeholders"))
            )
                .textInputAutocapitalization(.sentences)
                .submitLabel(.done)
                .padding(.horizontal, 24)
                .frame(height: 56)
                .background(Capsule().fill(.white))
                .overlay(Capsule().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                .foregroundStyle(Color("labels"))
        }
    }
}

#Preview {
    @Previewable @State var name = ""

    LushTextField(
        title: "Nome da roupa",
        placeholder: "Adicione o nome para a sua roupa",
        text: $name
    )
    .padding(24)

}
