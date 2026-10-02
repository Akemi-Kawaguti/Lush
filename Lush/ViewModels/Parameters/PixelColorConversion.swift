//
//  PixelColorConversion.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 01/10/26.
//
// CONVERSÃO DE PIXEL PARA COR

import UIKit
import CoreImage

struct PixelColorConversion {
    
    private static let sharedContext = CIContext(options: nil)
    // grafico reutilizavel do CoreImage (CIContext)

    static func convertVisionPointsToPixels(points: [CGPoint], imageSize: CGSize) -> [CGPoint] {
        return points.map {
            CGPoint(x: $0.x * imageSize.width, y: (1.0 - $0.y) * imageSize.height)
        } // recebe pontos e dimensão da img
        //coloca map sobre cada ponto
        // converte coordenadas em pixel
        /*
         "o eixo Y no Vision começa de baixo para cima (0.0 na base), enquanto nas imagens em pixels ele começa de cima para baixo (0.0 no topo). Por isso, usa-se (1.0 - $0.y) para inverter o eixo Y corretamente
         */
    }

    static func convertViewPointToImagePixel(point: CGPoint, viewSize: CGSize, imageSize: CGSize) -> CGPoint? {
        let imageAspect = imageSize.width / imageSize.height
        let viewAspect = viewSize.width / viewSize.height
        // de ponto para pixel

        var drawRect = CGRect.zero
        if viewAspect > imageAspect {
            let height = viewSize.height
            let width = height * imageAspect
            let x = (viewSize.width - width) / 2.0
            drawRect = CGRect(x: x, y: 0, width: width, height: height)
        } else {
            let width = viewSize.width
            let height = width / imageAspect
            let y = (viewSize.height - height) / 2.0
            drawRect = CGRect(x: 0, y: y, width: width, height: height)
        } // caso aquela caixinha de 5x5 ficar perto da margem da img ele calcula pixel perto

        guard drawRect.contains(point) else { return nil }
        // se realmente tocar fora da img, retorna nil

        let normalizedX = (point.x - drawRect.origin.x) / drawRect.width
        let normalizedY = (point.y - drawRect.origin.y) / drawRect.height

        return CGPoint(
            x: normalizedX * imageSize.width,
            y: normalizedY * imageSize.height
        )  // restringe area do toque para entender melhor onde o usuario selecionou a cor
    }

    static func extractAverageColor(from cgImage: CGImage, points: [CGPoint], imageSize: CGSize) -> UIColor {
        // recebe a imagem do vision e tamanho da img
        let pixelPoints = convertVisionPointsToPixels(points: points, imageSize: imageSize)
        let xCoords = pixelPoints.map { $0.x }
        let yCoords = pixelPoints.map { $0.y }
        // converte meio q pra mapear a img

        guard let minX = xCoords.min(), let maxX = xCoords.max(),
              let minY = yCoords.min(), let maxY = yCoords.max() else {
            return .clear
        }

        let rect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY).integral //arredonda valores
        let safeRect = rect.intersection(CGRect(origin: .zero, size: imageSize))

        guard !safeRect.isNull, safeRect.width > 0, safeRect.height > 0,
              let croppedCGImage = cgImage.cropping(to: safeRect) else {
            return .clear
        }

        return dominantColor(from: croppedCGImage)
    } // se a parte for valida, ai sim pode retornar a cor predominante

    static func dominantColor(from cgImage: CGImage) -> UIColor {
        let ciImage = CIImage(cgImage: cgImage)

        guard let filter = CIFilter(name: "CIAreaAverage") else {
            return .clear
        }

        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(ciImage.extent, forKey: kCIInputExtentKey)

        guard let outputImage = filter.outputImage else {
            return .gray
        } // retorna cor media

        var bitmap = [UInt8](repeating: 0, count: 4)
        sharedContext.render(outputImage,
                             toBitmap: &bitmap,
                             rowBytes: 4,
                             bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                             format: .RGBA8,
                             colorSpace: nil)

        return UIColor(
            red: CGFloat(bitmap[0]) / 255.0,
            green: CGFloat(bitmap[1]) / 255.0,
            blue: CGFloat(bitmap[2]) / 255.0,
            alpha: CGFloat(bitmap[3]) / 255.0
        )
    } // finalmente podemos converter valores obtidos no vetor
    // criando objeto UIColor
}

// Extensão do UIImage colocada no nível global (fora da struct)
extension UIImage {
    func fixedOrientation() -> UIImage? {
        if imageOrientation == .up { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage
    } // força usuario posicionar corretamente a foto
}
