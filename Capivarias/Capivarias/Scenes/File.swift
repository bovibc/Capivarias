/*/
// GameScene.swift
// Joystick
//
// Created by Clissia Bozzer Bovi on 02/10/23.
//
import SpriteKit
import GameplayKit
import GameController
enum ColisionType: UInt32 {
  case player = 1
  case enemy = 2
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    
  var playerSprite = SKSpriteNode(imageNamed: "parada")
  var enemySprite = SKSpriteNode(imageNamed: "parado")
  var playerPositionX: CGFloat = 0
  var playerPositionY: CGFloat = 0
  var isCapivaraWalking = false
  var virtualController: GCVirtualController?
  var background = SKSpriteNode(imageNamed: "pantanal_seco")
  var playerSpeed: CGFloat = 3
  var enemySpeed: CGFloat = 1
  let spriteScale = 0.07
  let enemyScale = 0.09
  let bottomProportion: CGFloat = 0.1537
  let topProportion: CGFloat = 0.1524
  let leftProportion: CGFloat = 0.0602
  let rightPropotion: CGFloat = 0.0686
  override func didMove(to view: SKView) {
    setupBackground()
    setupScene()
    setupBoundaries()
    setupCapivara()
    setupJacare()
    connectController()
    self.physicsWorld.contactDelegate = self
    playerSprite.physicsBody?.categoryBitMask = 1
    enemySprite.physicsBody?.categoryBitMask = 2
    enemySprite.physicsBody?.contactTestBitMask = 1
  }
  func didBegin(_ contact: SKPhysicsContact) {
    playerSpeed = 50
    let playerA = contact.bodyA
    let playerB = contact.bodyB
    print(playerA)
    print(playerB)
    if (playerA.categoryBitMask == 1 && playerB.categoryBitMask == 2){
      print("tocouuuu")
      playerSprite.position.x -= playerSpeed
    }
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
  private func setupBoundaries() {
    guard let size = scene?.size else { return }
    let topBoundary = size.height * topProportion
    let bottomBoundary = size.height * bottomProportion
    let leftBoundary = size.width * leftProportion
    let rightBoundary = size.width * rightPropotion
    let edges = UIEdgeInsets(top: bottomBoundary, left: leftBoundary, bottom: topBoundary, right: rightBoundary)
    self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame.inset(by: edges))
  }
  private func setupCapivara() {
    let screenWidth = view?.frame.width ?? 0
    let scale = screenWidth * spriteScale / playerSprite.size.width
    let texture = SKTexture(imageNamed: "parada")
    playerSprite.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
    playerSprite.physicsBody?.affectedByGravity = false
    playerSprite.position = CGPoint(x: 200, y: size.height/2)
    playerSprite.zPosition = 10
    playerSprite.setScale(scale)
    addChild(playerSprite)
    walkCapivara()
  }
  private func setupJacare() {
    let screenWidth = view?.frame.width ?? 0
    let scale = screenWidth * enemyScale / enemySprite.size.width
    let texture = SKTexture(imageNamed: "parado")
    enemySprite.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
    enemySprite.physicsBody?.affectedByGravity = false
    enemySprite.position = CGPoint(x: size.width-200, y: size.height/2)
    enemySprite.zPosition = 10
    enemySprite.setScale(scale)
    addChild(enemySprite)
    walkJacare()
  }
  override func update(_ currentTime: TimeInterval) {
    playerPositionX = CGFloat((virtualController?.controller?.extendedGamepad?.leftThumbstick.xAxis.value)!)
    playerPositionY = CGFloat((virtualController?.controller?.extendedGamepad?.leftThumbstick.yAxis.value)!)
    followPlayer(x: playerPositionX, y: playerPositionY)
    // print("x: \(playerPositionX)   Y: \(playerPositionY)")
    if (playerPositionX < 0.005 && playerPositionX > -0.005) && (playerPositionY < 0.005 && playerPositionY > -0.005) {
      stopCapivara()
      isCapivaraWalking = false
    } else {
      walkCapivara()
    }
    if playerPositionX >= 0.5 {
      playerSprite.position.x += playerSpeed
    }
    if playerPositionX <= -0.5 {
      playerSprite.position.x -= playerSpeed
    }
    if playerPositionY >= 0.5 {
      playerSprite.position.y += playerSpeed
    }
    if playerPositionY <= -0.5 {
      playerSprite.position.y -= playerSpeed
    }
    nextLevel()
  }
  private func followPlayer(x: CGFloat, y: CGFloat) {
    //Aim
    let dx = playerSprite.position.x - enemySprite.position.x
    let dy = playerSprite.position.y - enemySprite.position.y
    let angle = atan2(dy, dx)
    let vx = cos(angle) * enemySpeed
    let vy = sin(angle) * enemySpeed
    enemySprite.position.x += vx
    enemySprite.position.y += vy
    enemySprite.xScale = dx > 0 ? abs(enemySprite.xScale) : -abs(enemySprite.xScale)
    // enemySprite.zRotation = angle
  }
  private func walkJacare() {
    let textures = getTextures(name: "", atlas: "JacareSprites")
    let action = SKAction.animate(with: textures,
                   timePerFrame: 1/TimeInterval(textures.count),
                   resize: true,
                   restore: true)
    enemySprite.removeAllActions()
    enemySprite.run(SKAction.repeatForever(action))
  }
  private func walkCapivara() {
    let textures = getTextures(name: "", atlas: "CapivaraSprites")
    let action = SKAction.animate(with: textures,
                   timePerFrame: 1/TimeInterval(textures.count),
                   resize: true,
                   restore: true)
    //sprite flips
    playerSprite.xScale = playerPositionX > 0 ? abs(playerSprite.xScale) : -abs(playerSprite.xScale)
    if !isCapivaraWalking {
      isCapivaraWalking = true
      playerSprite.removeAllActions()
      playerSprite.run(SKAction.repeatForever(action))
    }
  }
  private func stopCapivara() {
    let textures = [SKTexture(imageNamed: "parada")]
    let action = SKAction.animate(with: textures,
                   timePerFrame: 0.001,
                   resize: true,
                   restore: true)
    playerSprite.removeAllActions()
    playerSprite.run(SKAction.repeatForever(action))
  }
  func connectController() {
    let controlConfig = GCVirtualController.Configuration()
    controlConfig.elements = [GCInputLeftThumbstick, GCInputButtonX, GCInputButtonY]
    let controller = GCVirtualController(configuration: controlConfig)
    controller.connect()
    virtualController = controller
  }
  private func getTextures(name: String, atlas: String) -> [SKTexture] {
    let atlas = SKTextureAtlas(named: atlas)
    var textures: [SKTexture] = []
    let name = atlas.textureNames.sorted { name1, name2 in
      return name1<name2
    }
    for i in name {
      let texture = atlas.textureNamed(i)
      texture.filteringMode = .nearest
      textures.append(texture)
    }
    return textures
  }
  func goToNextLevel(){
    let secondScene = SecondScene()
//      secondScene.scaleMode = .aspectFill
    let transition = SKTransition.fade(withDuration: 1.0)
    self.view?.presentScene(secondScene, transition: transition)
  }
  func nextLevel() {
    if playerSprite.position.x <= 145.0 {
      goToNextLevel()
    }
  }
}
*/
