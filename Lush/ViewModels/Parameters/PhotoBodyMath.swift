//
//  PhotoBodyMath.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 30/09/26.
//

import Vision
import UIKit

func analyzeBodyProportions(in image: CGImage, userRealHeightCm: CGFloat) async -> BodyMeasure? {
    let request = VNDetectHumanBodyPoseRequest()
    let handler = VNImageRequestHandler(cgImage: image, options: [:])
    
    do{
        try handler.perform([request])
        
        guard let observation = request.results?.first else {
            print("Nenhuma pessoa foi encontrada")
            return nil
        }
        
        let leftShoulder = try observation.recognizedPoint(.leftShoulder)
        let rightShoulder = try observation.recognizedPoint(.rightShoulder)
        let leftHip = try observation.recognizedPoint(.leftHip)
        let rightHip = try observation.recognizedPoint(.rightHip)
        
        let nose = try observation.recognizedPoint(.nose)
        let leftAnkle = try observation.recognizedPoint(.leftAnkle)
        let rightAnkle = try observation.recognizedPoint(.rightAnkle)
        
        guard leftShoulder.confidence > 0.6,
              rightShoulder.confidence > 0.6,
              leftHip.confidence > 0.6,
              rightHip.confidence > 0.6,
              nose.confidence > 0.5,
              leftAnkle.confidence > 0.5 else {
            print ("A qualidade ou a visibilidade da foto não é ideal")
            return nil
        }
        
        let shoulderWidth = distance(from: leftShoulder.location, to: rightShoulder.location) //calcula ditancia do ombro
        let hipWidth = distance(from: leftHip.location, to: rightHip.location) // calcula distancia do quadril
        
        //MARK: Cintura
        //Vision não tem um ponto especifico como tem para quadril e ombros
        //por isso peguei a diferença no plano cartesiano entre ombro e quadril
        //assim temos a proporção da silhueta
            let midShoulderX = (leftShoulder.location.x + rightShoulder.location.x) / 2
            let midShoulderY = (leftShoulder.location.y + rightShoulder.location.y) / 2
            let midHipX = (leftHip.location.x + rightHip.location.x) / 2
            let midHipY = (leftHip.location.y + rightHip.location.y) / 2
        
        let waistCenter = CGPoint(x: (midShoulderX + midHipX)/2, y: (midShoulderY + midHipY)/2) //calcula medida estimada da cintura
        
        // MARK: Cálculo da Altura Estimada do Corpo (Head-to-Toe)
                // Como o nariz não é o topo da cabeça e o tornozelo não é a sola do pé:
                // Estimamos que a distância do nariz ao topo da cabeça vale aproximadamente 1.5x a distância dos olhos/nariz,
                // ou usamos uma proporção anatômica padrão onde a altura total do corpo é ~7.5 a 8 vezes o tamanho da cabeça,
                // ou de forma prática no Vision: Adicionamos uma margem superior para o crânio e inferior para os pés.
                
                let rawSkeletonHeight = distance(from: nose.location, to: leftAnkle.location)
                
                // Fator de correção anatômica aproximada para cobrir o topo da cabeça até a sola do pé
                // (Já que o nariz até o tornozelo representa cerca de 75-80% da altura total em pé)
                let estimatedTotalBodyHeightPixels = rawSkeletonHeight * 1.25
        
        let source = BodyInputSource.photo(
                    shoulderPixels: shoulderWidth,
                    hipPixels: hipWidth,
                    waistCenter: waistCenter,
                    skeletonHeightPixels: estimatedTotalBodyHeightPixels,
                    userRealHeightCm: userRealHeightCm
                )
                
                // Processando e retornando as medidas em centímetros
                return processBodyData(from: source)
        
    } catch {
        print("Deu ruim ao processar a pose: \(error)")
        print ("Faz uma pose melhor")
        return nil
    }
}

func distance(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
    return hypot(p2.x - p1.x, p2.y - p1.y)
    
    /*
     função nativa hypot do Swift para aplicar o Teorema de Pitágoras e descobrir a largura exata em pixels entre o ombro esquerdo e o direito, ou entre o quadril esquerdo e o direito
     */
}


