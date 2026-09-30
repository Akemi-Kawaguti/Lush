//
//  LushPrimaryButton.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 29/09/26.
//
import SwiftUI

struct LushPrimaryButton: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 258, height: 44)
                .background(Color("primary"))
                .clipShape(Capsule())
        }
    }
}

#Preview {
    LushPrimaryButton(title: "Continuar") {
        print("Botão pressionado")
    }
}
