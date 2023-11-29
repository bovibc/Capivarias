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
    //var audioPlayer = AudioPlayer()
    let sounds = Sounds()
    let assets = Assets()
    
    
    override func didMove(to view: SKView) {
        setupScene()
        //setupBackground()
        cancelSong()
        cancelMusic()
        credits()
        addPlayAgainButton()
        //audioPlayer.playEffect(effect: sounds.deathMenu, type: "mp3", volume: 1.0)
       // addGoToMenuButton()
        //AudioPlayer.shared.playEnviroment(sound: sounds.ambient, type: "mp3", volume: 1.0)
       
        AudioPlayer.shared.EnviromentSong()
    }
    

    private func setupBackground() {
        backgroundController.setupBackground(scene: self, imageName: assets.map3)
    }
    
    private func setupScene() {
        scene?.anchorPoint = .zero
        scene?.size = CGSize(width: view?.scene?.size.width ?? 600, height: view?.scene?.size.height ?? 800)
    }
    
    

    
    
    private func addPlayAgainButton() {
        let buttonTexture = SKTexture(imageNamed: "ButtonPlayAgain")
        let button = SKButtonNode(texture: buttonTexture)
        
        
        let buttonSize = CGSize(width: 250, height: 80) // Substitua pelos valores desejados
        button.size = buttonSize
        
        // Configurar a posição do botão no meio da tela
        button.position = CGPoint(x: size.width / 2, y: size.height - size.height / 3)
        
        // Configurar a ação de animação ao tocar no botão
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.1) // Aumenta o tamanho do botão em 10%
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1) // Reduz o tamanho de volta ao tamanho original
        var buttonAction = SKAction.sequence([scaleUp, scaleDown])
        

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
                        //self.transactionScene.goToNextLevel(view: view., gameScene: "GameScene")
                        view.presentScene(sceneNode)
                    }
                }
            }
        }
    }
    
    
    private func cancelSong() {
        let buttonTexture = SKTexture(imageNamed: "ButtonGameOver")
        let button = SKButtonNode(texture: buttonTexture)
        
        let buttonSize = CGSize(width: 125, height: 80) // Substitua pelos valores desejados
        button.size = buttonSize
        
        // Configurar a posição do botão no meio da tela
        button.position = CGPoint(x: size.width / 1.7, y: size.height - size.height / 2)
        

        button.name = "playButton"
        addChild(button)
        
        button.setButtonAction { 
            print("Botão foi tocado!")
            AudioPlayer.shared.enviromentSong.toggle()
            AudioPlayer.shared.EnviromentSong()
            
            // Adicione aqui as ações que deseja executar quando o botão for tocado.
        }
    }
    
    private func cancelMusic() {
        let buttonTexture = SKTexture(imageNamed: "ButtonGameOver")
        let button = SKButtonNode(texture: buttonTexture)
        
        let buttonSize = CGSize(width: 125, height: 80) // Substitua pelos valores desejados
        button.size = buttonSize
        
        // Configurar a posição do botão no meio da tela
        button.position = CGPoint(x: size.width / 2.5, y: size.height - size.height / 2)
        

        button.name = "playButton"
        addChild(button)
        
        button.setButtonAction  { [weak self] in
            print("Botão foi tocado!")
            
            // Adicione aqui as ações que deseja executar quando o botão for tocado.
        }
    }
    
    
    private func credits() {
        let buttonTexture = SKTexture(imageNamed: "ButtonGameOver")
        let button = SKButtonNode(texture: buttonTexture)
        
        let buttonSize = CGSize(width: 250, height: 80) // Substitua pelos valores desejados
        button.size = buttonSize
        
        // Configurar a posição do botão no meio da tela
        button.position = CGPoint(x: size.width / 2, y: size.height - size.height / 1.5)

        button.name = "playButton"
        addChild(button)
        
        button.setButtonAction {
            print("Botão foi tocado!")

            // Adicione aqui as ações que deseja executar quando o botão for tocado.
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
        var buttonAction = SKAction.sequence([scaleUp, scaleDown])
        

        button.name = "playAgainButton"
        addChild(button)
        
        button.setButtonAction {
            let scaleAction = SKAction.sequence([
                SKAction.scale(to: 1.2, duration: 0.1),
                SKAction.scale(to: 1.0, duration: 0.1)
            ])

            button.run(scaleAction)
        }
    }
    
}
        
        
