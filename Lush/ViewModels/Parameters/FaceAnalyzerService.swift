//
//  FaceAnalyzerService.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 02/10/26.
//
// USUARIO MANDA FOTO
// VISION ANALISA AUTOMATICAMENTE

import UIKit
import Vision

class FaceAnalyzerService {

    //recebe imagem e retorna dicionario de cores ou erro
    func analyzeFace(from image: UIImage, completion: @escaping (Result<[String: UIColor], Error>) -> Void) {
        guard let normalizedImage = image.fixedOrientation(),
              let cgImage = normalizedImage.cgImage else {
            completion(.failure(NSError(domain: "FaceAnalyzerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Imagem inválida ou corrompida."])))
            return
        } // Corrige a orientação da foto (fixedOrientation()) e converte o UIImage para um CGImage - representação bruta de pixels

        let imageSize = CGSize(width: cgImage.width, height: cgImage.height) // pega tamanho da foto
        let landmarksRequest = VNDetectFaceLandmarksRequest { request, error in
            if let error = error {
                completion(.failure(error))
                return
            } //  requisicao do Vision pra mapear pontos de referencia

            guard let observations = request.results as? [VNFaceObservation],
                  let face = observations.first,
                  let landmarks = face.landmarks else {
                completion(.failure(NSError(domain: "FaceAnalyzerError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Nenhum rosto detectado na imagem."])))
                return
            } // se tiver rosto da imagem (observation.first) extrai os pontos de referencia

            var extractedColors: [String: UIColor] = [:] // dicionario para colocar as cores dos pontos de referencia

            // Extração da cor da pele
            if let skinColor = self.extractSkinColor(from: cgImage, faceBox: face.boundingBox, imageSize: imageSize) {
                            extractedColors["pele"] = skinColor
                        }

            // Extração da cor dos olhos
            if let leftEye = landmarks.leftEye {
                extractedColors["olhoEsquerdo"] = PixelColorConversion.extractAverageColor(from: cgImage, points: leftEye.normalizedPoints, imageSize: imageSize)
            }

            if let rightEye = landmarks.rightEye {
                extractedColors["olhoDireito"] = PixelColorConversion.extractAverageColor(from: cgImage, points: rightEye.normalizedPoints, imageSize: imageSize)
            }

            // Extração de cabelo
            if let hairColor = self.extractHairColor(from: cgImage, faceBox: face.boundingBox, imageSize: imageSize) {
                extractedColors["cabelo"] = hairColor
            }

            completion(.success(extractedColors))
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([landmarksRequest])
            } catch {
                completion(.failure(error))
            }
        }
    }
    // Configura o manipulador de imagens do Vision (VNImageRequestHandler)
    // DispatchQueue.global - para evitar travamentos na interface

    private func extractHairColor(from cgImage: CGImage, faceBox: CGRect, imageSize: CGSize) -> UIColor? {
        let hairRect = CGRect(
            x: faceBox.origin.x * imageSize.width,
            y: (1.0 - (faceBox.origin.y + faceBox.height + 0.12)) * imageSize.height,
            width: faceBox.width * imageSize.width,
            height: faceBox.height * 0.35
        ).integral.intersection(CGRect(origin: .zero, size: imageSize))

        guard !hairRect.isNull, hairRect.width > 0, hairRect.height > 0,
              let cropped = cgImage.cropping(to: hairRect) else {
            return nil
        }

        return PixelColorConversion.dominantColor(from: cropped)
    }
    // O Vision não consegue pegar automaticamente o cabelo
    // por isso tem essa função que estima que o cabelo fica em cima da cabeça, não sei o que fazer com os careca
    // ver possibilidade de sobrancelha, se não tiver tambem, piorou
    
    // estima região da pele (ex: bochecha / centro superior do rosto, abaixo dos olhos/sobrancelhas)
        private func extractSkinColor(from cgImage: CGImage, faceBox: CGRect, imageSize: CGSize) -> UIColor? {
            // pega uma área central do rosto (geralmente na altura das bochechas/nariz, onde tem menos sombras profundas de olhos e boca)
            let skinRect = CGRect(
                x: (faceBox.origin.x + (faceBox.width * 0.3)) * imageSize.width,
                y: (1.0 - (faceBox.origin.y + (faceBox.height * 0.6))) * imageSize.height,
                width: faceBox.width * 0.4 * imageSize.width,
                height: faceBox.height * 0.2 * imageSize.height
            ).integral.intersection(CGRect(origin: .zero, size: imageSize))

            guard !skinRect.isNull, skinRect.width > 0, skinRect.height > 0,
                  let cropped = cgImage.cropping(to: skinRect) else {
                return nil
            }

            return PixelColorConversion.dominantColor(from: cropped)
        }
}
