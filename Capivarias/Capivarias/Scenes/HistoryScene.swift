//
//  HistoryScene.swift
//  Capivarias
//
//  Created by Renan Tavares on 07/12/23.
//

import Foundation
import SpriteKit

class HistoryScene: SKScene {
    var historyImage: SKSpriteNode!
    var nextButton: SKSpriteNode!
    var backButton: SKSpriteNode!
    var transactionScene = TrasactionsScenes()
    let backgroundController = BackgroundController()
    let assets = Assets()
    var history: [String] = []
    var currentDialogueindex = 0
    
    override func didMove(to view: SKView) {
        print("didmove")
        setupBackground()
        setup()
        showNextDialogue()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if currentDialogueindex > 0 {
            backButton = SKSpriteNode(imageNamed: assets.seta)
            backButton.position = CGPoint(x: (size.width * 0.05), y: size.height / 2)
            backButton.name = "backButton"
            backButton.xScale = -1.0
            addChild(backButton)
        } else {
            guard let backButton else { return}
            self.backButton.removeFromParent()
        }
    }
    
    private func setupBackground() {
        backgroundController.setupBackground(scene: self, imageName: assets.historyMap)
    }
    
    func setup() {
        print("setup")
        historyImage = SKSpriteNode(imageNamed: assets.history[currentDialogueindex])
        historyImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        historyImage.size = size
        addChild(historyImage)
        
        
        nextButton = SKSpriteNode(imageNamed: assets.seta)
        nextButton.position = CGPoint(x: size.width * 0.955, y: size.height / 2)
        nextButton.name = "nextButton"
        addChild(nextButton)
    }
    
    func showNextDialogue() {
        if currentDialogueindex < assets.history.count {
            
            // historyImage.texture = SKTexture(imageNamed: "dialogueImage\(currentDialogueIndex + 1)")
            historyImage.texture = SKTexture(imageNamed: assets.history[currentDialogueindex])
            print(historyImage.texture)
        } else {
            // Todas as falas foram exibidas, faça algo aqui, como transição para a próxima cena.
            if let view = self.view {
                transactionScene.goToNextLevel(view: view, gameScene: "FirstScene")
            }
           
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            // guard let backButton = backButton?.contains(location) else {return}
            if nextButton.contains(location) {
                // Ação ao clicar no botão (por exemplo, avançar para a próxima fala)
                currentDialogueindex += 1
                showNextDialogue()
            } else if backButton.contains(location) {
                if currentDialogueindex > 0{
                    currentDialogueindex -= 1
                    
                    showNextDialogue()
                }
                
            }
        }
        
        
    }
    
}
