
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
    
    func randomBetweenNumbers(_ firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
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
        if gameState != .active { return }
        
        /* Get references to bodies involved in collision */
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        
        /* Get references to the physics body parent nodes */
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        // thief gets coin, add points
        if (nodeA.name == "coinSprite" && nodeB.name == "thief") || (nodeB.name == "coinSprite" && nodeA.name == "thief") {
            points += 1
            scoreLabel.text = String(points)
            if nodeA.name == "coinSprite" {
                nodeA.removeFromParent()
            } else {
                nodeB.removeFromParent()
            }
            return
        }
        // thief hits the light, while the shield is off game over
        if !shieldIsUp && !light.isHidden  &&
            (nodeA.name == "light" && nodeB.name == "thief" || nodeA.name == "thief" && nodeB.name == "light" ) {
            gameState = .gameOver
            thief.physicsBody?.allowsRotation = false
            thief.physicsBody?.angularVelocity = 0
            thief.removeAllActions()
            buttonStart.alpha = 1
            return
        }
        // thief hits the block, game is over
        if (nodeA.name == "block" && nodeB.name == "thief") || (nodeA.name == "thief" && nodeB.name == "block") {
            gameState = .gameOver
            thief.physicsBody?.allowsRotation = false
            thief.physicsBody?.angularVelocity = 0
            thief.removeAllActions()
            buttonStart.alpha = 1
            return
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameState != .active { return }
        let velocityY = thief.physicsBody?.velocity.dy ?? 0
        if velocityY > 400 {
            thief.physicsBody?.velocity.dy = 400
        }
        arc4random_uniform(3)
        timer += CGFloat(0.1)
        scrollWorld()
        
        if(currentTime - lastLight > 5){
            lastLight = currentTime
            light.isHidden = !light.isHidden
        }
        
        if(currentTime - lastShield > 4.5) {
            lastShield = currentTime
            shield.isHidden = !shield.isHidden
        }
        
    }
    
    func scrollWorld() {
        scrollLayer.position.x -= scrollSpeed
        for scroll in scrollLayer.children as! [SKSpriteNode] {
            let scrollPosition = scrollLayer.convert(scroll.position, to: self)
            if scrollPosition.x <= 0 {
                scroll.removeFromParent()
            }
        }
        if timer >= 10 {
            
            var buildingArray = ["tallPurple3.png", "shortGreen2.png", "averageBlue1.png"]
            let obstacleNum = arc4random_uniform(UInt32(buildingArray.count))
            let newObstacle = SKSpriteNode (imageNamed: buildingArray[Int(obstacleNum)])
            newObstacle.physicsBody = SKPhysicsBody()
            newObstacle.physicsBody = SKPhysicsBody(rectangleOf: newObstacle.size)
            newObstacle.physicsBody?.isDynamic = false
            newObstacle.physicsBody?.categoryBitMask = 4
            newObstacle.physicsBody?.collisionBitMask = 1
            newObstacle.physicsBody?.allowsRotation = false
            newObstacle.zPosition = 0
            newObstacle.physicsBody?.pinned = false
            newObstacle.physicsBody?.affectedByGravity = false
            scrollLayer.addChild(newObstacle)
            
            
            var newCoin = coins.copy() as! SKSpriteNode
            var coinPos = newObstacle.position
            newCoin.physicsBody = SKPhysicsBody()
            newCoin.physicsBody = SKPhysicsBody(circleOfRadius: newCoin.size.width)
            newCoin.physicsBody?.isDynamic = false
            newCoin.physicsBody?.allowsRotation = false
            newCoin.physicsBody?.pinned = false
            newCoin.physicsBody?.affectedByGravity = false
            newCoin.physicsBody?.collisionBitMask = 4
            coinPos.y = newObstacle.size.height / 2 + 20
            coinPos.x = 0
            
            newCoin.run(SKAction.move(to: coinPos, duration: 0))
            newObstacle.addChild(newCoin)
            
            newCoin = coins.copy() as! SKSpriteNode
            coinPos = newObstacle.position
            coinPos.y = newObstacle.size.height / 2 + 20
            coinPos.x = 100
            
            newCoin.run(SKAction.move(to: coinPos, duration: 0))
            newObstacle.addChild(newCoin)
            
            newCoin = coins.copy() as! SKSpriteNode
            coinPos = newObstacle.position
            coinPos.y = newObstacle.size.height / 2 + 20
            coinPos.x = -50
            
            newCoin.run(SKAction.move(to: coinPos, duration: 0))
            newObstacle.addChild(newCoin)
            
            newCoin = coins.copy() as! SKSpriteNode
            coinPos = newObstacle.position
            coinPos.y = newObstacle.size.height / 2 + 20
            coinPos.x = -100
            
            newCoin.run(SKAction.move(to: coinPos, duration: 0))
            newObstacle.addChild(newCoin)
            
            newCoin = coins.copy() as! SKSpriteNode
            coinPos = newObstacle.position
            coinPos.y = newObstacle.size.height / 2 + 20
            coinPos.x = 50
            
            newCoin.run(SKAction.move(to: coinPos, duration: 0))
            newObstacle.addChild(newCoin)
            
            // controlling the size of obstacles
            let randomYScale = CGPoint(x: 352, y: CGFloat(randomBetweenNumbers(0.5, secondNum: 2)))
            while newObstacle.xScale > 0.47 {
                newObstacle.xScale = CGFloat(arc4random()) / CGFloat(UINT32_MAX) + 0.3
            }
            while newObstacle.yScale > 0.8 {
                newObstacle.yScale = CGFloat(arc4random()) / CGFloat(UINT32_MAX) + 0.5
            }
            newObstacle.position = self.convert(randomYScale, to: scrollLayer)
            timer = 0
        }
        
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


