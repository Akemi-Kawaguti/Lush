//
//  LushProgressBar.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 29/09/26.
//
import SwiftUI

struct ProgressBar: View {
    
    let currentStep: Int
    let totalSteps: Int
    
    private var progress: CGFloat {
        CGFloat(currentStep) / CGFloat(totalSteps)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Passo \(currentStep) de \(totalSteps)")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.black)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    
                    Capsule().fill(Color.gray.opacity(0.15))
                    
                    Capsule().fill(Color("button"))
                    .frame(width: geometry.size.width * progress)
                }
            }
            .frame(height: 6)
        }
    }
}

#Preview {
    ProgressBar(
        currentStep: 1,
        totalSteps: 4
    )
    .padding(.horizontal, 36)
}
