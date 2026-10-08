//
//  GarmentBackgroundRemovalService.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 08/10/26.
//
import UIKit
import Vision

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

        guard let observation = request.results?.first else {
            throw GarmentBackgroundRemovalError.noForegroundFound
        }

        let instances = observation.allInstances

        guard !instances.isEmpty else {
            throw GarmentBackgroundRemovalError.noForegroundFound
        }

        let maskedPixelBuffer = try observation.generateMaskedImage(
            ofInstances: instances,
            from: handler,
            croppedToInstancesExtent: false
        )

        let ciImage = CIImage(cvPixelBuffer: maskedPixelBuffer)

        let context = CIContext()

        guard let outputCGImage = context.createCGImage(
            ciImage,
            from: ciImage.extent
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
