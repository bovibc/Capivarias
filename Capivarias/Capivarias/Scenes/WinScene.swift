//
//  WinScene.swift
//  Capivarias
//
//  Created by Renan Tavares on 11/12/23.
//

import Foundation
import SpriteKit

class WinScene: SKScene {
    var winImage: SKSpriteNode!
    var nextButton: SKSpriteNode!
    var backButton: SKSpriteNode?
    var transactionScene = TrasactionsScenes()
    let backgroundController = BackgroundController()
    let assets = Assets()
    var currentDialogueindex = 0
    var removed: Bool = false
    
    
    override func didMove(to view: SKView) {
        print("didmove")
        setupBackground()
        setup()
        showNextDialogue()
    }
    
    
    private func setupBackground() {
        backgroundController.setupBackground(scene: self, imageName: assets.mapWin)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if currentDialogueindex == assets.win.count - 1{
            guard !removed else { return }
            self.nextButton?.removeFromParent()
            removed = true
            addPlayAgainButton()
            goToMenu()
        }
    }

    
    
    
    func setup() {
        print("setup")
        winImage = SKSpriteNode(imageNamed: assets.win[currentDialogueindex])
        winImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        winImage.size = size
        addChild(winImage)

        nextButton = SKSpriteNode(imageNamed: assets.seta)
        nextButton.position = CGPoint(x: size.width * 0.955, y: size.height / 2)
        nextButton.name = "nextButton"
        addChild(nextButton)
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       // guard let backButton else { return}
        for touch in touches {
            let location = touch.location(in: self)
            if nextButton.contains(location) {
                // Ação ao clicar no botão (por exemplo, avançar para a próxima fala)
                currentDialogueindex += 1
                showNextDialogue()
            } else if ((backButton?.contains(location)) != nil) {
                if currentDialogueindex > 0 {
                    currentDialogueindex -= 1
                    showNextDialogue()
                }
            }
        }
    }

    func showNextDialogue() {
        if currentDialogueindex < assets.win.count {
            guard let winImage else {return}
            winImage.texture = SKTexture(imageNamed: assets.win[currentDialogueindex])
        } else {
            // Todas as falas foram exibidas, faça algo aqui, como transição para a próxima cena.
            if let view = self.view {
                transactionScene.goToNextLevel(view: view, gameScene: "FirstScene")
            }
        }
    }
    
    
    
    private func addPlayAgainButton() {
        let buttonTexture = SKTexture(imageNamed: assets.playagain)
        let button = SKButtonNode(texture: buttonTexture)
        
        let buttonSize = CGSize(width: 550, height: 120)
        button.size = buttonSize
  
        button.position = CGPoint(x: size.width / 2, y: size.height - size.height / 3)

        let scaleUp = SKAction.scale(to: 1.1, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
        var buttonAction = SKAction.sequence([scaleUp, scaleDown])
        
        
        button.name = "Jogar"
        addChild(button)
        
        button.setButtonAction {
            print("Botão foi tocado!")

            let scaleAction = SKAction.sequence([
                SKAction.scale(to: 1.2, duration: 0.1),
                SKAction.scale(to: 1.0, duration: 0.1)
            ])
            
            button.run(scaleAction)
            
            if let view = self.view {
                self.transactionScene.goToNextLevel(view: view, gameScene: "FirstScene")
            }
            
        }
    }
    
    
    private func goToMenu() {
        let buttonTexture = SKTexture(imageNamed: assets.menu)
        let button = SKButtonNode(texture: buttonTexture)
        
        let buttonSize = CGSize(width: 350, height: 120)
        button.size = buttonSize
  
        button.position = CGPoint(x: size.width / 2, y: size.height - size.height / 1.8)

        let scaleUp = SKAction.scale(to: 1.1, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
        var buttonAction = SKAction.sequence([scaleUp, scaleDown])
        
        
        button.name = "Jogar"
        addChild(button)
        
        button.setButtonAction {
            print("Botão foi tocado!")

            let scaleAction = SKAction.sequence([
                SKAction.scale(to: 1.2, duration: 0.1),
                SKAction.scale(to: 1.0, duration: 0.1)
            ])
            
            button.run(scaleAction)
            
            if let view = self.view {
                self.transactionScene.goToNextLevel(view: view, gameScene: "MenuGameScene")
            }
            
        }
    }
    
    
}
