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
    var virtualController: GCVirtualController?
    let spriteScale = 0.07
    var joystick = Joystick()
    var enemies: [Alligator] = [Alligator()]
    var audioPlayer = AudioPlayer()
    var capybara = Capybara()
    let backgroundController = BackgroundController()
    var door = SKSpriteNode()
    var isContact: Bool = false
    var timeToAlligatorHit = 0
    var transactionScene = TrasactionsScenes()
    var gameOver: TimeInterval = 0
    var lastEnemyIndex: Int = 0

    override func didMove(to view: SKView) {
        setupScene()
        setupBackground()
        setupCapivara()
        removeDoor()
        getDoor()
        setupAlligator()
        connectController()
        setupAudio()
        setObstacles()
        setupContact()
    }
    
    private func setupBackground() {
        backgroundController.setupBackground(scene: self, imageName: "mapateste")
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

    private func setupAudio() {
        audioPlayer.playEnviroment(sound: "ambient-forest", type: "mp3", volume: 1.0)
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
                spawnPosition: randomPosition(),
                mask: i+2)
            addChild(enemies[i].sprite)
        }
    }

    private func randomPosition() -> CGPoint {
        let random = Int.random(in: 0..<8)
        switch random {
        case 0:
            return CGPoint(x: size.width/2, y: size.height/3)
        case 1:
            return CGPoint(x: size.width/2, y: size.height/4)
        case 2:
            return CGPoint(x: size.width/1.5, y: size.height/4)
        case 3:
            return CGPoint(x: size.width/2, y: size.height/2)
        case 4:
            return CGPoint(x: size.width/5, y: size.height/5)
        case 5:
            return CGPoint(x: size.width/5, y: size.height/1.5)
        case 6:
            return CGPoint(x: size.width/4, y: size.height/3)
        case 7:
            return CGPoint(x: size.width/1.5, y: size.height/1.5)
        default:
            return CGPoint(x: size.width/5, y: size.height/5)
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
                capybara.stop()
            }

        } else {
            let direction = joystick.getDirection()
            validateMovement(direction)
            if !capybara.isCapivaraHitting && !capybara.isCapivaraTakingDamage {
                capybara.walk(positionX: joystick.positionX )
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
                transactionScene.goToNextLevel(view: view, gameScene: SecondScene())
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
            if pressed && self.isContact {
                self.capybara.hit()
                self.enemies[self.lastEnemyIndex].changeLife(damage: self.capybara.getDamage())

            }
            else {
                self.capybara.hit()
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
    }

    private func contactAttack(_ bodyA: UInt32, _ bodyB: UInt32) {
        lastEnemyIndex = getEnemy(bodyA, bodyB)
        isContact = true
        enemies[lastEnemyIndex].attack()

        if enemies[lastEnemyIndex].isAlligatoraAttacking == false {
            capybara.changeLife(damage: enemies[lastEnemyIndex].getDamage())
        }
        else {
            setGamePadAction()
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

    private func setGamePadAction() {
        self.virtualController?.controller?.extendedGamepad?.buttonX.pressedChangedHandler = { button, value, pressed in
            if pressed {
                self.capybara.hit()
                self.enemies[self.lastEnemyIndex].changeLife(damage: self.capybara.getDamage())
            }
        }
    }
}
