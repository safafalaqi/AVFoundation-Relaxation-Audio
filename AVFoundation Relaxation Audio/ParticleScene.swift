//
//  ParticleScene.swift
//  AVFoundation Relaxation Audio
//
//  Created by Safa Falaqi on 29/12/2021.
//

import UIKit
import SpriteKit

class ParticleScene: SKScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
    }

    
    private func setupParticleEmitter(){
        let particleEmitter = SKEmitterNode(fileNamed: "SnowParticle")
        particleEmitter!.position = CGPoint(x: size.width / 2, y: size.height - 50)
        addChild(particleEmitter!)
    }
}
