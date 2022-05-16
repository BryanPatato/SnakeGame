//
//  GameScene.swift
//  SnakeGame
//
//  Created by BRYAN RUIZ on 5/3/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    let cam = SKCameraNode()
    private var snake:SKSpriteNode?
    private var score:SKLabelNode?
    private var scoreNum:Int = 0
    private var lastUpdateTime : TimeInterval = 0
    private var laser:[SKSpriteNode] = []
    private var label : SKLabelNode?
    private var monkeys:[SKSpriteNode] = []
    private var walls:[SKSpriteNode] = []
    private var monkeDead = false
    private var monkeDead2 = false
    private var snakeDead = false
    
    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
        self.lastUpdateTime = 0
        self.snake = self.childNode(withName: "Snake") as? SKSpriteNode
        self.monkeys.append(self.childNode(withName: "Monke") as! SKSpriteNode)
        self.monkeys.append(self.childNode(withName: "Monke2") as! SKSpriteNode)
        self.monkeys.append(self.childNode(withName: "Monke3") as! SKSpriteNode)
        monkeys.append(self.childNode(withName: "Monke4") as! SKSpriteNode)
        self.monkeys.append(self.childNode(withName: "Monke5") as! SKSpriteNode)
        self.monkeys.append(self.childNode(withName: "Monke6") as! SKSpriteNode)
        self.walls.append(self.childNode(withName: "Ramp") as! SKSpriteNode)
        self.walls.append(self.childNode(withName: "Top") as! SKSpriteNode)
        self.walls.append(self.childNode(withName: "Floor") as! SKSpriteNode)
        self.walls.append(self.childNode(withName: "LeftW") as! SKSpriteNode)
        self.score =  self.childNode(withName: "ScoreLabel") as? SKLabelNode
        self.score!.zPosition = 5
        let zoomAction = SKAction.scale(to: 2.0, duration: 1)
        cam.run(zoomAction)
        self.camera = cam
        
    }
    
    override func didMove(to view: SKView) {
    }
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
            var i = 0
            for each in monkeys {
                if (contact.bodyA.node!.name == each.name!) && (contact.bodyB.node!.name == "Snake") {
                    if "Monke5" == each.name {
                    monkeDead = true
                    }
                    if "Monke6" == each.name {
                    monkeDead2 = true
                    }
                    scoreNum += 1
                    score!.text = "Score: \(scoreNum)"
                    each.removeFromParent()
                    //monkeys.remove(at: i)
                }
                i += 1
            }
        if (contact.bodyA.node!.name == "Laser") && (contact.bodyB.node!.name == "Snake"){
            snakeDead = true
            reset()
        }
        for pew in laser {
        for each in walls {
            if (contact.bodyA.node!.name == each.name ) && (contact.bodyB.node!.name == pew.name) {
                pew.removeFromParent()
            }
        }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.snake!.physicsBody?.velocity.dx = 500
        self.snake!.physicsBody?.velocity.dy = 750
        self.snake!.physicsBody?.angularVelocity += -5
        self.snake!.physicsBody?.restitution = 1.0
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func reset(){
        if snakeDead == true {
            snake!.removeFromParent()
            self.snake!.position = CGPoint(x: -4437.0, y: -374.0)
            self.addChild(self.snake!)
            snakeDead = false
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        cam.position = snake!.position
        score!.position.y = snake!.position.y + 600
        score!.position.x = snake!.position.x + 900
        let rand =  Int.random(in: 0...54)
        if rand == 53 {
            for each in monkeys{
                if each.name == "Monke5" && monkeDead == false {
                    laser.append(SKSpriteNode(color: UIColor.blue, size: CGSize(width: 100, height: 15)))
                    laser.last!.name = "Laser"
                    laser.last!.zRotation = 0.1
                    laser.last!.zPosition = 0
                    laser.last!.position = monkeys[4].position
                   // laser.last!.position.x  = -374.759
                   // laser.last!.position.y = -320
                    laser.last!.physicsBody = SKPhysicsBody(rectangleOf: laser.last!.size)
                    laser.last!.physicsBody!.affectedByGravity = false
                    laser.last!.physicsBody!.contactTestBitMask = 1
                    laser.last!.physicsBody!.categoryBitMask = 1
                    self.addChild(laser.last!)
                    let xvalue = (snake!.position.x + laser.last!.position.x)/2
                    let yvalue = (snake!.position.y + laser.last!.position.y)/2
                    //print(xvalue)
                    //print(yvalue)
                    if xvalue < yvalue {
                        laser.last!.physicsBody!.velocity.dx = xvalue * 100
                        laser.last!.physicsBody!.velocity.dy = (xvalue/2) * 124
                    } else {
                        laser.last!.physicsBody!.velocity.dy = yvalue * 100
                        laser.last!.physicsBody!.velocity.dx = (yvalue/2) * 124
                    }
                }
                    if each.name == "Monke6" && monkeDead2 == false {
                        laser.append(SKSpriteNode(color: UIColor.blue, size: CGSize(width: 150, height: 50)))
                        laser.last!.name = "Laser"
                        laser.last!.zRotation = 0
                        laser.last!.zPosition = 1
                        laser.last!.position = monkeys[5].position
                        laser.last!.physicsBody = SKPhysicsBody(rectangleOf: laser.last!.size)
                        laser.last!.physicsBody!.affectedByGravity = false
                        laser.last!.physicsBody!.contactTestBitMask = 1
                        laser.last!.physicsBody!.categoryBitMask = 1
                        self.addChild(laser.last!)
                         let xvalue2 = (snake!.position.x + laser.last!.position.x)/2
                         let yvalue2 = (snake!.position.y + laser.last!.position.y)/2
                        print(xvalue2)
                        print(yvalue2)
                        laser.last!.physicsBody!.velocity.dx = -10000
                    }
                }
            }
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
