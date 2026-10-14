//
//  VideoPlayerView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//

//  Toca um vídeo do app uma vez, sem controles, com fundo transparente
//  (suporta vídeo com canal alfa — HEVC com transparência).
//  Chama `onFinish` quando o vídeo termina — ou na hora, se o arquivo não existir.
//
//  Uso:
//  VideoPlayerView(fileName: "splash", fileExtension: "mov") {
//      // vídeo terminou
//  }
//
//  Em loop (ex.: carregamento):
//  VideoPlayerView(fileName: "analyzing", loops: true, rate: 1)
//

import AVFoundation
import SwiftUI

struct VideoPlayerView: UIViewRepresentable {

    let fileName: String
    var fileExtension: String = "mov"
    var loops: Bool = false
    var rate: Float = 2.5
    var onFinish: () -> Void = {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> PlayerUIView {
        let view = PlayerUIView()

        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else { #if DEBUG
            print(" Vídeo \(fileName).\(fileExtension) não encontrado no app") #endif
            DispatchQueue.main.async { onFinish() }   // não deixa a splash travada
            return view
        }

        // Não interrompe a música que a usuária estiver ouvindo
        try? AVAudioSession.sharedInstance().setCategory(.ambient)

        let item = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: item)
        view.playerLayer.player = player

        context.coordinator.endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak player] _ in
            if loops {
                player?.seek(to: .zero)
                player?.playImmediately(atRate: rate)
            } else {
                onFinish()
            }
        }

        player.playImmediately(atRate: rate)
        return view
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {}

    static func dismantleUIView(_ uiView: PlayerUIView, coordinator: Coordinator) {
        uiView.playerLayer.player?.pause()
        if let observer = coordinator.endObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    final class Coordinator {
        var endObserver: NSObjectProtocol?
    }
}

// UIView cuja camada é um AVPlayerLayer (fundo transparente).
final class PlayerUIView: UIView {

    override static var layerClass: AnyClass { AVPlayerLayer.self }

    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        playerLayer.backgroundColor = UIColor.clear.cgColor
        playerLayer.videoGravity = .resizeAspect
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) não é usado")
    }
}
