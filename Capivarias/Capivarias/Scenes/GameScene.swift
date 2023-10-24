//
//  GameScene.swift
//  Joystick
//
//  Created by Clissia Bozzer Bovi on 02/10/23.
//

import SpriteKit
import GameplayKit
import GameController

class GameScene: SKScene {
    var isCapivaraWalking = false
    var virtualController: GCVirtualController?
    var background = SKSpriteNode(imageNamed: "dry")
    let spriteScale = 0.07
    var joystick = Joystick()
    var capybara: Capybara = Capybara()
    var audioPlayer = AudioPlayer()
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupScene()
        setupCapivara()
        connectController()
        audioPlayer.playEnviroment(sound: "ambient-forest", type: "mp3")
    }

    private func setupBackground() {
        self.scaleMode = .fill
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.xScale = frame.size.width / background.size.width
        background.yScale = frame.size.height / background.size.height
        
        
        
        addChild(background)
    }

    private func setupScene() {
        scene?.anchorPoint = .zero
        scene?.size = CGSize(width: view?.scene?.size.width ?? 600, height: view?.scene?.size.height ?? 800)
    }

    private func setupCapivara() {
        self.capybara.startCapybara(screenWidth: size.width , screenHeight: size.height)
        addChild(capybara.sprite)
    }

    override func update(_ currentTime: TimeInterval) {

        if joystick.isJoystickStatic() {
            capybara.stop()
            isCapivaraWalking = false
        } else {
            let direction = joystick.getDirection()
            validateMovement(direction)
            capybara.walk()
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

    func connectController() {
        joystick.connectController { controller in
            self.virtualController = controller
        }
    }
}
