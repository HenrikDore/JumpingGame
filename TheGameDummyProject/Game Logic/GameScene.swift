//
//  GameScene.swift
//  TheGameDummyProject
//
//  Created by Henrik Doré on 2020-02-28.
//  Copyright © 2020 Henrik Doré. All rights reserved.
//

import SpriteKit
import GameplayKit
import Firebase

class GameScene: SKScene {
    var bird : SKNode?
    var ground : SKNode?
    var player : SKNode?
    var joystick :SKNode?
    var finishLine : SKNode?
    
    var joystickKnob : SKNode?
    var cameraNode: SKCameraNode?
    var joystickAction = false
    var knobRadius : CGFloat = 50.0
    var previousTimeInterval : TimeInterval = 0
    let playerSpeed = 4.0
    
    let scoreLabel = SKLabelNode()
    var score = 0
    var rewardIsNotTouched = true
    
    var heartsArray = [SKSpriteNode]()
    let heartContainer = SKSpriteNode()
    var isHit = false

    let finishLineCategory : UInt32 = 0x1 << 5
    let playerCategory : UInt32 = 0x1 << 6
    let wallCategory : UInt32 = 0x1 << 8




    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        setCollisions()
        finishLine = childNode(withName: "finishLine")
        ground = childNode(withName: "ground")
        player = childNode(withName: "player")
        joystick = childNode(withName: "joystick")
        joystickKnob = joystick?.childNode(withName: "knob")
        cameraNode = childNode(withName: "cameraNode") as? SKCameraNode
        player?.position = CGPoint(x: 0 , y: 0 )
        
        /*Timer.scheduledTimer(withTimeInterval: 3, repeats: true){(timer) in
            self.spawnAirplane()
        }
        */
        heartContainer.position = CGPoint(x: -180, y: 400)
        heartContainer.zPosition = 5
        cameraNode?.addChild(heartContainer)
        fillHearts(count: 3)
        
        
        scoreLabel.position = CGPoint(x: 180 , y: 410)
        scoreLabel.fontColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        scoreLabel.fontSize = 30
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.horizontalAlignmentMode = .right
        
        scoreLabel.text = String(score)
        cameraNode?.addChild(scoreLabel)
        
        
        }
    
        
    }
    extension GameScene {
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            
        for touch in touches {
            if let joystickKnob = joystickKnob {
                let location = touch.location(in: joystick!)
                joystickAction = joystickKnob.frame.contains(location)
            }
        }
        for t in touches {
        self.touchDown(atPoint: t.location(in: self))
        }
                                         
        }
        func touchDown(atPoint pos: CGPoint) {
            jump()
        }
        func jump() {
        player?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
        }
        func rewardDiamond(){
            score += 10
            scoreLabel.text = String(score)
        }
            
        

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let joystick = joystick else {return}
        guard let joystickKnob = joystickKnob else {return}
            
        if !joystickAction {return}
            
        for touch in touches{
            let position = touch.location(in: joystick)
            let length = sqrt(pow(position.y, 2) + pow(position.x, 2))
            let angle = atan2(position.y, position.x)
                
            if knobRadius > length {
                joystickKnob.position = position
                    
            }else {
                joystickKnob.position = CGPoint(x: cos(angle) * knobRadius, y: sin(angle) * knobRadius)
                }
            
        }
        }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            
        for touch in touches {
            let xJoystickCoordinate = touch.location(in: joystick!).x
            let xLimit: CGFloat = 200.0
            
            if xJoystickCoordinate > -xLimit && xJoystickCoordinate < xLimit {
                resetKnobPosition()
                
                }
                
            }
            
        }
    }
extension GameScene {
    func resetKnobPosition(){
        let initialpoint = CGPoint(x: 0, y: 0)
        let moveBack = SKAction.move(to: initialpoint, duration: 0.1)
        moveBack.timingMode = .linear
        joystickKnob?.run(moveBack)
        joystickAction = false
        }
    func fillHearts(count: Int){
        for index in 1...count {
            let heart = SKSpriteNode(imageNamed: "heart")
            let xPos = heart.size.width * CGFloat(index - 1)
            heart.position = CGPoint(x: xPos, y: 0)
            heartsArray.append(heart)
            heartContainer.addChild(heart)
        }
        
    }
    func loseHeart(){
        if self.heartsArray.count > 0 {
            let heart = self.heartsArray.first
            heart!.removeFromParent()
            self.heartsArray.removeFirst()
            dying()

            if self.heartsArray.count == 0 {
              let loseMenu = GameOverScene(fileNamed: "GameOverScene")
                loseMenu?.scaleMode = .aspectFill
                loseMenu?.score = self.score
                self.view?.presentScene(loseMenu!)
            }
        }
    
        else {
            
        }
        noDmgTaken()
    }
    func noDmgTaken () {
            player?.physicsBody?.categoryBitMask = 0
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false){(timer) in
                self.player?.physicsBody?.categoryBitMask = 2
                
            }
        }
    func dying() {
        let die = SKAction.move(to: CGPoint(x: 0, y: -100), duration: 0.1)
        player?.run(die)
        self.removeAllActions()
        
        }
    func winGame(){
        let gameWonScreen = gameWonScene(fileNamed: "GameWon")
        gameWonScreen?.scaleMode = .aspectFill
        gameWonScreen?.score = self.score
        self.view?.presentScene(gameWonScreen!)
    }
    }
    
extension GameScene {
    override func update(_ currentTime: TimeInterval){
        let time = currentTime - previousTimeInterval
        previousTimeInterval = currentTime
        rewardIsNotTouched = true
        cameraNode?.position.x = player!.position.x
        cameraNode?.position.y = player!.position.y
        joystick?.position.y = (cameraNode?.position.y)! - 368
        joystick?.position.x = (cameraNode?.position.x)! - 0
        guard let joystickKnob = joystickKnob else {return}
        let xPosition = Double(joystickKnob.position.x)
        let displacement = CGVector(dx: time * xPosition * playerSpeed, dy: 0)
        let move = SKAction.move(by: displacement, duration: 0)
        player?.run(move)
    }
        
}

extension GameScene: SKPhysicsContactDelegate{
    
    struct collision {
        
        enum Masks: Int {
            case damage, player, ground, reward, finishLine
            var bitmask: UInt32 {return 1 << self.rawValue}
        }
        let masks: (first: UInt32, second: UInt32)
        
        func matches (_ first: Masks, _ second: Masks) -> Bool{
            return (first.bitmask == masks.first && second.bitmask == masks.second) ||
                (first.bitmask == masks.second && second.bitmask == masks.first)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collisions = collision(masks: (first: contact.bodyA.categoryBitMask, second: contact.bodyB.categoryBitMask))
        if collisions.matches(.player, .damage){
            loseHeart()
            isHit = true
            
        }
        if contact.bodyA.node?.name == "diamond" {
            contact.bodyA.node?.physicsBody?.categoryBitMask = 0
            contact.bodyA.node?.removeFromParent()

        }
        else if contact.bodyB.node?.name == "diamond"{
            contact.bodyB.node?.physicsBody?.categoryBitMask = 0
            contact.bodyB.node?.removeFromParent()

        }
        if rewardIsNotTouched {
            rewardDiamond()
            rewardIsNotTouched = false
        
        
    
//        print("Body A: \(contact.bodyA.node?.name)")
//        print("Body B: \(contact.bodyB.node?.name)")
        if collisions.matches(.finishLine, .player){
            print("Något hände")
                    winGame()
        }
            
            print("Body A: \(contact.bodyA.categoryBitMask)")
            print("Body B: \(contact.bodyB.categoryBitMask)")
            print("Body A: \(contact.bodyA.collisionBitMask)")
            print("Body B: \(contact.bodyB.collisionBitMask)")
            
            print("Did collide?? : \(collisions.matches(.player, .finishLine))")
            print("Masks: \(collisions.masks)")
            
            print("Player Category: \(playerCategory)")
            print("Finish Category: \(finishLineCategory)")
            if (contact.bodyA.categoryBitMask == collision.Masks.finishLine.rawValue || contact.bodyB.categoryBitMask == collision.Masks.finishLine.rawValue) {
                winGame()
            }
            
            
          /*  if (contact.bodyA.categoryBitMask == collisions.masks.first && contact.bodyB.categoryBitMask == collisions.masks.second) ||
            (contact.bodyB.categoryBitMask == collisions.masks.second && contact.bodyA.categoryBitMask == collisions.masks.first) {
            winGame()
            }
    */
        }

}
        func setCollisions(){
            finishLine?.physicsBody?.categoryBitMask = finishLineCategory
            finishLine?.physicsBody?.contactTestBitMask = playerCategory
            finishLine?.physicsBody?.collisionBitMask = finishLineCategory | playerCategory
            
            player?.physicsBody?.categoryBitMask = playerCategory
            player?.physicsBody?.contactTestBitMask = finishLineCategory
            player?.physicsBody?.collisionBitMask = playerCategory | finishLineCategory
            
            let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
            self.physicsBody = borderBody
            self.physicsBody?.friction = 0
            borderBody.contactTestBitMask = playerCategory | finishLineCategory
            borderBody.categoryBitMask = wallCategory
            borderBody.collisionBitMask = playerCategory | finishLineCategory
            
        }
    }

