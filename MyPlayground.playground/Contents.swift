
import PlaygroundSupport
import Foundation
import SpriteKit
enum GameSceneState {
    case active, gameOver
    
}



class GameScene: SKScene, SKPhysicsContactDelegate   {
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
            }
        }
    }

    
}

let scene = GameScene(fileNamed: "GameScene")
let view = SKView(frame: CGRect(x: 0, y: 0, width: 315, height: 465))
view.presentScene(scene)
PlaygroundPage.current.liveView = view


