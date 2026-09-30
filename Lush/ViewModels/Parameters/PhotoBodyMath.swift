//
//  PhotoBodyMath.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 30/09/26.
//

import Vision
import UIKit

func analyzeBodyProportions(in image: CGImage) async{
    let request = VNDetectHumanBodyPoseRequest()
    
    let handler = VNImageRequestHandler(cgImage: image, options: [:])
    
    do{
        try handler.perform([request])
        
        guard let observation = request.results?.first else{
            print("Nenhuma pessoa foi encontrada")
            return
        }
        
        let leftShoulder = try observation.recognizedPoint(.leftShoulder)
        let rightShoulder = try observation.recognizedPoint(.rightShoulder)
        let leftHip = try observation.recognizedPoint(.leftHip)
        let rightHip = try observation.recognizedPoint(.rightHip)
        
        guard leftShoulder.confidence > 0.6,
              rightShoulder.confidence > 0.6,
              leftHip.confidence > 0.6,
              rightHip.confidence > 0.6 else {
            print ("A qualidade ou a visibilidade da foto não é ideal")
            return
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
    } catch {
        print("Deu ruim ao processar a pose: \(error)")
        print ("Faz uma pose melhor")
    }
}

func distance(from p1: CGPoint, to p2: CGPoint) -> CGFloat{
    return hypot(p2.x - p1.x, p2.y - p1.y)
}
