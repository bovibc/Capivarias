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
    var backButton: SKSpriteNode?
    var transactionScene = TrasactionsScenes()
    let backgroundController = BackgroundController()
    let assets = Assets()
    var history: [String] = []
    var currentDialogueindex = 0
    var removed: Bool = false

    override func didMove(to view: SKView) {
        print("didmove")
        setupBackground()
        setup()
        showNextDialogue()
    }

    override func update(_ currentTime: TimeInterval) {
        if currentDialogueindex > 0 {
            guard removed else { return }
            backButton = SKSpriteNode(imageNamed: assets.seta)
            backButton?.name = "backButton"
            backButton?.position = CGPoint(x: (size.width * 0.05), y: size.height / 2)
            backButton?.xScale = -1.0
            removed = false
            addChild(backButton ?? SKSpriteNode())
        } else {
            guard !removed else { return }
            self.backButton?.removeFromParent()
            removed = true
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
        if currentDialogueindex < assets.history.count {
            guard let historyImage else {return}
            historyImage.texture = SKTexture(imageNamed: assets.history[currentDialogueindex])
        } else {
            // Todas as falas foram exibidas, faça algo aqui, como transição para a próxima cena.
            if let view = self.view {
                transactionScene.goToNextLevel(view: view, gameScene: "FirstScene")
            }
        }
    }
    
}
