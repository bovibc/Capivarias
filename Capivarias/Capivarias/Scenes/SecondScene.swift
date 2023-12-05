//
//  SecondScene.swift
//  Capivarias
//
//  Created by Renan Tavares on 27/10/23.
//

import SpriteKit
import GameplayKit
import GameController

class SecondScene: SKScene, SKPhysicsContactDelegate {

    var virtualController: GCVirtualController?
    var joystick = Joystick()
    var monkey = Monkey()
    var audioPlayer = AudioPlayer()
    var capybara = Capybara()
    let backgroundController = BackgroundController()
    var door = SKSpriteNode()
    let assets = Assets()
    var isContact: Bool = false
    var transactionScene = TrasactionsScenes()
    var gameOver: TimeInterval = 0

    override func didMove(to view: SKView) {
        connectController()
        setupScene()
        setupBackground()
        setupCapivara()
        getDoor()
        removeDoor()
        setupMonkey()
        setupAudio()
        setObstacles()
        setupContact()
    }
    
    private func setupBackground() {
        backgroundController.setupBackground(scene: self, imageName: assets.map3)
    }

    private func getDoor() {
        self.door = childNode(withName: "Door") as! SKSpriteNode
    }

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
    
    private func setupMonkey() {
        self.monkey.start(screenWidth: size.width , screenHeight: size.height)
        addChild(monkey.sprite)
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
        monkey.follow(player: capybara.sprite.position)
        monkey.attack(capyX: capybara.sprite.position.x, capyY: capybara.sprite.position.y)
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

        capybara.death() {
            if (currentTime - self.gameOver) > 4 {
                
                if let view = self.view {
                    self.virtualController?.disconnect()
                    self.transactionScene.gameOver(view: view, gameScene: GameOverGameScene())
                }
            }
        }

        if isContact {

        }

        if let view = self.view {
            if capybara.sprite.position.x >= 1400 {
               // transactionScene.goToSecondView(view: view)
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
                self.capybara.swordAttackAnimation()
               // self.alligator.changeLife(damage: self.capybara.getDamage())

            }
            else {
                self.capybara.swordAttackAnimation()
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
        isContact = true
        //monkey.attack()

//        if alligator.isAlligatoraAttacking == false {
//            capybara.changeLife(damage: alligator.getDamage())
//            //Aqui, chamar animaçao da capivara tomando dano
//        }
//        else {
//            setGamePadAction()
//        }
    }

    private func setGamePadAction() {
        self.virtualController?.controller?.extendedGamepad?.buttonX.pressedChangedHandler = { button, value, pressed in
            if pressed {
                self.capybara.swordAttackAnimation()
               // self.alligator.changeLife(damage: self.capybara.getDamage())
                //Aqui, chamar alimaçao do jacare tomando dano
            }
        }
    }
}
