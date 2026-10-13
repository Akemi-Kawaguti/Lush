//
//  ColorSamplerService.swift
//  Lush
//
//  Lê a cor da foto no ponto do conta-gotas (tela da colorimetria).
//
//  Para o conta-gotas acompanhar o dedo sem atraso, a foto é preparada UMA VEZ
//  (em pé e reduzida, guardada como pixels na memória). A cada movimento do dedo
//  só lemos os pixels, sem redesenhar a foto inteira.
//

import UIKit

final class ColorSamplerService {

    /// Maior lado da cópia da foto usada para ler as cores.
    /// Suficiente mesmo com zoom de 3x no card, e bem mais leve que a foto original (12 MP).
    private let maxSide: CGFloat = 1500

    private var preparedImage: UIImage?
    private var pixels: [UInt8] = []
    private var width = 0
    private var height = 0

    /// Prepara a foto (pode ser chamado ao abrir a tela; se não for, é feito no primeiro uso).
    func prepare(_ image: UIImage) {
        guard image !== preparedImage else { return }

        let scale = min(1, maxSide / max(image.size.width, image.size.height))
        width = max(1, Int(image.size.width * scale))
        height = max(1, Int(image.size.height * scale))
        pixels = [UInt8](repeating: 0, count: width * height * 4)

        pixels.withUnsafeMutableBytes { buffer in
            guard let context = CGContext(
                data: buffer.baseAddress,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: width * 4,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ) else { return }

            // Desenha a foto já em pé (o draw do UIImage respeita a rotação da câmera).
            // O CGContext tem a origem embaixo; invertemos para a linha 0 ser o topo da foto.
            context.translateBy(x: 0, y: CGFloat(height))
            context.scaleBy(x: 1, y: -1)
            UIGraphicsPushContext(context)
            image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            UIGraphicsPopContext()
        }

        preparedImage = image
    }

    /// Cor no ponto do conta-gotas.
    /// - point: posição no card (em pontos), já sem zoom e sem arraste
    /// - displayedSize: tamanho do card onde a foto aparece com .scaledToFill()
    func color(from image: UIImage, at point: CGPoint, displayedSize: CGSize) -> UIColor? {
        prepare(image)
        guard width > 0, height > 0 else { return nil }

        let imageSize = image.size

        // O card usa .scaledToFill(): a foto é ampliada até cobrir o card e o excesso é cortado
        let scale = max(displayedSize.width / imageSize.width, displayedSize.height / imageSize.height)
        let offsetX = (imageSize.width * scale - displayedSize.width) / 2
        let offsetY = (imageSize.height * scale - displayedSize.height) / 2

        // Ponto do card → ponto da foto → pixel da cópia preparada
        let imageX = (point.x + offsetX) / scale
        let imageY = (point.y + offsetY) / scale
        let x = Int(imageX * CGFloat(width) / imageSize.width)
        let y = Int(imageY * CGFloat(height) / imageSize.height)

        guard x >= 0, x < width, y >= 0, y < height else { return nil }

        // Média de 3x3 pixels: evita pegar um pixel "solto" (ruído, reflexo, cílio)
        var red = 0, green = 0, blue = 0, count = 0
        for dy in -1...1 {
            for dx in -1...1 {
                let px = min(max(x + dx, 0), width - 1)
                let py = min(max(y + dy, 0), height - 1)
                let index = (py * width + px) * 4
                red += Int(pixels[index])
                green += Int(pixels[index + 1])
                blue += Int(pixels[index + 2])
                count += 1
            }
        }

        return UIColor(
            red: CGFloat(red) / CGFloat(count * 255),
            green: CGFloat(green) / CGFloat(count * 255),
            blue: CGFloat(blue) / CGFloat(count * 255),
            alpha: 1
        )
    }
}
