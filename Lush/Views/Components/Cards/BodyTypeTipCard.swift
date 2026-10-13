//
//  LushBackButtom.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 29/09/26.
//

import SwiftUI

struct BodyShapeTipCard: View {
    
    let bodyShape: BodyShape
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            Text("O que isso significa?")
                .font(.AppTypography.title3)
            
            Text("Texto do biotipo")
            /*(BodyShapeContent.tip(for: bodyShape))*/
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.gray)
                .lineSpacing(6)
            

        }
        .frame(width: 353, height: 108, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .overlay {
            RoundedRectangle(cornerRadius: 25).stroke(
                Color(.gray.opacity(0.5)),lineWidth: 0.5)
        }
    }
}

#Preview {
    BodyShapeTipCard(
        bodyShape: .hourglass
    )
    .padding(24)
    .background {
        Image("backgroundLush")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}
