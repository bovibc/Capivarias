//
//  Capybara.swift
//  Capivarias
//
//  Created by Clissia Bozzer Bovi on 19/10/23.
//

import Foundation
import SpriteKit

class Capybara {
    var currentState = CapybaraStates.none

    var life: Float = 100
    private var damageSword: Float = 20
    private var damageZarabatana: Float = 500
    private var breathTime: Float = 100
    private var speed: CGFloat = 5
    private var defense: Float = 100
    private var assetScale: CGFloat = 0.1
    private var zarabatanaBulletSpeed = 600.0
    private var staticName: String = "capybara_stopped"
    var audioPlayer = AudioPlayer()
    var sounds = Sounds()
    let assets = Assets()

    var sprite: SKSpriteNode
    let zarabatanaBullet:SKSpriteNode
    let idleSwordTexture:[SKTexture]
    let attackSwordTexture:[SKTexture]
    let runSwordTexture:[SKTexture]
    let takingDamageTexture:[SKTexture]
    let dyingTexture:[SKTexture]
    let idleZarabatanaTexture:[SKTexture]
    let attackZarabatanaTexture:[SKTexture]
    let deadTexture:[SKTexture]
    let walkZarabatanaTexture:[SKTexture]

    var shoot = SKSpriteNode()

    init() {
        self.sprite = SKSpriteNode(imageNamed: assets.idleCapybara)
        zarabatanaBullet = SKSpriteNode(imageNamed: assets.seedBullet)
        
        idleSwordTexture = [SKTexture(imageNamed: staticName)]
        attackSwordTexture = Textures.getTextures(atlas: assets.capybaraAttack)
        runSwordTexture = Textures.getTextures(atlas: assets.capybaraWalk)
        
        idleZarabatanaTexture = [SKTexture(imageNamed: assets.stoppedZarabatana)]
        attackZarabatanaTexture = Textures.getTextures(atlas: assets.capybaraAttackZarabatana)
        walkZarabatanaTexture = Textures.getTextures(atlas: assets.capybaraZarabanataWalking)


        takingDamageTexture = Textures.getTextures(atlas: assets.capybaraDamage)
        dyingTexture = Textures.getTextures(atlas: assets.capybaraDying)
        deadTexture = Textures.getTextures(atlas: assets.deadCapybara )
        
        enterState(nextState: .idleSword)
    }

    func changeLife(damage: Float) {
        life -= damage
    }

    func getLife() -> Float {
        return life
    }

    func getDamage() -> Float {
        return damageSword
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
        sprite.physicsBody?.isDynamic = true
        sprite.physicsBody?.categoryBitMask = 1
    }

    private func setPosition(_ screenWidth: CGFloat, _ screenHeight: CGFloat) {        
        sprite.position = CGPoint(x: screenWidth/8, y: screenHeight/2)
        sprite.zPosition = 20
    }

    func stop() {
        stateManager(nextState: .idleSword)
    }

    func idleZarabatana() {
        stateManager(nextState: .idleZarabatana)
    }

    func swordAttackAnimation() {
        stateManager(nextState: .attackSword)
    }
    
    func isAttacking() -> Bool {
        return currentState == .attackSword || currentState == .attackZarabatana
    }

    func shootZarabatanaAnimation(capybara: SKSpriteNode, alligator: SKSpriteNode) {
        faceEnemy(enemy: alligator)

        let bulletTravelTime = distanceBetweenPoints(capybara.position, alligator.position)/zarabatanaBulletSpeed
        
        zarabatanaBullet.position = CGPoint(x: capybara.position.x + capybara.size.width / 2.0,
                                   y: capybara.position.y)
        zarabatanaBullet.setScale(0.3)
        zarabatanaBullet.zPosition = 3
        zarabatanaBullet.physicsBody = SKPhysicsBody(rectangleOf: zarabatanaBullet.size)
        zarabatanaBullet.physicsBody?.isDynamic = false
        zarabatanaBullet.physicsBody?.categoryBitMask = 6
        zarabatanaBullet.physicsBody?.contactTestBitMask = 2

        capybara.parent?.addChild(zarabatanaBullet)
        let moveAction = SKAction.move(to: CGPoint(x: alligator.position.x,
                                                   y: alligator.position.y), duration: bulletTravelTime)

        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction, deleteAction])
        zarabatanaBullet.run(combine)
        
        stateManager(nextState: .attackZarabatana)
    }
    
    func closestEnemyAsLast(enemy: inout [Alligator]){
        guard !enemy.isEmpty else {
            return
        }
        var closestDistance = Double.infinity
        var closestEnemyIndex = 0
        
        for (index, enemy) in enemy.enumerated(){
            let distance = distanceBetweenPoints(sprite.position, enemy.sprite.position)
            
            if distance < closestDistance{
                closestDistance = distance
                closestEnemyIndex = index
            }
        }
        let closestEnemy = enemy.remove(at: closestEnemyIndex)
        enemy.append(closestEnemy)
    }
    
    func faceEnemy(enemy: SKSpriteNode) {
        let deltaX = enemy.position.x - sprite.position.x
        if deltaX > 0 {
            sprite.xScale = abs(sprite.xScale)
        } else if deltaX < 0{
            sprite.xScale = -abs(sprite.xScale)
        }
    }
    
    func distanceBetweenPoints(_ point1: CGPoint, _ point2: CGPoint) -> Double {
        let deltaX = point2.x - point1.x
        let deltaY = point2.y - point1.y
        let distancia = sqrt(pow(deltaX, 2) + pow(deltaY, 2))
        
        return Double(distancia)
    }
    
    func walk(positionX: CGFloat) {
        stateManager(nextState: .runSword)
        sprite.xScale = positionX > 0 ? abs(sprite.xScale) : -abs(sprite.xScale)
    }

    func walkZarabatana(positionX: CGFloat) {
        stateManager(nextState: .runZarabatana)
        sprite.xScale = positionX > 0 ? abs(sprite.xScale) : -abs(sprite.xScale)
    }

    func death(_ death: @escaping ()-> Void) {
        if life <= 0  {
            stateManager(nextState: .die)
            }
        }

    func dyingAction() {
        stateManager(nextState: .die)
    }

    func takingDamage(){
        stateManager(nextState: .takingDamage)
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
    
    func spriteAnimation(textures: [SKTexture], timePerFrame: Double, repeatForever
                         :Bool = false, completion:  (() -> Void)?){
        var action = SKAction.animate(with: textures,
                                      timePerFrame: timePerFrame,
                                      resize: true,
                                      restore: true)
        if repeatForever {
            action = SKAction.repeatForever(action)
        }
        
        if let completion = completion {
            sprite.run(action, completion: completion)
        } else {
            sprite.run(action)
        }
    }
    
    func stateManager(nextState: CapybaraStates){
        guard currentState != nextState else { return }
        exitState()
        enterState(nextState: nextState)
    }
    
    func enterState(nextState: CapybaraStates){
        print("Indo para estado \(nextState)")
        
        guard currentState != .die else {return}
    
        currentState = nextState
        switch currentState {
        case .none:
            print("None case")
            
        case .idleSword:
            spriteAnimation(textures: idleSwordTexture,
                            timePerFrame: 0.001, 
                            repeatForever: true, completion: nil)
        case .runSword:
            spriteAnimation(textures: runSwordTexture, timePerFrame: 1/TimeInterval(runSwordTexture.count), repeatForever: true, completion: nil)
            
        case .attackSword:
            audioPlayer.playEffect(effect: sounds.swordAttack, type: "mp3", volume: 0.1)
            spriteAnimation(textures: attackSwordTexture, timePerFrame: 1/TimeInterval(attackSwordTexture.count)) {
                self.enterState(nextState: .idleSword)
            }
            
        case .idleZarabatana:
            spriteAnimation(textures: idleZarabatanaTexture, timePerFrame: 0.001,  repeatForever: true,completion: nil)
            
        case .runZarabatana:
            let action = SKAction.animate(with: walkZarabatanaTexture,
                                          timePerFrame: 1/TimeInterval(walkZarabatanaTexture.count),
                                          resize: true,
                                          restore: true)
            sprite.run(SKAction.repeatForever(action))
            
        case .attackZarabatana:
            audioPlayer.playEffect(effect: "blow-gun", type: ".mp3", volume: 0.8)
            spriteAnimation(textures: attackZarabatanaTexture, timePerFrame: 1/TimeInterval(attackZarabatanaTexture.count)) {
                self.enterState(nextState: .idleZarabatana)
            }
            
        case .takingDamage:
            spriteAnimation(textures: takingDamageTexture, timePerFrame: 1/TimeInterval(takingDamageTexture.count)) {
                self.enterState(nextState: .idleSword)
            }
            
        case .die:
            spriteAnimation(textures: dyingTexture, timePerFrame: 0.7/TimeInterval(dyingTexture.count)) {
                self.sprite.removeAllActions()
                let action = SKAction.animate(with: self.deadTexture,
                                              timePerFrame: 0.001,
                                              resize: true,
                                              restore: true)
                self.sprite.run(SKAction.repeatForever(action))
                self.sprite.removeFromParent()
            }
        }
    }
    
    func exitState(){
        //TODO: Pensar se sempre vai remover as ações
        sprite.removeAllActions()
    }
}

