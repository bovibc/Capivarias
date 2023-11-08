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
    var alligator = Alligator()
    var audioPlayer = AudioPlayer()
    var capybara = Capybara()
    let backgroundController = BackgroundController()
    //var door = SKSpriteNode()
    var i = 0
    var isContact: Bool = false
    var timeToAlligatorHit = 0
    var transactionScene = TrasactionsScenes()
    var gameOver: TimeInterval = 0

    override func didMove(to view: SKView) {
        setupScene()
        setupBackground()
        setupCapivara()
        //removeDoor()
        //getDoor()
        setupAlligator()
        connectController()
        setupAudio()
        setObstacles()
        setupContact()
    }
    
    private func setupBackground() {
        backgroundController.setupBackground(scene: self, imageName: "mapateste")
    }

//    private func getDoor() {
//        self.door = childNode(withName: "Door") as! SKSpriteNode
//    }

    private func setObstacles() {
        setLake()
        setTree()
        setRock()
    }

    private func setTree() {
        let tree = childNode(withName: "tree") as! SKSpriteNode
        let treeTexture = SKTexture(imageNamed: "tronco")
        
        tree.physicsBody = SKPhysicsBody(texture: treeTexture, size: tree.size)
        tree.physicsBody?.isDynamic = false
        tree.physicsBody?.allowsRotation = false
        tree.physicsBody?.affectedByGravity = false
    }

    private func setRock() {
        let rock = childNode(withName: "rock") as! SKSpriteNode
        let rockTexture = SKTexture(imageNamed: "rock")

        rock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rock.size)
        rock.physicsBody?.isDynamic = false
        rock.physicsBody?.allowsRotation = false
        rock.physicsBody?.affectedByGravity = false
    }

    private func setLake() {
        let lake = childNode(withName: "lake") as! SKSpriteNode
        let lakeTexture = SKTexture(imageNamed: "lake")
        
        lake.physicsBody = SKPhysicsBody(texture: lakeTexture, size: lake.size)
        lake.physicsBody?.isDynamic = false
        lake.physicsBody?.allowsRotation = false
        lake.physicsBody?.affectedByGravity = false
    }

    private func setupAudio() {
        audioPlayer.playEnviroment(sound: "ambient-forest", type: "mp3", volume: 1.0)
    }

    private func setupContact() {
        self.physicsWorld.contactDelegate = self
    }
    
    private func setupAlligator() {
        self.alligator.start(screenWidth: size.width , screenHeight: size.height)
        addChild(alligator.sprite)
    }
    
    private func setupScene() {
        scene?.anchorPoint = .zero
        scene?.size = CGSize(width: view?.scene?.size.width ?? 600, height: view?.scene?.size.height ?? 800)
    }

    private func setupCapivara() {
        self.capybara.start(screenWidth: size.width , screenHeight: size.height)
        addChild(capybara.sprite)
    }

//    private func removeDoor() {
//        door.removeFromParent()
//    }

    override func update(_ currentTime: TimeInterval) {
        alligator.follow(player: capybara.sprite.position)
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
        if capybara.life <= 0 {
            alligator.isFollowing = false
            if (currentTime - alligator.finishAnimation) > 1 {
                alligator.sprite.removeAllActions()
            }
            
            if (currentTime - gameOver) > 4 {
                
                if let view = self.view {
                    //Aqui, chamar algo que tire o Joystick na tela
                    
                    virtualController?.disconnect()
                    transactionScene.gameOver(view: view, gameScene: GameOverGameScene())
                    
                    
                }
            }
            
        }

        if isContact {
            if (currentTime - alligator.lastHit) > 3 {
                alligator.lastHit = currentTime
                alligator.attack()
                capybara.tankingDamage()
                self.capybara.changeLife(damage: self.alligator.getDamage())
               // print(capybara.life)
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
                self.alligator.changeLife(damage: self.capybara.getDamage())

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
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2 {
            contactAttack()
        }
        if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1 {
            contactAttack()
        }
    }

    private func contactAttack() {
        i+=1
        isContact = true
        alligator.attack()

        if alligator.isAlligatoraAttacking == false {
            capybara.changeLife(damage: alligator.getDamage())
            //Aqui, chamar animaçao da capivara tomando dano
           // print(capybara.life)
        }
        else {
            setGamePadAction()
        }
    }

    private func setGamePadAction() {
        self.virtualController?.controller?.extendedGamepad?.buttonX.pressedChangedHandler = { button, value, pressed in
            if pressed {
                self.capybara.hit()
                self.alligator.changeLife(damage: self.capybara.getDamage())
                //Aqui, chamar alimaçao do jacare tomando dano
            }
        }
    }
}
