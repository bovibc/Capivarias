//
//  GameScene.swift
//  Joystick
//
//  Created by Clissia Bozzer Bovi on 02/10/23.
//

import SpriteKit
import GameplayKit
import GameController

class GameScene: SKScene, SKPhysicsContactDelegate {
    var sounds = Sounds()
    var virtualController: GCVirtualController?
    var joystick = Joystick()
    var enemies: [Alligator] = [Alligator()]
    var capybara = Capybara()
    let backgroundController = BackgroundController()
    var door = SKSpriteNode()
    var isContact: Bool = false
    var transactionScene = TrasactionsScenes()
    var gameOver: TimeInterval = 0
    var lastEnemyIndex: Int = 0
    let assets = Assets()
    var weapon: Bool = true
    
    override func didMove(to view: SKView) {
        setupScene()
        setupBackground()
        setupCapivara()
        getDoor()
        setupAlligator()
        connectController()
        setObstacles()
        setupContact()
        AudioPlayer.shared.EnviromentSong()
        
    }
    
    private func setupBackground() {
        backgroundController.setupBackground(scene: self, imageName: assets.map3)
    }
    
    private func getDoor() {
        self.door = childNode(withName: "Door") as! SKSpriteNode
    }
    
    private func setObstacles() {
        setNode(nodeName: "tree", textureName: "tronco")
        setNode(nodeName: "rock", textureName: "rock")
        setNode(nodeName: "lake", textureName: "lake")
    }
    
    private func setNode(nodeName: String, textureName: String) {
        let node = childNode(withName: nodeName) as! SKSpriteNode
        let texture = SKTexture(imageNamed: textureName)
        
        node.physicsBody = SKPhysicsBody(texture: texture, size: node.size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.affectedByGravity = false
    }
    
    private func setupContact() {
        self.physicsWorld.contactDelegate = self
    }
    
    private func setupAlligator() {
        generateEnemies()
        for i in 0..<enemies.count {
            self.enemies[i].start(
                screenWidth: size.width,
                screenHeight: size.height,
                spawnPosition: Position.randomize(size),
                mask: i+2)
            addChild(enemies[i].sprite)
        }
    }
    
    private func generateEnemies() {
        let plusEnemieNumber = Int.random(in: 0..<4)
        for _ in 0..<plusEnemieNumber {
            enemies.append(Alligator())
        }
    }
    
    private func setupScene() {
        scene?.anchorPoint = .zero
        scene?.size = CGSize(width: view?.scene?.size.width ?? 600, height: view?.scene?.size.height ?? 800)
    }
    
    private func setupCapivara() {
        self.capybara.start(screenWidth: size.width , screenHeight: size.height)
        addChild(capybara.sprite)
    }
    
    private func removeDoor() {
        door.removeFromParent()
    }
    
    override func update(_ currentTime: TimeInterval) {
        for i in 0..<enemies.count {
            enemies[i].follow(player: capybara.sprite.position)
        }
        
        if joystick.isJoystickStatic() {
            if !capybara.isCapivaraHitting && !capybara.isCapivaraTakingDamage {
                if weapon == true {
                    capybara.stop()
                }
                else {
                    capybara.stopZarabatana()
                }
            }
            
        } else {
            let direction = joystick.getDirection()
            validateMovement(direction)
            if !capybara.isCapivaraHitting && !capybara.isCapivaraTakingDamage {
                //Aqui, colocar uma condiçao de que dependendo do valor do booleano "weapon"selecionado, vai chamar ou ela walk com espada ou ela walk com zarabatana
                if weapon == true {
                    capybara.walk(positionX: joystick.positionX )
                } else {
                    capybara.walkZarabatana(positionX: joystick.positionX )
                }
            }
        }
        
        capybara.death()
        if capybara.getLife() <= 0 {
            enemies[lastEnemyIndex].isFollowing = false
            if (currentTime - enemies[lastEnemyIndex].finishAnimation) > 1 {
                enemies[lastEnemyIndex].sprite.removeAllActions()
            }
            
            if (currentTime - gameOver) > 4 {
                
                if let view = self.view {
                    virtualController?.disconnect()
                    transactionScene.gameOver(view: view, gameScene: GameOverGameScene())
                }
            }
        }
        
        if isContact {
            if (currentTime - enemies[lastEnemyIndex].lastHit) > 3 {
                enemies[lastEnemyIndex].lastHit = currentTime
                enemies[lastEnemyIndex].attack()
                capybara.takingDamage()
                self.capybara.changeLife(damage: self.enemies[lastEnemyIndex].getDamage())
            }
        }
        
        if let view = self.view {
            if capybara.sprite.position.x >= 1400 {
                virtualController?.disconnect()
                transactionScene.goToNextLevel(view: view, gameScene: "SecondScene")
            }
        }
    }
        
        private func validateMovement(_ direction: Direction) {
            switch direction.horizontal {
            case .left:
                capybara.goLeft()
            case .right:
                capybara.goRight()
            case .none:
                break
            }
            
            switch direction.vertical {
            case .top:
                capybara.goTop()
            case .bottom:
                capybara.goBottom()
            case .none:
                break
            }
        }
        
        func setupController(){
            self.virtualController?.controller?.extendedGamepad?.buttonX.pressedChangedHandler = { button, value, pressed in
                if self.weapon == true{
                    if pressed && self.isContact {
                        self.capybara.hit()
                        self.enemies[self.lastEnemyIndex].changeLife(damage: self.capybara.getDamage())
                        if self.enemies[self.lastEnemyIndex].getLife() <= 0 {
                            self.enemyDied()
                        }
                    }
                    else {
                        self.capybara.hit()
                    }
                }
                else {
                    print("Atirando com a zarabanana")
                    self.capybara.shootZarabatana(capybara: self.capybara.sprite,
                                                  alligator: self.enemies[self.lastEnemyIndex].sprite)
                }
            }
            self.virtualController?.controller?.extendedGamepad?.buttonY.pressedChangedHandler = { button, value, pressed in
                if pressed {
                    self.weapon.toggle()
                    print("hello")
                }
                else {
                }
            }
        }
        
        func connectController() {
            joystick.connectController { controller in
                self.virtualController = controller
                self.setupController()
            }
        }
        
        func didEnd(_ contact: SKPhysicsContact) {
            isContact = false
        }
        
        func didBegin(_ contact: SKPhysicsContact) {
            let bodyA = contact.bodyA.categoryBitMask
            let bodyB = contact.bodyB.categoryBitMask
            let alligatorMaskA = (bodyA == 2 || bodyA == 3 || bodyA == 4)
            let alligatorMaskB = (bodyB == 2 || bodyB == 3 || bodyB == 4)
            if bodyA == 1 && alligatorMaskB {
                contactAttack(bodyA, bodyB)
            }
            if alligatorMaskA && bodyB == 1 {
                contactAttack(bodyA, bodyB)
            }
            
            if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 3 {
                print("bateu")
                enemies[self.lastEnemyIndex].changeLife(damage: capybara.getDamageZarabatana())
            }
        }
        
        private func contactAttack(_ bodyA: UInt32, _ bodyB: UInt32) {
            lastEnemyIndex = getEnemy(bodyA, bodyB)
            isContact = true
            
            if enemies[lastEnemyIndex].isAlligatoraAttacking == false {
                capybara.changeLife(damage: enemies[lastEnemyIndex].getDamage())
            }
        }
        
        private func getEnemy(_ bodyA: UInt32, _ bodyB: UInt32) -> Int {
            var index = 0
            let body = (bodyA == 1) ? bodyB : bodyA
            for i in enemies {
                if body == i.sprite.physicsBody?.categoryBitMask {
                    index = enemies.firstIndex{$0 === i} ?? 0
                    break
                }
            }
            return index
        }
        
        private func enemyDied() {
            self.enemies[self.lastEnemyIndex].die()
            self.enemies.remove(at: self.lastEnemyIndex)
            self.isContact = false
            isEnemiesEmpty()
        }
        
        private func isEnemiesEmpty() {
            if enemies.isEmpty {
                removeDoor()
            }
        }
}
