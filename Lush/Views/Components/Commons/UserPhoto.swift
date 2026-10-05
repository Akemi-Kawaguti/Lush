//
//  UserPhoto.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//

//  Foto da usuária, redonda com borda rosa.

//
//  UserPhoto.swift
//  Lush
//
//  Foto da usuária, redonda com borda rosa.
//

import SwiftUI

struct UserPhoto: View {

    var imageName: String? = nil   // nome da imagem no Assets
    var image: UIImage? = nil      // foto escolhida pela usuária (tem prioridade)
    var size: CGFloat = 160
    var showsBorder: Bool = true   // false na tela da paleta
    var borderColor: Color = Color("tertiary").opacity(0.75)

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if let imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(size * 0.25)
                    .foregroundStyle(.white)
                    .background(Color("tertiary"))
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(Circle().stroke(showsBorder ? borderColor : .clear, lineWidth: 4))
        .accessibilityLabel("Sua foto")
    }
}

#Preview {
    VStack(spacing: 24) {
        UserPhoto(imageName: "userTest")
        UserPhoto()
    }
}
