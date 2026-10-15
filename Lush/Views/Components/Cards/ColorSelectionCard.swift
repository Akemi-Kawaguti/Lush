//
//  ColorSelectionCard.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 02/10/26.
//

import SwiftUI
import UIKit

struct ColorSelectionCard: View {

    private static let photoWidth: CGFloat = 242
    private static let photoHeight: CGFloat = 370

    let image: UIImage?

    @State private var dropperPosition = CGPoint(
        x: photoWidth / 2,
        y: photoHeight / 2
    )

    @State private var selectedTarget: ColorTarget = .skin

    @Binding var skinColor: Color?
    @Binding var hairColor: Color?
    @Binding var eyeColor: Color?

    @State private var zoomScale: CGFloat = 1.0
    @State private var lastZoomScale: CGFloat = 1.0
    private static let maxZoom: CGFloat = 3.0

    @State private var panOffset: CGSize = .zero
    @State private var lastPanOffset: CGSize = .zero

    @State private var sampler = ColorSamplerService()

    var body: some View {
        HStack(spacing: 0) {

            if let image {
                ZStack {

                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: Self.photoWidth, height: Self.photoHeight)
                        .scaleEffect(zoomScale)
                        .offset(panOffset)
                        .clipped()
                        .contentShape(Rectangle())
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
                                    if hasSelectedColor {
                                        sampleColor(at: dropperPosition, image: image)
                                    }
                                },
                            isEnabled: zoomScale > 1
                        )
                        .simultaneousGesture(
                            MagnifyGesture()
                                .onChanged { value in
                                    zoomScale = min(max(lastZoomScale * value.magnification, 1), Self.maxZoom)
                                    panOffset = clampedOffset(panOffset)
                                }
                                .onEnded { _ in
                                    lastZoomScale = zoomScale
                                    lastPanOffset = panOffset
                                    if hasSelectedColor {
                                        sampleColor(at: dropperPosition, image: image)
                                    }
                                }
                        )
   
                    ZStack {
                        Circle()
                            .stroke(
                                currentColor,
                                lineWidth: 14
                            )
                            .frame(width: 76, height: 76)

                        Path { path in
                            path.move(to: CGPoint(x: 38, y: 12))
                            path.addLine(to: CGPoint(x: 38, y: 34))

                            path.move(to: CGPoint(x: 38, y: 42))
                            path.addLine(to: CGPoint(x: 38, y: 64))
                        }
                        .stroke(.white, style: StrokeStyle(lineWidth: 2, lineCap: .butt))
                        .frame(width: 76, height: 76)

                        Path { path in
                            path.move(to: CGPoint(x: 12, y: 38))
                            path.addLine(to: CGPoint(x: 34, y: 38))

                            path.move(to: CGPoint(x: 42, y: 38))
                            path.addLine(to: CGPoint(x: 64, y: 38))
                        }
                        .stroke(.white, style: StrokeStyle(lineWidth: 2, lineCap: .butt))
                        .frame(width: 76, height: 76)
                    }
                    .frame(width: 76, height: 76)
                    .shadow(color: .black.opacity(0.15), radius: 2)
                    .contentShape(Circle())
                    .position(dropperPosition)
                    .highPriorityGesture(
                        DragGesture(coordinateSpace: .named("photo"))
                            .onChanged { value in
                                let x = min(max(value.location.x, 38),Self.photoWidth - 38)

                                let y = min(max(value.location.y, 38),Self.photoHeight - 38)

                                let position = CGPoint(x: x, y: y)
                                dropperPosition = position
                                sampleColor(at: position, image: image)
                            }
                    )





                    HStack(spacing: 0) {

                        Button {
                            zoomScale = max(1.0, zoomScale - 0.25)
                            lastZoomScale = zoomScale
                            panOffset = clampedOffset(panOffset)
                            lastPanOffset = panOffset
                        } label: {
                            Image(systemName: "minus")
                                .font(.system(size: 20, weight: .medium))
                                .frame(width: 46, height: 40)
                        }
                        .accessibilityLabel("Diminuir zoom")

                        Rectangle()
                            .fill(.white.opacity(0.6))
                            .frame(width: 1, height: 40)

                        Button {
                            zoomScale = min(Self.maxZoom, zoomScale + 0.25)
                            lastZoomScale = zoomScale
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .medium))
                                .frame(width: 46, height: 40)
                        }
                        .accessibilityLabel("Aumentar zoom")
                    }
                    .foregroundStyle(.white)
                    .glassEffect(.regular.tint(.black.opacity(0.5)), in: Capsule())
                    .position(x: 70, y: Self.photoHeight - 40)
                }
                .frame(width: Self.photoWidth, height: Self.photoHeight)
                .clipped()
                .coordinateSpace(name: "photo")
                .onAppear { sampler.prepare(image) }

            } else {
                Color.gray.opacity(0.2)
                    .frame(width: Self.photoWidth, height: Self.photoHeight)
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
            .frame(width: 103, height: Self.photoHeight)
            .background(.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color("borderLines").opacity(0.4), lineWidth: 0.8)
        }
    }

    private var currentColor: Color {
        switch selectedTarget {
        case .skin: return skinColor ?? .clear
        case .hair: return hairColor ?? .clear
        case .eyes: return eyeColor ?? .clear
        }
    }

    private var hasSelectedColor: Bool {
        switch selectedTarget {
        case .skin: return skinColor != nil
        case .hair: return hairColor != nil
        case .eyes: return eyeColor != nil
        }
    }

    private func clampedOffset(_ offset: CGSize) -> CGSize {
        let maxX = Self.photoWidth * (zoomScale - 1) / 2
        let maxY = Self.photoHeight * (zoomScale - 1) / 2
        return CGSize(
            width: min(max(offset.width, -maxX), maxX),
            height: min(max(offset.height, -maxY), maxY)
        )
    }

    private func sampleColor(at position: CGPoint, image: UIImage) {

        let center = CGPoint(x: Self.photoWidth / 2, y: Self.photoHeight / 2)

        let unzoomedX = center.x + (position.x - panOffset.width - center.x) / zoomScale
        let unzoomedY = center.y + (position.y - panOffset.height - center.y) / zoomScale

        let unzoomedPosition = CGPoint(x: unzoomedX, y: unzoomedY)

        guard let uiColor = sampler.color(
            from: image,
            at: unzoomedPosition,
            displayedSize: CGSize(width: Self.photoWidth, height: Self.photoHeight)
        ) else {
            return
        }

        let color = Color(uiColor)

        switch selectedTarget {
        case .skin: skinColor = color
        case .hair: hairColor = color
        case .eyes: eyeColor = color
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
                    .foregroundStyle(Color("textAttention").opacity(0.6))

                Circle()
                    .fill(color ?? .white)
                    .frame(width: 44, height: 44)
                    .overlay {
                        if color == nil && !isSelected {
                            Circle()
                                .strokeBorder(Color.gray.opacity(0.5), lineWidth: 1.5)
                        }
                    }
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
        image: UIImage(named: "teste"),
        skinColor: .constant(nil),
        hairColor: .constant(nil),
        eyeColor: .constant(nil)
    )
    .padding()
}
