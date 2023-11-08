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
    var isCapivaraTakingDamage = false
    var life: Float = 100
    private var damage: Float = 20
    private var breathTime: Float = 100
    private var speed: CGFloat = 5
    private var defense: Float = 100
    private var assetScale: CGFloat = 0.1
    private var staticName: String = "capybara_stopped"
  // var audioPlayer = AudioPlayer()

    var sprite: SKSpriteNode

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
        let scaleX = screenWidth * assetScale / sprite.size.width
        let scaleY = screenHeight * assetScale / sprite.size.height
        sprite.xScale = scaleX
        sprite.yScale = scaleY
        
        setPosition(screenWidth, screenHeight)
        setPhysics()
        sprite.name = "capybara"
    }

    private func setPhysics() {
        let width = 0.45 * sprite.size.width
        let height = 0.25 * sprite.size.height
        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height), center: CGPoint(x: -25, y: -40))
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody?.categoryBitMask = 1
    }

    private func setPosition(_ screenWidth: CGFloat, _ screenHeight: CGFloat) {        
        sprite.position = CGPoint(x: screenWidth/8, y: screenHeight/2)
        sprite.zPosition = 20
    }

    func stop() {
        self.isCapivaraHitting = false
        self.isCapivaraWalking = false
        self.isCapivaraTakingDamage = false
        let textures = [SKTexture(imageNamed: "capybara_stopped")]
        let action = SKAction.animate(with: textures,
                                      timePerFrame: 0.001,
                                      resize: true,
                                      restore: true)
        sprite.removeAllActions()
        sprite.run(SKAction.repeatForever(action))
    }

    func hit() {
        guard !isCapivaraHitting else { return }
        //audioPlayer.playEffect(effect: "capivara-sword-atack", type: "mp3", volume: 0.1)
        let textures = Textures.getTextures(name: "", atlas: "Capybara_Hit")
        let sound =  SKAction.playSoundFileNamed("capivara-sword-atack", waitForCompletion: false)
        let animation = SKAction.animate(with: textures, timePerFrame: 0.07)
        
        isCapivaraWalking = false
        isCapivaraHitting = true

        sprite.removeAllActions()
        sprite.run(SKAction.sequence([sound, animation])) {
            self.stop()
        }
    }

    func walk(positionX: CGFloat) {
        let textures = Textures.getTextures(name: "", atlas: "Capybara_Walking")
        let action = SKAction.animate(with: textures,
                                      timePerFrame: 1/TimeInterval(textures.count),
                                      resize: true,
                                      restore: true)
        
        sprite.xScale = positionX > 0 ? abs(sprite.xScale) : -abs(sprite.xScale)

        if !isCapivaraWalking {
            isCapivaraWalking = true
            sprite.removeAllActions()
            sprite.run(SKAction.repeatForever(action))
        }
    }

    func death() {
    if  life <= 0 {
        print("morreu")
        //Está entrando no print, mas deveria chamar a animaçao dela morrendo
        //não mudar essa textura
        //cortar as movimetações na tela e deixar o joystick inúil

        }
    }

    func tankingDamage(){
        self.isCapivaraTakingDamage = true
        let textures = Textures.getTextures(name: "", atlas: "Taking_Damage")
        let action = SKAction.animate(with: textures,
                                      timePerFrame:  1/TimeInterval(textures.count),
                                      resize: true,
                                      restore: true)
        
        sprite.removeAllActions()
        sprite.run(action) {
            self.isCapivaraTakingDamage = false
            self.stop()
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
