//
//  LushPhotoPicker.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 29/09/26.
//
import SwiftUI

struct LushPhotoPicker: View {
    
    let title: String
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 42))
                    .foregroundStyle(.quartenary)
                
                Text(title)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(.quartenary)
                    .multilineTextAlignment(.center)
            }
            .frame(width: width, height: height)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay {
                RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.5),style: StrokeStyle(lineWidth:0.8,dash: [4, 4]))
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LushPhotoPicker(
        title: "Adicione uma foto",
        width: 321,
        height: 410
    ) {
        print("Selecionar foto")
    }
}
