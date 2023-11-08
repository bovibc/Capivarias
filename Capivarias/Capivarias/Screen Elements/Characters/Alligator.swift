//
//  Alligator.swift
//  Capivarias
//
//  Created by Clissia Bozzer Bovi on 19/10/23.
//

import Foundation
import SpriteKit

class Alligator {
    var life: Float = 100
    private var damage: Float = 100
    private var speed: CGFloat = 2
    private var attackSpeed: CGFloat = 1
    private var scale: CGFloat = 0.19
    private let staticName: String = "a1"
    private var isAlligatorWalking: Bool = false
    var isAlligatoraAttacking: Bool = false
    private let movementAliasName: String = "Alligator_Walking"
    var sprite: SKSpriteNode
    var audioPlayer = AudioPlayer()
    var isFollowing: Bool = true
    var lastHit:TimeInterval = 0
    var finishAnimation: TimeInterval = 0

    init() {
        self.sprite = SKSpriteNode(imageNamed: staticName)
    }
    
    func changeLife(damage: Float) {
        life -= damage
    }
    
    func getDamage() -> Float {
        return damage
    }

    func start(screenWidth: CGFloat, screenHeight: CGFloat) {
        let scaleX = screenWidth * scale / sprite.size.width
        let scaleY = screenHeight * scale / sprite.size.height
        sprite.xScale = scaleX
        sprite.yScale = scaleY

        setPosition(screenWidth, screenHeight)
        setPhysics()
        sprite.name = "alligator"
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
        guard !isAlligatorWalking && !isAlligatoraAttacking else { return }
        let textures = Textures.getTextures(name: "", atlas: "Alligator_Walking")
        let action = SKAction.animate(with: textures,
                                      timePerFrame: 1/TimeInterval(textures.count),
                                      resize: true,
                                      restore: true)
        isAlligatorWalking = true
        sprite.removeAllActions()
        sprite.run(SKAction.repeatForever(action))
    }
    
    func stop() {
        isAlligatorWalking = false
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
            
            //Aqui deveria, qunado terminasse toda a animação do jacaré batendo, chamar o sprite do jacaré parado (ele já está parando de seguir)
            sprite = SKSpriteNode(imageNamed: "alligator_stopped")
            
            
        }
    }

    @objc func attack() {
        guard !isAlligatoraAttacking else { return }
        self.isAlligatoraAttacking = true
        //audioPlayer.playEffect(effect: "alligator-axe-atack", type: "mp3", volume: 1.0)
        let soundAction = SKAction.playSoundFileNamed("alligator-axe-atack", waitForCompletion: false)
        let startAction = SKAction.run {
            self.stop()
            self.attackAction()
        }
    
        let finishedAction = SKAction.run {
            self.walk()
            self.isAlligatoraAttacking = false
            
        }

        let action = SKAction.sequence([soundAction, startAction, SKAction.wait(forDuration: 0.78), finishedAction])
        self.sprite.removeAllActions()
        self.sprite.run(action)
    }

    private func attackAction() {
        let textures = Textures.getTextures(name: "", atlas: "Alligator_Attacking")
        let action = SKAction.animate(with: textures,
                                      timePerFrame: 0.8/TimeInterval(textures.count),
                                      resize: true,
                                      restore: true)
        self.sprite.run(SKAction.repeatForever(action))
    }

    func stopAll() {
        stop()
        sprite.removeAllActions()
        let textures = Textures.getTextures(name: "", atlas: "Alligator_Stopped")
        let action = SKAction.animate(with: textures,
                                      timePerFrame: 0.8/TimeInterval(textures.count),
                                      resize: true,
                                      restore: true)
        self.sprite.run(SKAction.repeatForever(action))
    }
}
