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
    private var speed: CGFloat = 0.004
    private var defense: Float = 100
    private var assetScale: CGFloat = 0.1
    private var stoppedImage: String = "capybara_stopped"

    var sprite: SKSpriteNode

    init() {
        self.sprite = SKSpriteNode(imageNamed: stoppedImage)
    }

    func startCapybara(screenWidth: CGFloat, screenHeight: CGFloat) {
        let scaleX = screenWidth * assetScale / sprite.size.width
        let scaleY = screenHeight * assetScale / sprite.size.height
        let texture = SKTexture(imageNamed: "capybara_stopped")
        
        sprite.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        sprite.physicsBody?.affectedByGravity = false
        sprite.position = CGPoint(x: screenWidth/8, y: screenHeight/2)
        sprite.zPosition = 10
        sprite.xScale = scaleX
        sprite.yScale = scaleY
    }
    
    func stop() {
        
        let textures = [SKTexture(imageNamed: "capybara_stopped")]
        let action = SKAction.animate(with: textures,
                                      timePerFrame: 0.001,
                                      resize: true,
                                      restore: true)
        sprite.removeAllActions()
        sprite.run(SKAction.repeatForever(action))
        
    }

    func walk() {
        
    }

    func goLeft() {
        sprite.position.x += speed
    }

    func goRight() {
        sprite.position.x -= speed
    }

    func goTop() {
        sprite.position.y += speed
    }

    func goBottom() {
        sprite.position.y -= speed
    }
}
