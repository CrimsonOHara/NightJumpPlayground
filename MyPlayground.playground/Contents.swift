
import PlaygroundSupport
import Foundation
import SpriteKit
enum GameSceneState {
    case active, gameOver
    
}

class GameScene: SKScene, SKPhysicsContactDelegate   {
    var gameState: GameSceneState = .active
    var timer: CGFloat = 0
    var sinceTouch : CFTimeInterval = 0
    var scoreLabel: SKLabelNode!
    let fixedDelta: CFTimeInterval = 1.0/60.0 /* 60 FPS */
    var light: SKReferenceNode!
    var coins: SKSpriteNode!
    var block: SKSpriteNode!
    var points = 0
    var thief: SKSpriteNode!
    var scrollLayer: SKNode!
    let scrollSpeed: CGFloat = 2
    var shield: SKSpriteNode!
    var lastLight: CFTimeInterval = 0
    var lastShield: CFTimeInterval = 0
    var shieldIsUp = false
    var buttonStart: SKNode!
    
    override func didMove(to view: SKView) {
    self.physicsWorld.contactDelegate = self
    buttonStart = self.childNode(withName: "buttonStart")!
    }
    func didBegin(_ contact: SKPhysicsContact) {
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if buttonStart.contains(location) || self.atPoint(location).name == "buttonStart" {
                buttonStart.alpha = 0
                gameState = .active
            }
        }
    }

    
}

let scene = GameScene(fileNamed: "GameScene")
let view = SKView(frame: CGRect(x: 0, y: 0, width: 315, height: 465))
view.presentScene(scene)
PlaygroundPage.current.liveView = view


