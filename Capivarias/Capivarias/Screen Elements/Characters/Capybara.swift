//
//  Capybara.swift
//  Capivarias
//
//  Created by Clissia Bozzer Bovi on 19/10/23.
//

import Foundation
import SpriteKit

class Capybara {

    private var life: Float = 100
    private var breathTime: Float = 100
    private var speed: Float = 3.0
    private var defense: Float = 100
    private var assetScale: CGFloat = 0.09
    private var stoppedImage: String = "capybara_stopped"

    var sprite: SKSpriteNode

    init() {
        self.sprite = SKSpriteNode(imageNamed: stoppedImage)
    }

    func startCapybara(screenWidth: CGFloat, screenHeight: CGFloat) {
        let scale = screenWidth * assetScale / sprite.size.width
        let texture = SKTexture(imageNamed: "capybara_stopped")
        sprite.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        sprite.physicsBody?.affectedByGravity = false
        sprite.position = CGPoint(x: 200, y: screenHeight/2)
        sprite.zPosition = 10
        sprite.setScale(scale)
    }
}
