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
    private var damage: Float = 20   //Aqui, é o dano da espada
    private var damageZarabatana: Float = 5
    private var breathTime: Float = 100
    private var speed: CGFloat = 5
    private var defense: Float = 100
    private var assetScale: CGFloat = 0.1
    private var staticName: String = "capybara_stopped"
    var audioPlayer = AudioPlayer()
    var sounds = Sounds()
    let assets = Assets()
    let attackTexture:[SKTexture]
    let walkTexture:[SKTexture]
    let damageTexture:[SKTexture]
    var sprite: SKSpriteNode
    var shoot = SKSpriteNode()

    init() {
        self.sprite = SKSpriteNode(imageNamed: staticName)
        attackTexture = Textures.getTextures(atlas: assets.capybaraAttack)
        walkTexture = Textures.getTextures(atlas: assets.capybaraWalk)
        damageTexture = Textures.getTextures(atlas: assets.capybaraDamage)
    }

    func changeLife(damage: Float) {
        life -= damage
    }

    func getLife() -> Float {
        return life
    }

    func getDamage() -> Float {
        return damage
    }
    
    func getDamageZarabatana() -> Float {
        return damageZarabatana
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
    
    func stopZarabatana() {
        self.isCapivaraHitting = false
        self.isCapivaraWalking = false
        self.isCapivaraTakingDamage = false
        let textures = [SKTexture(imageNamed: assets.stoppedZarabatana)]
        let action = SKAction.animate(with: textures,
                                      timePerFrame: 0.001,
                                      resize: true,
                                      restore: true)
        sprite.removeAllActions()
        sprite.run(SKAction.repeatForever(action))
    }

    func hit() {
        guard !isCapivaraHitting else { return }
        audioPlayer.playEffect(effect: sounds.swordAttack, type: "mp3", volume: 0.1)
        
        let animation = SKAction.animate(with: attackTexture, timePerFrame: 0.07)
        
        isCapivaraWalking = false
        isCapivaraHitting = true

        sprite.removeAllActions()
        sprite.run(SKAction.sequence([animation])) {
            self.stop()
        }
    }
    
    
    func shootZarabatana(capybara: SKSpriteNode, alligator: SKSpriteNode) {
        //Colocar algo para essa funçao retornar
        
        guard !isCapivaraHitting else { return }
        
        print("Entrei")

        let banana2 = SKSpriteNode(imageNamed: "banana2")
        banana2.position = CGPoint(x: capybara.position.x + capybara.size.width / 2.0,
                                   y: capybara.position.y)
        banana2.setScale(0.3)
        banana2.zPosition = 3
        
        // Configurar a física para a "banana2"
            banana2.physicsBody = SKPhysicsBody(rectangleOf: banana2.size)
            banana2.physicsBody?.isDynamic = false
            banana2.physicsBody?.categoryBitMask = 3 // Defina a categoria da física conforme necessário
        
//            banana2.physicsBody?.contactTestBitMask = 2 // Defina a categoria de teste da física conforme necessário
//            banana2.physicsBody?.collisionBitMask = 0 // Se necessário, defina a categoria de colisão da física
        

        capybara.parent?.addChild(banana2)
        
        
        let moveAction = SKAction.move(to: CGPoint(x: alligator.position.x,
                                                   y: alligator.position.y), duration: 0.8)
            print("Posicao \(alligator.position)")

            let deleteAction = SKAction.removeFromParent()
            let combine = SKAction.sequence([moveAction, deleteAction])
            banana2.run(combine)
        
        let textures = Textures.getTextures(atlas: "Capybara_ShootingZarabatana")
        let sound =  SKAction.playSoundFileNamed("capivara-sword-atack", waitForCompletion: false)
        let animation = SKAction.animate(with: textures, timePerFrame: 0.07,
                                         resize: true,
                                         restore: true)
        
        isCapivaraWalking = false
        isCapivaraHitting = true

        sprite.removeAllActions()
        sprite.run(SKAction.sequence([sound, animation])) {
            self.stop()
        }
        
        
        
    }
    

    

    func walk(positionX: CGFloat) {
        let action = SKAction.animate(with: walkTexture,
                                      timePerFrame: 1/TimeInterval(walkTexture.count),
                                      resize: true,
                                      restore: true)
        
        sprite.xScale = positionX > 0 ? abs(sprite.xScale) : -abs(sprite.xScale)

        if !isCapivaraWalking {
            isCapivaraWalking = true
            sprite.removeAllActions()
            sprite.run(SKAction.repeatForever(action))
        }
    }
    
    
    
    func walkZarabatana(positionX: CGFloat) {
        let textures = Textures.getTextures(atlas: "Alligator_Walking")
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

    func takingDamage(){
        self.isCapivaraTakingDamage = true
        let action = SKAction.animate(with: damageTexture,
                                      timePerFrame:  1/TimeInterval(damageTexture.count),
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
