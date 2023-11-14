//
//  GameOver.swift
//  Capivarias
//
//  Created by Ricardo de Agostini Neto on 01/11/23.
//


import SpriteKit
import GameplayKit
import GameController

class SKButtonNode: SKSpriteNode {
    var action: (() -> Void)?

    func setButtonAction(target: @escaping () -> Void) {
        self.isUserInteractionEnabled = true
        self.action = target
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let action = action {
            action()
        }
    }
}


class GameOverGameScene: SKScene {
    
    let backgroundController = BackgroundController()
    var alligator = Alligator()
    var capybara = Capybara()
    var transactionScene = TrasactionsScenes()
    var audioPlayer = AudioPlayer()
    let sounds = Sounds()
    let assets = Assets()
    
    
    override func didMove(to view: SKView) {
        setupScene()
        setupBackground()
        addCenterButton()
        addPlayAgainButton()
        audioPlayer.playEffect(effect: sounds.deathMenu, type: "mp3", volume: 1.0)
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
        let buttonTexture = SKTexture(imageNamed: "ButtonGameOver")
        let button = SKButtonNode(texture: buttonTexture)
        
        
        let buttonSize = CGSize(width: 1000, height: 500) // Substitua pelos valores desejados
        button.size = buttonSize
        
        // Configurar a posição do botão no meio da tela
        button.position = CGPoint(x: size.width / 2, y: size.height - size.height / 4)
        
        

        button.name = "playButton"
        addChild(button)
        
        button.setButtonAction {
            print("Botão foi tocado!")

            // Adicione aqui as ações que deseja executar quando o botão for tocado.
        }
    }
    
    
    
    private func addPlayAgainButton() {
        let buttonTexture = SKTexture(imageNamed: "ButtonPlayAgain")
        let button = SKButtonNode(texture: buttonTexture)
        
        
        let buttonSize = CGSize(width: 500, height: 160) // Substitua pelos valores desejados
        button.size = buttonSize
        
        // Configurar a posição do botão no meio da tela
        button.position = CGPoint(x: size.width / 2, y: size.height - size.height / 1.5)
        
        // Configurar a ação de animação ao tocar no botão
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.1) // Aumenta o tamanho do botão em 10%
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1) // Reduz o tamanho de volta ao tamanho original
        let buttonAction = SKAction.sequence([scaleUp, scaleDown])
        

        button.name = "playAgainButton"
        addChild(button)
        
        button.setButtonAction {
            print("Botão foi tocado!")
            
            // Realizar a animação de escala (pode ajustar os valores)
            let scaleAction = SKAction.sequence([
                SKAction.scale(to: 1.2, duration: 0.1),
                SKAction.scale(to: 1.0, duration: 0.1)
            ])
            
            button.run(scaleAction)

            
            if let scene = GKScene(fileNamed: "GameScene") {
                if let sceneNode = scene.rootNode as? GameScene {
                    if let view = self.view {
                        self.transactionScene.goToNextLevel(view: view, gameScene: sceneNode)
                    }
                }
            }
        }
    }
    
    
    private func addGoToMenuButton() {
        let buttonTexture = SKTexture(imageNamed: "ButtonGoToMenu")
        let button = SKButtonNode(texture: buttonTexture)
        
        
        let buttonSize = CGSize(width: 500, height: 160) // Substitua pelos valores desejados
        button.size = buttonSize
        
        // Configurar a posição do botão no meio da tela
        button.position = CGPoint(x: size.width / 2, y: size.height - size.height / 2)
        
        // Configurar a ação de animação ao tocar no botão
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.1) // Aumenta o tamanho do botão em 10%
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1) // Reduz o tamanho de volta ao tamanho original
        let buttonAction = SKAction.sequence([scaleUp, scaleDown])
        

        button.name = "playAgainButton"
        addChild(button)
        
        button.setButtonAction {
            print("Botão foi tocado!")
            
            // Realizar a animação de escala (pode ajustar os valores)
            let scaleAction = SKAction.sequence([
                SKAction.scale(to: 1.2, duration: 0.1),
                SKAction.scale(to: 1.0, duration: 0.1)
            ])
            
            button.run(scaleAction)
            // Adicione aqui as ações que deseja executar quando o botão for tocado.
        }
    }
    
    
    
    
    
    
    
    
    
    
}
        
        
