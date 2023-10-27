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
    var door = SKSpriteNode()
    var i = 0

    override func didMove(to view: SKView) {
        setupScene()
        setupBackground()
        setupCapivara()
        removeDoor()
        getDoor()
        removeDoor()
        setupAlligator()
        connectController()
        setupAudio()
        setupContact()
    }

    private func setupBackground() {
        backgroundController.setupBackground(scene: self, imageName: "mapateste")
    }

    private func getDoor() {
        self.door = childNode(withName: "Door") as! SKSpriteNode
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

    private func removeDoor() {
        door.removeFromParent()
    }

    override func update(_ currentTime: TimeInterval) {
        alligator.follow(player: capybara.sprite.position)
        if joystick.isJoystickStatic() {
            
            if !capybara.isCapivaraHitting {
                capybara.stop()
            }
        } else {
            let direction = joystick.getDirection()
            validateMovement(direction)
            capybara.walk(positionX: joystick.positionX )
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
            if pressed {
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

    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2 {
            print(i)
            i+=1
            alligator.attack()
        }

        if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1 {
            print(i)
            i+=1
            alligator.attack()
        }
    }
}
