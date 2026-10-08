//
//  PhotoBodyMath.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 30/09/26.
//

import Vision
import UIKit

// MARK: - Calibração
// O Vision marca as ARTICULAÇÕES (ossos), não a silhueta. A largura real do corpo
// é maior que a distância entre as articulações, principalmente no quadril.
// Ajustem esses valores testando com fotos de pessoas cujo biotipo já é conhecido
// (por exemplo, comparando com o resultado pelas medidas).
private let shoulderSilhouetteFactor: CGFloat = 1.15
private let hipSilhouetteFactor: CGFloat = 1.75

// Confiança mínima de cada ponto (0 a 1). Abaixo disso, o ponto é ignorado.
private let minimumConfidence: Float = 0.3

// O tronco (do meio dos ombros ao meio do quadril) mede cerca de 30% da altura de um adulto.
// Usado só para converter pixels em centímetros; a classificação compara as medidas entre si.
private let torsoToHeightRatio: CGFloat = 0.30

func analyzeBodyProportions(in image: CGImage, userRealHeightCm: CGFloat) async -> BodyMeasure? {
    let request = VNDetectHumanBodyPoseRequest()
    let handler = VNImageRequestHandler(cgImage: image, options: [:])

    do {
        try handler.perform([request])
    } catch {
        print("Vision: erro ao processar a foto: \(error)")
        return nil
    }

    guard let observation = request.results?.first else {
        print("Vision: nenhuma pessoa encontrada na foto")
        return nil
    }

    guard let points = try? observation.recognizedPoints(.all) else {
        print("Vision: não foi possível ler os pontos do corpo")
        return nil
    }

    // Converte um ponto do Vision (0 a 1, origem embaixo) para pixels.
    // Assim, larguras e alturas ficam na mesma escala, mesmo em fotos retangulares.
    func pixelPoint(_ joint: VNHumanBodyPoseObservation.JointName) -> CGPoint? {
        guard let point = points[joint], point.confidence >= minimumConfidence else {
            print("Vision: ponto \(joint) não encontrado ou com pouca confiança")
            return nil
        }
        return CGPoint(
            x: point.location.x * CGFloat(image.width),
            y: point.location.y * CGFloat(image.height)
        )
    }

    guard let leftShoulder = pixelPoint(.leftShoulder),
          let rightShoulder = pixelPoint(.rightShoulder),
          let leftHip = pixelPoint(.leftHip),
          let rightHip = pixelPoint(.rightHip) else {
        return nil
    }

    // Larguras entre as articulações, corrigidas para a largura aproximada da silhueta
    let shoulderWidth = distance(from: leftShoulder, to: rightShoulder) * shoulderSilhouetteFactor
    let hipWidth = distance(from: leftHip, to: rightHip) * hipSilhouetteFactor

    // Tronco: do meio dos ombros ao meio do quadril
    let shoulderCenter = CGPoint(x: (leftShoulder.x + rightShoulder.x) / 2, y: (leftShoulder.y + rightShoulder.y) / 2)
    let hipCenter = CGPoint(x: (leftHip.x + rightHip.x) / 2, y: (leftHip.y + rightHip.y) / 2)
    let torsoLength = distance(from: shoulderCenter, to: hipCenter)

    guard shoulderWidth > 0, hipWidth > 0, torsoLength > 0 else {
        print("Vision: medidas inválidas")
        return nil
    }

    let waistCenter = CGPoint(x: (shoulderCenter.x + hipCenter.x) / 2, y: (shoulderCenter.y + hipCenter.y) / 2)

    let source = BodyInputSource.photo(
        shoulderPixels: shoulderWidth,
        hipPixels: hipWidth,
        waistCenter: waistCenter,
        skeletonHeightPixels: torsoLength / torsoToHeightRatio,   // altura estimada da pessoa, em pixels
        userRealHeightCm: userRealHeightCm
    )

    // Converte para centímetros (BodyConversion.swift)
    return processBodyData(from: source)
}

func distance(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
    // Teorema de Pitágoras: distância em linha reta entre dois pontos
    hypot(p2.x - p1.x, p2.y - p1.y)
}
