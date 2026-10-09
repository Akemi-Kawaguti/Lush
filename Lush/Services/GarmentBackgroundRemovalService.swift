//
//  GarmentBackgroundRemovalService.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 08/10/26.
//

import UIKit
import Vision
import CoreImage
import ImageIO

enum GarmentBackgroundRemovalError: LocalizedError {
    case invalidImage
    case noForegroundFound

    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Não foi possível processar a imagem."
        case .noForegroundFound:
            return "Não foi possível identificar a peça de roupa."
        }
    }
}

struct GarmentBackgroundRemovalService {

    static func removeBackground(from image: UIImage) throws -> UIImage {

        guard let cgImage = image.cgImage else {
            throw GarmentBackgroundRemovalError.invalidImage
        }

        let request = VNGenerateForegroundInstanceMaskRequest()

        let handler = VNImageRequestHandler(
            cgImage: cgImage,
            orientation: CGImagePropertyOrientation(image.imageOrientation)
        )

        try handler.perform([request])

        guard let observation = request.results?.first,
              !observation.allInstances.isEmpty else {
            throw GarmentBackgroundRemovalError.noForegroundFound
        }

        let instances = observation.allInstances
        
        let maskPixelBuffer = try observation.generateScaledMaskForImage(
            forInstances: instances,
            from: handler
        )

        let originalCIImage = CIImage(cgImage: cgImage)
        let maskCIImage = CIImage(cvPixelBuffer: maskPixelBuffer)

        let scaledMask = maskCIImage.transformed(
            by: CGAffineTransform(
                scaleX: originalCIImage.extent.width / maskCIImage.extent.width,
                y: originalCIImage.extent.height / maskCIImage.extent.height
            )
        )

        let transparentBackground = CIImage(
            color: CIColor.clear
        ).cropped(to: originalCIImage.extent)

        let outputImage = originalCIImage.applyingFilter(
            "CIBlendWithMask",
            parameters: [
                kCIInputBackgroundImageKey: transparentBackground,
                kCIInputMaskImageKey: scaledMask
            ]
        )

        let context = CIContext()

        guard let outputCGImage = context.createCGImage(
            outputImage,
            from: originalCIImage.extent
        ) else {
            throw GarmentBackgroundRemovalError.invalidImage
        }

        return UIImage(
            cgImage: outputCGImage,
            scale: image.scale,
            orientation: image.imageOrientation
        )

    }
}

