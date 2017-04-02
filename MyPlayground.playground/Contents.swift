
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
    var points = 0
    var lastLight: CFTimeInterval = 0
    var lastShield: CFTimeInterval = 0
    var shieldIsUp = false
    let fixedDelta: CFTimeInterval = 1.0/60.0 /* 60 FPS */
    let scrollSpeed: CGFloat = 2
    
    var scoreLabel: SKLabelNode!
    var light: SKNode!
    var thief: SKNode!
    var coins: SKNode!
    var shield: SKNode!
    var buttonStart: SKNode!
    var scrollLayer: SKNode!
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        buttonStart = self.childNode(withName: "buttonStart")!
        thief = self.childNode(withName: "//actualthief")!
        shield = self.childNode(withName: "//shield")!
        scrollLayer = self.childNode(withName: "//scrollLayer")!
        light = self.childNode(withName: "//lightReference")!
        coins = self.childNode(withName: "//coinSprite")!
        scoreLabel = self.childNode(withName: "//scoreLabel") as! SKLabelNode
        coins.physicsBody?.categoryBitMask = 4
        light.run(SKAction.hide())
        scoreLabel.text = String(points)

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
        sinceTouch = 0
        for touch in touches {
            let location = touch.location(in: self)
            if shield.contains(location) || self.atPoint(location).name == "shield" {
                shieldIsUp = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if shield.contains(location) {
                shieldIsUp = false
            }
            if self.atPoint(location).name == "shield" {
                if (shieldIsUp) {
                    shieldIsUp = false
                }
            }
        }
    }

}

let scene = GameScene(fileNamed: "GameScene")
let view = SKView(frame: CGRect(x: 0, y: 0, width: 315, height: 465))
view.presentScene(scene)
PlaygroundPage.current.liveView = view


