//
//  GameOver.swift
//  Capivarias
//
//  Created by Ricardo de Agostini Neto on 01/11/23.
//


import SpriteKit
import GameplayKit
import GameController

class MenuGameScene: SKScene {
    
    let backgroundController = BackgroundController()
    var alligator = Alligator()
    var capybara = Capybara()
    var transactionScene = TrasactionsScenes()
    let sounds = Sounds()
    let assets = Assets()
    
    
    override func didMove(to view: SKView) {
        setupScene()
        setupBackground()
        cancelMusic()
        cancelEffect()
        credits()
        addPlayAgainButton()
        AudioPlayer.shared.EnviromentSong()
    }
    
    private func setupBackground() {
        backgroundController.setupBackground(scene: self, imageName: assets.backgroundMenu)
    }
    
    private func setupScene() {
        scene?.anchorPoint = .zero
        scene?.size = CGSize(width: view?.scene?.size.width ?? 600, height: view?.scene?.size.height ?? 800)
    }
    
    private func addPlayAgainButton() {
        let buttonTexture = SKTexture(imageNamed: "Jogar")
        let button = SKButtonNode(texture: buttonTexture)
        
        let buttonSize = CGSize(width: 250, height: 125)
        button.size = buttonSize
  
        button.position = CGPoint(x: size.width / 2, y: size.height - size.height / 1.74)

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
    
    private func cancelMusic() {
        let buttonTexture = SKTexture(imageNamed: "Musica")
        let button = SKButtonNode(texture: buttonTexture)
        var playingMusic: Bool = false
        
        let buttonSize = CGSize(width: 115, height: 170)
        button.size = buttonSize
        
        button.position = CGPoint(x: size.width / 1.7, y: size.height - size.height / 1.4)

        button.name = "Musicas"
        addChild(button)
        
        button.setButtonAction {
            print("Botão foi tocado!")
            
            AudioPlayer.shared.enviromentSong.toggle()
            AudioPlayer.shared.EnviromentSong()
            if playingMusic {
                let buttonTexture = SKTexture(imageNamed: "Musica")
                button.texture = buttonTexture
                playingMusic.toggle()
            } else {
                let buttonTexture = SKTexture(imageNamed: "SemMusica")
                button.texture = buttonTexture
                playingMusic.toggle()
            }

        }
    }
    
    private func cancelEffect() {
        let buttonTexture = SKTexture(imageNamed: "Efeitos")
        let button = SKButtonNode(texture: buttonTexture)
        var playingEffect: Bool = false
        
        let buttonSize = CGSize(width: 115, height: 170)
        button.size = buttonSize
  
        button.position = CGPoint(x: size.width / 2.4, y: size.height - size.height / 1.4)
        
        
        button.name = "Efeitos"
        addChild(button)
        
        button.setButtonAction  {
            print("Botão foi tocado!")
            AudioPlayer.shared.effectPlayerSong.toggle()
            if playingEffect {
                let buttonTexture = SKTexture(imageNamed: "Efeitos")
                button.texture = buttonTexture
                playingEffect.toggle()
            } else {
                let buttonTexture = SKTexture(imageNamed: "SemEfeitos")
                button.texture = buttonTexture
                playingEffect.toggle()
            }
        }
    }
    
    private func credits() {
        let buttonTexture = SKTexture(imageNamed: "Creditos")
        let button = SKButtonNode(texture: buttonTexture)
        
        let buttonSize = CGSize(width: 250, height: 125)
        button.size = buttonSize
        
        button.position = CGPoint(x: size.width / 2, y: size.height - size.height / 1.17)
        
        button.name = "Creditos"
        addChild(button)
        
        button.setButtonAction {
            print("Botão foi tocado!")
            if let scene = GKScene(fileNamed: "CreditsScene") {
                if let sceneNode = scene.rootNode as? CreditsScene {
                    if let view = self.view {
                        view.presentScene(sceneNode)
                    }
                }
            }
        }
    }
}


