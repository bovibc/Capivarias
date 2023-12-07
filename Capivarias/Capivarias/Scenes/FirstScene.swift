//
//  GameScene.swift
//  Joystick
//
//  Created by Clissia Bozzer Bovi on 02/10/23.
//

import SpriteKit
import GameplayKit
import GameController

class FirstScene: SKScene, SKPhysicsContactDelegate {
    var lifeBar = LifeBar()
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
    var maxLife: CGFloat = 100
    var weaponSelection = WeaponSelection()

    override func didMove(to view: SKView) {
        setupScene()
        setupCapivara()
        connectController()
        setObstacles()
        setupContact()
        AudioPlayer.shared.EnviromentSong()
        setupLifeBar()
        setupWeaponSelection()
        backgroundController.setupBackground(scene: self, imageName: assets.firstMapGround)
    }

    private func setupLifeBar() {
        addChild(lifeBar)
        lifeBar.position = .init(x: 300, y: 960)
        lifeBar.zPosition = 99
        lifeBar.xScale = 0.7
        lifeBar.yScale = 0.7
    }

    private func setupWeaponSelection() {
        addChild(weaponSelection)
        weaponSelection.position = .init(x: 77, y: 902)
        weaponSelection.zPosition = 99
        weaponSelection.xScale = 0.4
        weaponSelection.yScale = 0.4
    }

    private func setObstacles() {
        setNode(nodeName: "LakeObjects", textureName: "LakeObjects")
        setNode(nodeName: "FirstMapMapBorder", textureName: "FirstMapMapBorder")

    }

    private func setNode(nodeName: String, textureName: String) {
        let node = childNode(withName: nodeName) as? SKSpriteNode
        let texture = SKTexture(imageNamed: textureName)
        
        guard let node else {return}
        
        node.physicsBody = SKPhysicsBody(texture: texture, size: node.size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.affectedByGravity = false
    }

    private func setupContact() {
        self.physicsWorld.contactDelegate = self
    }

    private func setupScene() {
        scene?.anchorPoint = .zero
        scene?.size = CGSize(width: view?.scene?.size.width ?? 600, height: view?.scene?.size.height ?? 800)
    }

    private func setupCapivara() {
        self.capybara.start(screenWidth: size.width , screenHeight: size.height)
        addChild(capybara.sprite)
    }

    override func update(_ currentTime: TimeInterval) {

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
                if weapon == true {
                    capybara.walk(positionX: joystick.positionX )
                } else {
                    capybara.walkZarabatana(positionX: joystick.positionX )
                }
            }
        }

        if let view = self.view {
            if capybara.sprite.position.x >= 1400 {
                virtualController?.disconnect()
                transactionScene.goToNextLevel(view: view, gameScene: "GameScene")
            }
        }

        lifeBar.updateProgress(capybara.life / Float(maxLife))
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
            if self.weapon == true {
                if pressed && self.isContact {
                    self.capybara.swordAttackAnimation()
                }
                else {
                    self.capybara.swordAttackAnimation()
                }
            } else if !self.enemies.isEmpty {
                //MARK: animaçao da zarabatana
                self.capybara.shootZarabatanaAnimation(capybara: self.capybara.sprite,
                                              alligator: self.enemies[self.enemies.count-1].sprite)
                print(self.enemies[self.enemies.count-1].getLife())
            }
        }
        changeWeapon()
    }

    func connectController() {
        joystick.connectController { controller in
            self.virtualController = controller
            self.setupController()
        }
    }

    private func changeWeapon() {
        self.virtualController?.controller?.extendedGamepad?.buttonY.pressedChangedHandler = { button, value, pressed in
            if pressed {
                self.weapon.toggle()
                self.weaponSelection.changeWeapon(weapon: self.weapon)
            }
            else {
            }
        }
    }
}

