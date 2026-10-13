//
//  GarmentColorAnalysisService.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 08/10/26.
//
import UIKit

struct GarmentColorAnalysisService {

    static func predominantColors(
        from image: UIImage,
        numberOfColors: Int = 4
    ) -> [UIColor] {

        guard let cgImage = image.cgImage else {
            return []
        }

        let width = 100
        let height = max(
            1,
            Int(
                CGFloat(cgImage.height) *
                CGFloat(width) /
                CGFloat(cgImage.width)
            )
        )

        let colorSpace = CGColorSpaceCreateDeviceRGB()

        var pixels = [UInt8](
            repeating: 0,
            count: width * height * 4
        )

        guard let context = CGContext(
            data: &pixels,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return []
        }

        context.draw(
            cgImage,
            in: CGRect(
                x: 0,
                y: 0,
                width: width,
                height: height
            )
        )

        var samples: [(r: CGFloat, g: CGFloat, b: CGFloat)] = []

        for index in stride(
            from: 0,
            to: pixels.count,
            by: 4
        ) {
            let alpha = CGFloat(pixels[index + 3]) / 255

            // Ignora o fundo transparente.
            guard alpha > 0.5 else {
                continue
            }

            let red = CGFloat(pixels[index]) / 255
            let green = CGFloat(pixels[index + 1]) / 255
            let blue = CGFloat(pixels[index + 2]) / 255

            samples.append(
                (red, green, blue)
            )
        }

        guard !samples.isEmpty else {
            return []
        }

        var clusters: [
            (r: CGFloat, g: CGFloat, b: CGFloat, count: Int)
        ] = []

        let step = max(
            1,
            samples.count / numberOfColors
        )

        for index in stride(
            from: 0,
            to: samples.count,
            by: step
        ) {
            let sample = samples[index]

            clusters.append(
                (
                    sample.r,
                    sample.g,
                    sample.b,
                    0
                )
            )

            if clusters.count == numberOfColors {
                break
            }
        }

        while clusters.count < numberOfColors {
            let sample = samples[
                min(
                    clusters.count,
                    samples.count - 1
                )
            ]

            clusters.append(
                (
                    sample.r,
                    sample.g,
                    sample.b,
                    0
                )
            )
        }

        for _ in 0..<8 {

            var totals = Array(
                repeating: (
                    r: CGFloat.zero,
                    g: CGFloat.zero,
                    b: CGFloat.zero,
                    count: 0
                ),
                count: clusters.count
            )

            for sample in samples {

                var closestIndex = 0
                var smallestDistance = CGFloat.greatestFiniteMagnitude

                for index in clusters.indices {

                    let cluster = clusters[index]

                    let distance =
                        pow(sample.r - cluster.r, 2) +
                        pow(sample.g - cluster.g, 2) +
                        pow(sample.b - cluster.b, 2)

                    if distance < smallestDistance {
                        smallestDistance = distance
                        closestIndex = index
                    }
                }

                totals[closestIndex].r += sample.r
                totals[closestIndex].g += sample.g
                totals[closestIndex].b += sample.b
                totals[closestIndex].count += 1
            }

            for index in clusters.indices {

                let total = totals[index]

                guard total.count > 0 else {
                    continue
                }

                clusters[index] = (
                    total.r / CGFloat(total.count),
                    total.g / CGFloat(total.count),
                    total.b / CGFloat(total.count),
                    total.count
                )
            }
        }

        return clusters
            .sorted { $0.count > $1.count }
            .map {
                UIColor(
                    red: $0.r,
                    green: $0.g,
                    blue: $0.b,
                    alpha: 1
                )
            }
    }
}
