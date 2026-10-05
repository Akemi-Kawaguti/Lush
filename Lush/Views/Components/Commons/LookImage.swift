//
//  LookImage.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 04/10/26.
//

import SwiftUI

struct LookImage: View {

    let imageName: String

    var body: some View {
        if let uiImage = UIImage(named: imageName) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .overlay {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                }
        }
    }
}

#Preview {
    LookImage(imageName: "look1")
        .frame(width: 170, height: 220)
        .clipped()
}
