//
//  Monkey.swift
//  Capivarias
//
//  Created by Renan Tavares on 10/11/23.
//

import Foundation
import SpriteKit


class Monkey {
    var life: Float = 100
    private var damage: Float = 20
    private var speed: CGFloat = 2
    private var attackSpeed: CGFloat = 1
    private let staticName: String = "m1"
    private var isMonkeyWalking: Bool = false
    private let movementMonkeyName: String = "Monkey_Waking"
    private let speedAtack: Float = 3.0
    var isFollowing: Bool = true
    private var scale: CGFloat = 0.19
    var sprite: SKSpriteNode
    var rangeX: Double = 500
    var rangeY: Double = 500
    
    init() {
        self.sprite = SKSpriteNode(imageNamed: staticName)
    }
    
    func start(screenWidth: CGFloat, screenHeight: CGFloat) {
        let scaleX = screenWidth * scale / sprite.size.width
        let scaleY = screenHeight * scale / sprite.size.height
        sprite.xScale = scaleX
        sprite.yScale = scaleY

        setPosition(screenWidth, screenHeight)
        setPhysics()
        sprite.name = "monkey"
    }
    
    
    func follow(player: CGPoint) {
        if isFollowing == true {
            walk()
            let dx = player.x - self.sprite.position.x
            let dy = player.y - self.sprite.position.y
            let angle = atan2(dy, dx)
            
            let vx = cos(angle) * speed
            let vy = sin(angle) * speed
            
            sprite.position.x += vx
            sprite.position.y += vy
            
            
            sprite.xScale = dx > 0 ? abs(sprite.xScale) : -abs(sprite.xScale)
            sprite.zRotation = 0
        }
        else {
        }
    }
    
    private func setPhysics() {
        let width = 0.55 * sprite.size.width
        let height = 0.25 * sprite.size.height
        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height), center: CGPoint(x: -25, y: -40))
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody?.categoryBitMask = 2
        sprite.physicsBody?.contactTestBitMask = 1
    }
    
    private func setPosition(_ screenWidth: CGFloat, _ screenHeight: CGFloat) {
        sprite.position = CGPoint(x: 4 * screenWidth / 5, y: screenHeight/2)
        sprite.zPosition = 20
    }
    
    
    func walk() {
        guard !isMonkeyWalking else { return }
        let textures = Textures.getTextures(name: "", atlas: "Monkey_Waking")
        let action = SKAction.animate(with: textures,
                                      timePerFrame: 1/TimeInterval(textures.count),
                                      resize: true,
                                      restore: true)
        isMonkeyWalking = true
        sprite.removeAllActions()
        sprite.run(SKAction.repeatForever(action))
    }
    

    func isInRange(x: Double, y: Double, monkeyPosition: CGPoint ) -> Bool {
        let distanceX = monkeyPosition.x - x
        let distanceY = monkeyPosition.y - y
        let term1 = pow(distanceX,2) / pow(rangeX, 2)
        let term2 = pow(distanceY,2) / pow(rangeY, 2)
        let result = term1 + term2
        return result <= 1
    }
    
    func attack(capyX: CGFloat, capyY: CGFloat ) {
        if isInRange(x: capyX, y: capyY, monkeyPosition: sprite.position) {
            print("atacou")
        }
    }
}
