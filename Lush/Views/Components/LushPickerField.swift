//
//  LushPickerField.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 02/10/26.
//

import SwiftUI

struct LushPickerField<Option: Hashable>: View {

    let title: String
    let placeholder: String
    let options: [Option]
    @Binding var selection: Option?
    let optionTitle: (Option) -> String

    @Environment(\.isEnabled) private var isEnabled

    init(
        title: String,
        placeholder: String,
        options: [Option],
        selection: Binding<Option?>,
        optionTitle: @escaping (Option) -> String
    ) {
        self.title = title
        self.placeholder = placeholder
        self.options = options
        self._selection = selection
        self.optionTitle = optionTitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.medium)

            Menu {
                Picker(title, selection: $selection) {
                    ForEach(options, id: \.self) { option in
                        Text(optionTitle(option)).tag(Optional(option))
                    }
                }
            } label: {
                HStack {
                    Text(selection.map(optionTitle) ?? placeholder)
                        // Cores fixas: o Menu pinta o label de azul se usar .secondary
                        .foregroundStyle(selection == nil || !isEnabled
                                         ? Color(.secondaryLabel)
                                         : Color(.label))
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Color(.secondaryLabel))
    
                }
                .padding(.horizontal, 20)
                .frame(height: 56)
                .background(Capsule().fill(.white))
                .overlay(Capsule().stroke(Color.gray.opacity(0.3), lineWidth: 1))
            }
            .tint(.primary)
        }
    }
}

// MARK: - Atalho para enums com rawValue String

extension LushPickerField where Option: RawRepresentable, Option.RawValue == String {
    init(
        title: String,
        placeholder: String,
        options: [Option],
        selection: Binding<Option?>
    ) {
        self.init(
            title: title,
            placeholder: placeholder,
            options: options,
            selection: selection,
            optionTitle: { $0.rawValue }
        )
    }
}

#Preview {
    @Previewable @State var position: GarmentPosition?

    LushPickerField(
        title: "Tipo de peça",
        placeholder: "Parte de cima, de baixo ou peça única",
        options: [.top, .bottom, .onePiece],
        selection: $position
    )
    .padding(24)
    .background(Color.pink.opacity(0.05))
}
