import Foundation
import GameplayKit

class PlayerDieSpade: GKState {
    weak var gameScene: GameScene? //para poder acessar o que está dentro da gameScene
    
    override func didEnter(from previousState: GKState?) { //quando se entra nesse estado

    }
    
    override func willExit(to nextState: GKState) { //quando vai mudar de um estado pro outro
        <#code#>
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool { //indica quais estados podem ser acessados em seguida
        return stateClass == PlayerRunSpade.self
        return stateClass == PlayerIdleSpade.self
        return stateClass == PlayerAttackSpade.self
        return stateClass == PlayerDamageSpade.self
    }
    
    override func update(deltaTime seconds: TimeInterval) { //como o updade da GameScene
        <#code#>
    }
}

