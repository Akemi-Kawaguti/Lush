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

    // Arrastar a foto depois do zoom
    @State private var panOffset: CGSize = .zero
    @State private var lastPanOffset: CGSize = .zero

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
                        .offset(panOffset)
                        .clipped()
                        .contentShape(Rectangle())
                        // Arrastar a foto: só com zoom e fora do conta-gotas
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    panOffset = clampedOffset(CGSize(
                                        width: lastPanOffset.width + value.translation.width,
                                        height: lastPanOffset.height + value.translation.height
                                    ))
                                }
                                .onEnded { _ in
                                    lastPanOffset = panOffset
                                    // A foto andou embaixo do conta-gotas: atualiza a cor
                                    if hasSelectedColor {
                                        sampleColor(at: dropperPosition, image: image)
                                    }
                                },
                            isEnabled: zoomScale > 1
                        )


                    // Conta-gotas
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
                        // Área de toque maior e inteira (o miolo transparente também conta)
                        .padding(8)
                        .contentShape(Circle())
                        .position(dropperPosition)
                        // highPriority: ao tocar na bolinha, ela ganha do arraste da foto
                        .highPriorityGesture(
                            DragGesture(coordinateSpace: .named("photo"))
                                .onChanged { value in

                                    let x = min(max(value.location.x,16),226)
                                    let y = min(max(value.location.y,16),364)

                                    let position = CGPoint(x: x,y: y)

                                    dropperPosition = position

                                    sampleColor(at: position,image: image)
                                }
                        )


                    HStack(spacing: 0) {

                        Button {
                            zoomScale = max(1.0,zoomScale - 0.25)
                            // Com menos zoom, a foto não pode ficar fora do card
                            panOffset = clampedOffset(panOffset)
                            lastPanOffset = panOffset
                        } label: {
                            Image(systemName: "minus")
                                .font(.system(size: 20,weight: .medium))
                                .frame(width: 46,height: 40)
                        }
                        .accessibilityLabel("Diminuir zoom")

                        Rectangle()
                            .fill(.white.opacity(0.6))
                            .frame(width: 1,height: 40)

                        Button {
                            zoomScale = min(
                                3.0,
                                zoomScale + 0.25
                            )
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 20,weight: .medium))
                                .frame(width: 46,height: 40)
                        }
                        .accessibilityLabel("Aumentar zoom")
                    }
                    .foregroundStyle(.white)
                    // Mesmo vidro escuro do crédito dos cards de looks
                    .glassEffect(.regular.tint(.black.opacity(0.5)), in: Capsule())
                    .position(x: 70,y: 340)
                }
                .frame(width: 242,height: 380)
                .clipped()
                .coordinateSpace(name: "photo")

            } else {
                Color.gray.opacity(0.2)
                    .frame(width: 242,height: 380)
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
            .frame(width: 103,height: 380)
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


    // A parte selecionada (pele, cabelo ou olhos) já tem cor?
    private var hasSelectedColor: Bool {
        switch selectedTarget {
        case .skin: return skinColor != nil
        case .hair: return hairColor != nil
        case .eyes: return eyeColor != nil
        }
    }


    // Limita o arraste para a foto não sair do card
    private func clampedOffset(_ offset: CGSize) -> CGSize {
        let maxX = 242 * (zoomScale - 1) / 2
        let maxY = 380 * (zoomScale - 1) / 2
        return CGSize(
            width: min(max(offset.width, -maxX), maxX),
            height: min(max(offset.height, -maxY), maxY)
        )
    }


    private func sampleColor(at position: CGPoint,image: UIImage
    ) {

        let center = CGPoint(x: 121,y: 190)

        // desconta o arraste e o zoom para achar o ponto na foto original
        let unzoomedX = center.x + (position.x - panOffset.width - center.x) / zoomScale

        let unzoomedY = center.y + (position.y - panOffset.height - center.y) / zoomScale

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
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Circle()
                    .fill(color ?? .white)
                    .frame(width: 44, height: 44)
                    // Sem cor ainda: contorno cinza fino para a bolinha aparecer no branco
                    .overlay {
                        if color == nil && !isSelected {
                            Circle()
                                .strokeBorder(Color.gray.opacity(0.5), lineWidth: 1.5)
                        }
                    }
                    // Selecionada: anel rosa com um respiro branco
                    .padding(4)
                    .overlay {
                        if isSelected {
                            Circle()
                                .strokeBorder(Color("button"), lineWidth: 3)
                        }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    ColorSelectionCard(
        image: UIImage(named: "teste")
    )
    .padding()
}
