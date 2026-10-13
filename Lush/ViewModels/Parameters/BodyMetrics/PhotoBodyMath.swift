//
//  PhotoBodyMath.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 30/09/26.
//

//  Mede ombros, cintura e quadril a partir de uma foto de corpo inteiro, de frente.
//
//  Usa dois recursos do Vision:
//  1. Pose (VNDetectHumanBodyPoseRequest): acha ombros e quadris, para saber
//     EM QUE ALTURA da foto fica cada parte do tronco.
//  2. Segmentação de pessoa (VNGeneratePersonSegmentationRequest): devolve a SILHUETA
//     da pessoa (máscara: corpo = claro, fundo = escuro). Nela medimos a LARGURA REAL
//     do corpo linha por linha.
//
//  - Ombros: largura da silhueta na altura dos ombros
//  - Cintura: a linha MAIS ESTREITA do tronco (entre ombros e quadril)
//  - Quadril: a linha MAIS LARGA logo abaixo da articulação do quadril
//  - Barriga: a linha MAIS LARGA do meio do tronco (para identificar o biotipo Oval)
//


import Vision
import UIKit

// MARK: - Erros (mensagens mostradas para a usuária)

nonisolated enum PhotoBodyError: LocalizedError {
    case noPerson
    case bodyNotVisible
    case notFacingFront
    case armsTouchingBody
    case segmentationFailed

    var errorDescription: String? {
        switch self {
        case .noPerson:
            "Não encontramos uma pessoa na foto. Tente uma foto de corpo inteiro, com boa iluminação."
        case .bodyNotVisible:
            "Não conseguimos ver seus ombros e quadril. Tire a foto de corpo inteiro, com a câmera um pouco mais longe."
        case .notFacingFront:
            "Parece que a foto está de lado. Fique de frente para a câmera."
        case .armsTouchingBody:
            "Seus braços estão encostados no corpo. Afaste um pouco os braços para medirmos sua cintura e quadril."
        case .segmentationFailed:
            "Não conseguimos analisar a foto. Tente outra foto, com fundo liso e boa iluminação."
        }
    }
}

// MARK: - Função usada pelo app

// Mede o corpo na foto e devolve as medidas em centímetros (contornos aproximados).
// Lança `PhotoBodyError` com a mensagem certa quando a foto não serve.
func analyzeBodyProportions(in image: CGImage, userRealHeightCm: CGFloat) async throws -> BodyMeasure {
    // O Vision é pesado: roda fora da thread principal para a tela não travar
    let input = SendableImage(image: image)
    let widths = try await Task.detached(priority: .userInitiated) {
        try PhotoBodyMeasurer.measure(input.image)
    }.value

    // Pixels ->centímetros: o tronco (ombros até quadril) mede ~30% da altura de um adulto
    let estimatedHeightPixels = widths.torsoLength / PhotoBodyMeasurer.torsoToHeightRatio
    let cmPerPixel = userRealHeightCm / estimatedHeightPixels

    // A foto mostra larguras; a regra do biotipo usa contornos (fita métrica em volta).
    // O contorno é proporcional à largura; cada parte do corpo tem uma "profundidade" diferente.
    let shoulder = widths.shoulder * cmPerPixel * PhotoBodyMeasurer.shoulderWidthToCircumference
    let hip = widths.hip * cmPerPixel * PhotoBodyMeasurer.hipWidthToCircumference
    var waist = widths.waist * cmPerPixel * PhotoBodyMeasurer.waistWidthToCircumference
    let belly = widths.belly * cmPerPixel * PhotoBodyMeasurer.waistWidthToCircumference

    // Oval: a barriga é a parte mais larga do tronco. De frente ela aparece menor do que é
    // (cresce mais para a frente do que para os lados), por isso uma tolerância:
    // se a barriga for quase tão larga quanto ombros/quadril, conta como a maior medida.
    let larger = max(shoulder, hip)
    if belly >= larger * PhotoBodyMeasurer.ovalBellyTolerance {
        waist = max(belly, larger)
    }

    print("Vision: contornos estimados (cm) ombros \(Int(shoulder)), cintura \(Int(waist)), quadril \(Int(hip)), barriga \(Int(belly))")

    return BodyMeasure(shoulder: shoulder, waist: waist, hip: hip)
}

nonisolated func distance(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
    // Teorema de Pitágoras: distância em linha reta entre dois pontos
    hypot(p2.x - p1.x, p2.y - p1.y)
}

// MARK: - Medição (roda fora da thread principal)

// Embrulho para passar a imagem para outra thread.
nonisolated struct SendableImage: @unchecked Sendable {
    let image: CGImage
}

nonisolated enum PhotoBodyMeasurer {

    // Larguras do corpo em pixels da foto.
    struct Widths: Sendable {
        let shoulder: CGFloat
        let waist: CGFloat
        let belly: CGFloat
        let hip: CGFloat
        let torsoLength: CGFloat
    }

    // MARK: Calibração
    // Ajustem testando com fotos de pessoas cujas medidas (fita métrica) são conhecidas.

    // Confiança mínima de cada ponto do Vision (0 a 1).
    static let minimumConfidence: Float = 0.3
    // O tronco (meio dos ombros até meio do quadril) mede cerca de 30% da altura.
    static let torsoToHeightRatio: CGFloat = 0.30
    // Largura de frente -> contorno. Cada parte do corpo tem uma "profundidade" diferente:
    // ombros são largos e rasos; cintura e quadril são mais "redondos".
    static let shoulderWidthToCircumference: CGFloat = 2.45
    static let waistWidthToCircumference: CGFloat = 2.75
    static let hipWidthToCircumference: CGFloat = 2.65

    // Onde procurar a cintura: entre 40% e 95% do caminho dos ombros até o quadril.
    static let waistSearchRange: ClosedRange<CGFloat> = 0.40...0.95
    // Onde procurar a barriga (parte mais larga do meio do tronco, para o biotipo Oval).
    // Termina antes do quadril começar a abrir, para não confundir quadril largo com barriga.
    static let bellySearchRange: ClosedRange<CGFloat> = 0.45...0.72
    // Barriga a partir de 92% da maior medida (ombros ou quadril) já conta como Oval.
    static let ovalBellyTolerance: CGFloat = 0.92
    // Onde procurar o quadril: de um pouco acima da articulação até 40% do tronco abaixo dela.
    static let hipSearchRange: ClosedRange<CGFloat> = -0.05...0.40

    static func measure(_ image: CGImage) throws -> Widths {
        // 1. Roda pose e segmentação na mesma foto
        let poseRequest = VNDetectHumanBodyPoseRequest()
        let segmentationRequest = VNGeneratePersonSegmentationRequest()
        segmentationRequest.qualityLevel = .accurate
        segmentationRequest.outputPixelFormat = kCVPixelFormatType_OneComponent8

        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        do {
            try handler.perform([poseRequest, segmentationRequest])
        } catch {
            print("Vision: erro ao processar a foto: \(error)")
            throw PhotoBodyError.segmentationFailed
        }

        guard let pose = poseRequest.results?.first else { throw PhotoBodyError.noPerson }
        guard let maskBuffer = segmentationRequest.results?.first?.pixelBuffer else {
            throw PhotoBodyError.segmentationFailed
        }
        guard let points = try? pose.recognizedPoints(.all) else { throw PhotoBodyError.noPerson }

        // 2. Lê a máscara (silhueta)
        CVPixelBufferLockBaseAddress(maskBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(maskBuffer, .readOnly) }

        guard let base = CVPixelBufferGetBaseAddress(maskBuffer) else {
            throw PhotoBodyError.segmentationFailed
        }
        let mask = Mask(
            pixels: base.assumingMemoryBound(to: UInt8.self),
            width: CVPixelBufferGetWidth(maskBuffer),
            height: CVPixelBufferGetHeight(maskBuffer),
            bytesPerRow: CVPixelBufferGetBytesPerRow(maskBuffer)
        )

        // Ponto do Vision (0 a 1, origem embaixo) -> coordenada da máscara (pixels, origem em cima)
        func maskPoint(_ joint: VNHumanBodyPoseObservation.JointName) -> CGPoint? {
            guard let point = points[joint], point.confidence >= minimumConfidence else { return nil }
            return CGPoint(
                x: point.location.x * CGFloat(mask.width),
                y: (1 - point.location.y) * CGFloat(mask.height)
            )
        }

        guard let leftShoulder = maskPoint(.leftShoulder),
              let rightShoulder = maskPoint(.rightShoulder),
              let leftHip = maskPoint(.leftHip),
              let rightHip = maskPoint(.rightHip) else {
            throw PhotoBodyError.bodyNotVisible
        }

        let shoulderCenter = CGPoint(x: (leftShoulder.x + rightShoulder.x) / 2, y: (leftShoulder.y + rightShoulder.y) / 2)
        let hipCenter = CGPoint(x: (leftHip.x + rightHip.x) / 2, y: (leftHip.y + rightHip.y) / 2)
        let torso = hipCenter.y - shoulderCenter.y   // em linhas da máscara (quadril fica abaixo dos ombros)

        // Pessoa muito pequena na foto, deitada ou de cabeça para baixo
        guard torso > CGFloat(mask.height) * 0.08 else { throw PhotoBodyError.bodyNotVisible }

        // De lado: os ombros ficam quase um em cima do outro
        guard distance(from: leftShoulder, to: rightShoulder) > torso * 0.4 else {
            throw PhotoBodyError.notFacingFront
        }

        // Centro do corpo em cada linha (acompanha o tronco se a pessoa estiver um pouco inclinada)
        func centerX(atRow row: CGFloat) -> CGFloat {
            let t = min(max((row - shoulderCenter.y) / torso, 0), 1)
            return shoulderCenter.x + (hipCenter.x - shoulderCenter.x) * t
        }

        func rowAt(fractionOfTorso fraction: CGFloat, from origin: CGFloat) -> Int {
            Int((origin + torso * fraction).rounded())
        }

        // 3. Braços encostados no corpo deixam cintura e quadril "largos demais"
        for joint in [VNHumanBodyPoseObservation.JointName.leftElbow, .rightElbow, .leftWrist, .rightWrist] {
            guard let point = maskPoint(joint) else { continue }
            let row = Int(point.y.rounded())
            let isAtTorsoHeight = point.y > shoulderCenter.y + torso * 0.2 && point.y < hipCenter.y + torso * 0.4
            if isAtTorsoHeight,
               let segment = mask.bodySegment(row: row, centerX: centerX(atRow: point.y)),
               segment.contains(Int(point.x.rounded())) {
                throw PhotoBodyError.armsTouchingBody
            }
        }

        // 4. Larguras
        // Ombros: largura na altura dos ombros (mediana de algumas linhas, para tirar ruído)
        let shoulderRows = rowAt(fractionOfTorso: -0.03, from: shoulderCenter.y)...rowAt(fractionOfTorso: 0.03, from: shoulderCenter.y)
        let shoulderWidths = shoulderRows.compactMap { mask.bodyWidth(row: $0, centerX: centerX(atRow: CGFloat($0))) }

        // Cintura: a linha mais estreita do tronco
        let waistRows = rowAt(fractionOfTorso: waistSearchRange.lowerBound, from: shoulderCenter.y)...rowAt(fractionOfTorso: waistSearchRange.upperBound, from: shoulderCenter.y)
        let waistWidths = waistRows.compactMap { mask.bodyWidth(row: $0, centerX: centerX(atRow: CGFloat($0))) }

        // Barriga: a linha mais larga do meio do tronco (abaixo do busto)
        let bellyRows = rowAt(fractionOfTorso: bellySearchRange.lowerBound, from: shoulderCenter.y)...rowAt(fractionOfTorso: bellySearchRange.upperBound, from: shoulderCenter.y)
        let bellyWidths = bellyRows.compactMap { mask.bodyWidth(row: $0, centerX: centerX(atRow: CGFloat($0))) }

        // Quadril: a linha mais larga logo abaixo da articulação
        // (para sozinho no meio das pernas, onde o centro deixa de ser corpo)
        var hipWidths: [CGFloat] = []
        for row in rowAt(fractionOfTorso: hipSearchRange.lowerBound, from: hipCenter.y)...rowAt(fractionOfTorso: hipSearchRange.upperBound, from: hipCenter.y) {
            guard let width = mask.bodyWidth(row: row, centerX: hipCenter.x) else { break }
            hipWidths.append(width)
        }

        guard let shoulder = median(shoulderWidths),
              let waist = smoothed(waistWidths).min(),
              let belly = smoothed(bellyWidths).max(),
              let hip = smoothed(hipWidths).max() else {
            throw PhotoBodyError.bodyNotVisible
        }

        // Máscara -> pixels da foto (a máscara pode ter outra resolução)
        let scaleX = CGFloat(image.width) / CGFloat(mask.width)
        let scaleY = CGFloat(image.height) / CGFloat(mask.height)

        print("Vision: larguras na máscara: ombros \(shoulder), cintura \(waist), barriga \(belly), quadril \(hip)")

        return Widths(
            shoulder: shoulder * scaleX,
            waist: waist * scaleX,
            belly: belly * scaleX,
            hip: hip * scaleX,
            torsoLength: torso * scaleY
        )
    }

    // Mediana (valor do meio): ignora linhas com ruído.
    private static func median(_ values: [CGFloat]) -> CGFloat? {
        guard !values.isEmpty else { return nil }
        return values.sorted()[values.count / 2]
    }

    // Mediana móvel de 5 linhas: evita que uma linha com falha vire a cintura ou o quadril.
    private static func smoothed(_ values: [CGFloat]) -> [CGFloat] {
        guard values.count >= 5 else { return values }
        return (2..<(values.count - 2)).compactMap { median(Array(values[($0 - 2)...($0 + 2)])) }
    }
}

// MARK: - Máscara da silhueta

private nonisolated struct Mask {
    let pixels: UnsafePointer<UInt8>
    let width: Int
    let height: Int
    let bytesPerRow: Int

    // O pixel é corpo? (máscara vai de 0 = fundo a 255 = pessoa)
    func isBody(x: Int, y: Int) -> Bool {
        guard x >= 0, x < width, y >= 0, y < height else { return false }
        return pixels[y * bytesPerRow + x] > 127
    }

    // Trecho contínuo de corpo, nessa linha, que contém o centro do corpo.
    // Se o braço estiver separado do tronco, ele fica de fora.
    func bodySegment(row: Int, centerX: CGFloat) -> ClosedRange<Int>? {
        guard row >= 0, row < height else { return nil }

        // Acha um pixel de corpo perto do centro
        let center = Int(centerX.rounded())
        guard let start = (0...3).flatMap({ [center - $0, center + $0] }).first(where: { isBody(x: $0, y: row) }) else {
            return nil
        }

        // Anda para os lados até o corpo acabar (tolera 1 pixel de falha na máscara)
        func edge(step: Int) -> Int {
            var x = start
            var last = start
            var misses = 0
            while misses <= 1 {
                x += step
                if x < 0 || x >= width { break }
                if isBody(x: x, y: row) {
                    last = x
                    misses = 0
                } else {
                    misses += 1
                }
            }
            return last
        }

        return edge(step: -1)...edge(step: 1)
    }

    func bodyWidth(row: Int, centerX: CGFloat) -> CGFloat? {
        guard let segment = bodySegment(row: row, centerX: centerX) else { return nil }
        return CGFloat(segment.count)
    }
}
