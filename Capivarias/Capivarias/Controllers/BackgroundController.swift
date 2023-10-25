//
//  BackgroundController.swift
//  Capivarias
//
//  Created by Guilherme Ferreira Lenzolari on 24/10/23.
//

import Foundation
import SpriteKit

class BackgroundController{
    
    func setupBackground(scene: SKScene, imageName: String) {
        let background = SKSpriteNode(imageNamed: imageName)
        background.position = CGPoint(x: 1/2, y: 1/2)
        background.zPosition = -1
        background.setScale(1/background.size.width)
        scene.addChild(background)
    }
    
}
