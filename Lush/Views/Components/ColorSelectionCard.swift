//
//  ColorSelectionCard.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 02/10/26.
//

import SwiftUI
import UIKit

struct ColorSelectionCard: View {

    let image: UIImage?

    @State private var dropperPosition: CGPoint = CGPoint(
        x: 121,
        y: 190
    )

    @State private var selectedTarget: ColorTarget = .skin

    @State private var skinColor: Color?
    @State private var hairColor: Color?
    @State private var eyeColor: Color?

    @State private var zoomScale: CGFloat = 1.0

    private let sampler = ColorSamplerService()

    var body: some View {
        HStack(spacing: 0) {


            if let image {
                ZStack {

                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 242,height: 380)
                        .scaleEffect(zoomScale)
                        .clipped()


                    Circle()
                        .fill(currentColor)
                        .frame(width: 32,height: 32)
                        .overlay {
                            Circle()
                                .stroke(.white,lineWidth: 3)
                        }
                        .shadow(
                            color: .black.opacity(0.25),
                            radius: 4
                        )
                        .position(dropperPosition)
                        .gesture(DragGesture().onChanged { value in

                                    let x = min(
                                        max(value.location.x,16),226)

                                    let y = min(
                                        max(value.location.y,16),364)

                                    let position = CGPoint(x: x,y: y)

                                    dropperPosition = position

                                    sampleColor(at: position,image: image)
                                }
                        )


                    HStack(spacing: 0) {

                        Button {
                            zoomScale = max(1.0,zoomScale - 0.25)
                        } label: {
                            Image(systemName: "minus")
                                .font(.system(size: 24,weight: .medium))
                                .frame(width: 46,height: 25)
                        }

                        Rectangle()
                            .fill(.white.opacity(0.6))
                            .frame(width: 1,height: 44)

                        Button {
                            zoomScale = min(
                                3.0,
                                zoomScale + 0.25
                            )
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 24,weight: .medium))
                                .frame(width: 46,height: 25)
                        }
                    }
                    .foregroundStyle(.white)
                    .background(Color.white.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .position(x: 70,y: 340)
                }
                .frame(width: 242,height: 380)
                .clipped()

            } else {
                Color.gray.opacity(0.2)
                    .frame(width: 321,height: 380)
            }


            VStack(spacing: 0) {

                ColorOption(
                    title: "Pele",
                    color: skinColor,
                    isSelected: selectedTarget == .skin) {
                    selectedTarget = .skin
                }

                ColorOption(
                    title: "Cabelo",
                    color: hairColor,
                    isSelected: selectedTarget == .hair) {
                    selectedTarget = .hair
                }

                ColorOption(
                    title: "Olhos",
                    color: eyeColor,
                    isSelected: selectedTarget == .eyes) {
                    selectedTarget = .eyes
                }
            }
            .frame(width: 120,height: 380)
            .background(.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24)
        )
        .overlay {RoundedRectangle(cornerRadius: 24)
            .stroke(Color.gray.opacity(0.4),lineWidth: 0.8)
        }
    }


    private var currentColor: Color {
        switch selectedTarget {

        case .skin:
            return skinColor ?? .clear

        case .hair:
            return hairColor ?? .clear

        case .eyes:
            return eyeColor ?? .clear
        }
    }


    private func sampleColor(at position: CGPoint,image: UIImage
    ) {

        let center = CGPoint(x: 121,y: 190)

        // converte a posição visual do conta-gotas para a posição equivalente antes do zoom
        let unzoomedX = center.x + (position.x - center.x) / zoomScale

        let unzoomedY = center.y + (position.y - center.y) / zoomScale

        let unzoomedPosition = CGPoint(x: unzoomedX,y: unzoomedY)

        guard let uiColor = sampler.color(from: image, at: unzoomedPosition, displayedSize: CGSize( width: 242, height: 380)
        ) else {
            return
        }

        let color = Color(uiColor)

        switch selectedTarget {

        case .skin:
            skinColor = color

        case .hair:
            hairColor = color

        case .eyes:
            eyeColor = color
        }
    }
}


private struct ColorOption: View {

    let title: String
    let color: Color?
    let isSelected: Bool
    let action: () -> Void

    var body: some View {

        Button(action: action) {

            VStack(spacing: 10) {

                Text(title)
                    .font(.system(size: 16,weight: .regular))
                    .foregroundStyle(.gray)

                Circle()
                    .fill(color ?? .white)
                    .frame(width: 58,height: 58)
                    .overlay {

                        Circle()
                            .stroke(isSelected ? Color.button : Color.gray.opacity(0.7), lineWidth: 4)
                            .padding(-6)
                    }
            }
            .frame(width: 120)
            .frame(maxHeight: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ColorSelectionCard(
        image: UIImage(named: "teste")
    )
    .padding()
}
