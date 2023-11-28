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

        scene.scaleMode = .fill
        background.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        background.zPosition = -1
        background.xScale = scene.frame.size.width / background.size.width
        background.yScale = scene.frame.size.height / background.size.height
        
        scene.addChild(background)
    }
}
