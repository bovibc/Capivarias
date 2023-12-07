//
//  GameOver.swift
//  Capivarias
//
//  Created by Ricardo de Agostini Neto on 01/11/23.
//


import SpriteKit
import GameplayKit
import GameController


class GameOverGameScene: SKScene {
    
    let backgroundController = BackgroundController()
    var alligator = Alligator()
    var capybara = Capybara()
    var transactionScene = TrasactionsScenes()
    //var audioPlayer = AudioPlayer()
    let sounds = Sounds()
    let assets = Assets()
    
    
    override func didMove(to view: SKView) {
        setupScene()
        setupBackground()
        addCenterButton()
        addPlayAgainButton()
        AudioPlayer.shared.playEffect(effect: sounds.deathMenu, type: "mp3", volume: 0.4)
       // addGoToMenuButton()
    
    }
    
    private func setupBackground() {
        backgroundController.setupBackground(scene: self, imageName: assets.gameOverMap)
    }
    
    private func setupScene() {
        scene?.anchorPoint = .zero
        scene?.size = CGSize(width: view?.scene?.size.width ?? 600, height: view?.scene?.size.height ?? 800)
    }
    
    private func addCenterButton() {
        let buttonTexture = SKTexture(imageNamed: "go to menu2")
        let button = SKButtonNode(texture: buttonTexture)
        
        
        let buttonSize = CGSize(width: 350, height: 120) // Substitua pelos valores desejados
        button.size = buttonSize
        
        // Configurar a posição do botão no meio da tela
        button.position = CGPoint(x: size.width / 3, y: size.height - size.height / 1.18)
        
        

        button.name = "go to menu"
        addChild(button)
        
        button.setButtonAction {
            // Adicione aqui as ações que deseja executar quando o botão for tocado.
        }
    }
    
    
    
    private func addPlayAgainButton() {
        let buttonTexture = SKTexture(imageNamed: "play again button2")
        let button = SKButtonNode(texture: buttonTexture)
        
        
        let buttonSize = CGSize(width: 550, height: 120) // Substitua pelos valores desejados
        button.size = buttonSize
        
        // Configurar a posição do botão no meio da tela
        button.position = CGPoint(x: size.width / 3, y: size.height - size.height / 1.43)
        
        // Configurar a ação de animação ao tocar no botão
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.1) // Aumenta o tamanho do botão em 10%
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1) // Reduz o tamanho de volta ao tamanho original
        var buttonAction = SKAction.sequence([scaleUp, scaleDown])
        

        button.name = "play again"
        addChild(button)
        
        button.setButtonAction {
            
            // Realizar a animação de escala (pode ajustar os valores)
            let scaleAction = SKAction.sequence([
                SKAction.scale(to: 1.2, duration: 0.1),
                SKAction.scale(to: 1.0, duration: 0.1)
            ])
            
            button.run(scaleAction)

            
            if let scene = GKScene(fileNamed: "GameScene") {
                if let sceneNode = scene.rootNode as? GameScene {
                    if let view = self.view {
                        self.transactionScene.goToNextLevel(view: view, gameScene: "GameScene")
                    }
                }
            }
        }
    }
    
    
//    private func addGoToMenuButton() {
//        let buttonTexture = SKTexture(imageNamed: "ButtonGoToMenu")
//        let button = SKButtonNode(texture: buttonTexture)
//        
//        
//        let buttonSize = CGSize(width: 500, height: 160) // Substitua pelos valores desejados
//        button.size = buttonSize
//        
//        // Configurar a posição do botão no meio da tela
//        button.position = CGPoint(x: size.width / 2, y: size.height - size.height / 2)
//        
//        // Configurar a ação de animação ao tocar no botão
//        let scaleUp = SKAction.scale(to: 1.1, duration: 0.1) // Aumenta o tamanho do botão em 10%
//        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1) // Reduz o tamanho de volta ao tamanho original
//        var buttonAction = SKAction.sequence([scaleUp, scaleDown])
//        
//
//        button.name = "playAgainButton"
//        addChild(button)
//        
//        button.setButtonAction {
//            let scaleAction = SKAction.sequence([
//                SKAction.scale(to: 1.2, duration: 0.1),
//                SKAction.scale(to: 1.0, duration: 0.1)
//            ])
//
//            button.run(scaleAction)
//        }
//    }
    
    
    
    
    
    
    
    
    
    
}
        
        
