//
//  LushBackButtom.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 29/09/26.
//
import SwiftUI

struct LushBackButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.black)
                .frame(width: 44, height: 44)
        }
        .glassEffect(.regular, in: .circle)
    }
}

#Preview {
    LushBackButton {
        print("Voltar")
    }
}
