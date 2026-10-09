//
//  CameraView.swift
//  Lush
//

import SwiftUI
import AVFoundation
import UIKit

struct CameraView: UIViewControllerRepresentable {
    
    let onImageCaptured: (UIImage) -> Void
    let onCancel: () -> Void
    
    func makeUIViewController(
        context: Context
    ) -> CameraViewController {
        
        let viewController = CameraViewController()
        
        viewController.onImageCaptured = onImageCaptured
        viewController.onCancel = onCancel
        
        return viewController
    }
    
    func updateUIViewController(
        _ uiViewController: CameraViewController,
        context: Context
    ) {
    }
}

final class CameraViewController: UIViewController {
    
    var onImageCaptured: ((UIImage) -> Void)?
    var onCancel: (() -> Void)?
    
    private let imagePicker = UIImagePickerController()
    private var hasPresentedCamera = false
    
    override func viewDidAppear(
        _ animated: Bool
    ) {
        super.viewDidAppear(animated)
        
        guard !hasPresentedCamera else {
            return
        }
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            onCancel?()
            return
        }
        
        hasPresentedCamera = true
        
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        present(
            imagePicker,
            animated: true
        )
    }
}

extension CameraViewController: UIImagePickerControllerDelegate,
                                UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [
            UIImagePickerController.InfoKey: Any
        ]
    ) {
        
        if let image = info[.originalImage] as? UIImage {
            let renderer = UIGraphicsImageRenderer(size: image.size)

            let normalizedImage = renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: image.size))
            }

            onImageCaptured?(normalizedImage)
        }
        
        picker.dismiss(
            animated: true
        )
    }
    
    func imagePickerControllerDidCancel(
        _ picker: UIImagePickerController
    ) {
        
        picker.dismiss(
            animated: true
        ) { [weak self] in
            self?.onCancel?()
        }
    }
}
