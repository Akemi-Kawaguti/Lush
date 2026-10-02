import UIKit

struct ColorSamplerService {

    func color(
        from image: UIImage,
        at point: CGPoint,
        displayedSize: CGSize
    ) -> UIColor? {

        // normaliza a orientação da UIImage
        guard let normalizedImage = normalizedImage(from: image),
              let cgImage = normalizedImage.cgImage else {
            return nil
        }

        let imageWidth = CGFloat(cgImage.width)
        let imageHeight = CGFloat(cgImage.height)

        // o card utiliza .scaledToFill().
        let scale = max(
            displayedSize.width / imageWidth,
            displayedSize.height / imageHeight)

        let scaledWidth = imageWidth * scale
        let scaledHeight = imageHeight * scale

        // parte da imagem que fica fora do card.
        let offsetX = (scaledWidth - displayedSize.width) / 2
        let offsetY = (scaledHeight - displayedSize.height) / 2

        // posição do conta-gotas dentro da imagem exibida.
        let imageX = (point.x + offsetX) / scale
        let imageY = (point.y + offsetY) / scale

        let x = Int(imageX)
        let y = Int(imageY)

        guard x >= 0,
              x < cgImage.width,
              y >= 0,
              y < cgImage.height else {
            return nil
        }


        let width = cgImage.width
        let height = cgImage.height

        var pixel = [UInt8](repeating: 0, count: 4)

        guard let context = CGContext(
            data: &pixel,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return nil
        }

       
        let contextY = height - y - 1

        context.translateBy(
            x: CGFloat(-x),
            y: CGFloat(-contextY)
        )

        context.draw(
            cgImage,
            in: CGRect(
                x: 0,
                y: 0,
                width: width,
                height: height
            )
        )

        let red = CGFloat(pixel[0]) / 255
        let green = CGFloat(pixel[1]) / 255
        let blue = CGFloat(pixel[2]) / 255

        return UIColor(
            red: red,
            green: green,
            blue: blue,
            alpha: 1
        )
    }


    private func normalizedImage(
        from image: UIImage
    ) -> UIImage? {

        guard image.imageOrientation != .up else {
            return image
        }

        let renderer = UIGraphicsImageRenderer(
            size: image.size
        )

        return renderer.image { _ in
            image.draw(
                in: CGRect(
                    origin: .zero,
                    size: image.size
                )
            )
        }
    }
}
