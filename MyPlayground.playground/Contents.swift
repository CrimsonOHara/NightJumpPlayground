
import PlaygroundSupport
import Foundation
import SpriteKit
enum GameSceneState {
    case active, gameOver
    
}

class GameScene: SKScene, SKPhysicsContactDelegate   {
    var gameState: GameSceneState = .gameOver
    var timer: CGFloat = 0
    var sinceTouch : CFTimeInterval = 0
    var scoreLabel: SKLabelNode!
    let fixedDelta: CFTimeInterval = 1.0/60.0 /* 60 FPS */
    var light: SKReferenceNode!
    var thief: SKNode!
    var coins: SKSpriteNode!
    var block: SKSpriteNode!
    var points = 0
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
    thief = self.childNode(withName: "//actualthief")!

    }
    func didBegin(_ contact: SKPhysicsContact) {
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameState != .active {
            for touch in touches {
                let location = touch.location(in: self)
                if buttonStart.contains(location) || self.atPoint(location).name == "buttonStart" {
                    buttonStart.alpha = 0
                    gameState = .active
                }
            }
        return
        }
        thief.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
        thief.physicsBody?.categoryBitMask = 4
        thief.physicsBody?.collisionBitMask = 4
    }

}

let scene = GameScene(fileNamed: "GameScene")
let view = SKView(frame: CGRect(x: 0, y: 0, width: 315, height: 465))
view.presentScene(scene)
PlaygroundPage.current.liveView = view


