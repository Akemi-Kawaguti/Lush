//
//  BulletText.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 04/10/26.
//

import SwiftUI

// Tópico com bolinha rosa no lugar do "•"
// Opcional: um título em semibold no começo ("Pele:")
struct BulletText: View {

    var title: String? = nil
    let text: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(Image(systemName: "circle.fill"))
                .font(.system(size: 6))
                .baselineOffset(2)
                .foregroundStyle(Color("button"))

            if let title {
                Text("\(Text(title).fontWeight(.semibold).foregroundStyle(.primary)) \(Text(text).foregroundStyle(Color("quartenary")))")
            } else {
                Text(text)
                    .foregroundStyle(Color("quartenary"))
            }
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        BulletText(title: "Pele:", text: "posicione sobre a pele do rosto")
        BulletText(text: "Use uma foto com boa iluminação.")
    }
    .padding()
}
