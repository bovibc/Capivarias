//
//  Capybara.swift
//  Capivarias
//
//  Created by Clissia Bozzer Bovi on 19/10/23.
//

import Foundation
import SpriteKit

class Capybara {
    var isCapivaraHitting = false
    var isCapivaraWalking = false
    private var life: Float = 100
    private var breathTime: Float = 100
    private var speed: CGFloat = 5
    private var defense: Float = 100
    private var assetScale: CGFloat = 0.1
    private var staticName: String = "capybara_stopped"

    var sprite: SKSpriteNode

    init() {
        self.sprite = SKSpriteNode(imageNamed: staticName)
    }

    func start(screenWidth: CGFloat, screenHeight: CGFloat) {
        let scaleX = screenWidth * assetScale / sprite.size.width
        let scaleY = screenHeight * assetScale / sprite.size.height
        sprite.xScale = scaleX
        sprite.yScale = scaleY
        
        setPosition(screenWidth, screenHeight)
        setPhysics()
        sprite.name = "capybara"
    }

    private func setPhysics() {
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.categoryBitMask = 1
    }

    private func setPosition(_ screenWidth: CGFloat, _ screenHeight: CGFloat) {        
        sprite.position = CGPoint(x: screenWidth/8, y: screenHeight/2)
        sprite.zPosition = 20
    }
    
    func stop() {
        self.isCapivaraHitting = false
        self.isCapivaraWalking = false
        sprite.zRotation = 0
        let textures = [SKTexture(imageNamed: "capybara_stopped")]
        let action = SKAction.animate(with: textures,
                                      timePerFrame: 0.001,
                                      resize: false,
                                      restore: true)
        sprite.removeAllActions()
        sprite.run(SKAction.repeatForever(action))

    }
    
    func hit() {
        let textures = Textures.getTextures(name: "", atlas: "Capybara_Hit")
        let action = SKAction.animate(with: textures,
                                      timePerFrame: 1/TimeInterval(textures.count),
                                      resize: true,
                                      restore: true)
   
        sprite.removeAllActions()
      //  sprite.run(SKAction.repeatForever(action))
        isCapivaraWalking = false
        isCapivaraHitting = true
       // sprite.run(SKAction.animate(with: textures, timePerFrame: 0.1))
        
        sprite.run(SKAction.animate(with: textures, timePerFrame: 0.1)) {
            self.isCapivaraHitting = false
            self.stop()
        }
        
    }
    
    
    
    
    func walk(positionX: CGFloat) {
        
        
        print(sprite.zRotation)
        sprite.zRotation = 0
        let textures = Textures.getTextures(name: "", atlas: "Capybara_Walking")
        let action = SKAction.animate(with: textures,
                                      timePerFrame: 1/TimeInterval(textures.count),
                                      resize: false,
                                      restore: true)
        
        sprite.xScale = positionX > 0 ? abs(sprite.xScale) : -abs(sprite.xScale)
        
        if !isCapivaraWalking {
            isCapivaraWalking = true
            sprite.removeAllActions()
            sprite.run(SKAction.repeatForever(action))
        }
        
        
        
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
