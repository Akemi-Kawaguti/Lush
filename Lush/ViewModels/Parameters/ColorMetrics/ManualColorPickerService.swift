//
//  ManualColorPickerService.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 02/10/26.
//
// USUARIO MANDA FOTO
// USUARIO ANALISA MANUALMENTE

import UIKit

class ManualColorPickerService {

    func pickColor(from image: UIImage, at pointInView: CGPoint, inViewSize viewSize: CGSize) -> UIColor? {
        // recebe como parametros: img q o usuario mandou, onde ele tocou, tamanho da tela onde vai ser exibida
        // retorna cor
        guard let normalizedImage = image.fixedOrientation(),
              let cgImage = normalizedImage.cgImage else {
            return nil
        } // deixa fixo um tipo de orientação para foto que mandarem

        let imageWidth = CGFloat(cgImage.width)
        let imageHeight = CGFloat(cgImage.height)

        // Converte as coordenadas da interface para o sistema de pixels reais da CGImage
        /*
         traduzir o ponto onde o usuário tocou na tela (pointInView na viewSize) para o sistema de coordenadas reais da imagem (imageSize)"
         */
        // Se a conversão falhar (ex: toque fora da imagem), retorna nil.
        guard let pixelPoint = PixelColorConversion.convertViewPointToImagePixel(
            point: pointInView,
            viewSize: viewSize,
            imageSize: CGSize(width: imageWidth, height: imageHeight)

        ) else {
            return nil
        }

        // Define uma pequena área (sample box) ao redor do toque para capturar uma média estável (ex: 5x5 pixels)
        let sampleSize: CGFloat = 5.0
        let rect = CGRect(
            x: pixelPoint.x - (sampleSize / 2),
            y: pixelPoint.y - (sampleSize / 2),
            width: sampleSize,
            height: sampleSize
        ).integral

        let imageRect = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight) // evitar erro de confundir com parte fora da imagem
        let safeRect = rect.intersection(imageRect)

        guard !safeRect.isNull, safeRect.width > 0, safeRect.height > 0,
              let croppedCGImage = cgImage.cropping(to: safeRect) else {
            return nil
        } // em resumo, pega uma area um pouquinho maior, por conta de imperfeições, etc

        return PixelColorConversion.dominantColor(from: croppedCGImage)
    } // retorna a cor dominante daquele bloquinho 5x5 pixels
}
