//
//  GameOver.swift
//  TheGameDummyProject
//
//  Created by Henrik Doré on 2020-03-11.
//  Copyright © 2020 Henrik Doré. All rights reserved.
//


import UIKit
import SpriteKit

class GameOverScene: SKScene {
    var score: Int = 0
    var scoreLabel:SKLabelNode!
    var newGameButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        scoreLabel = (self.childNode(withName: "scoreLabel") as! SKLabelNode)
        scoreLabel.text = "\(score)"
        newGameButton = (self.childNode(withName: "newGameBtn") as! SKSpriteNode)
        newGameButton.texture = SKTexture(imageNamed: "newGameBtn")
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            let node = self.nodes(at: location)
            if node[0].name == "newGameBtn" {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(fileNamed: "GameScene")
                self.view?.presentScene(gameScene! , transition: transition )
            }
        }
        
    }
    
    //Är det här i som du vill spara till Firebase?
    
    
    /*
     let transition = SKTransition.flipHorizontal(withDuration: 0.5)
     let gameScene = GameScene(fileNamed: "GameScene")
         self.view?.presentScene(gameScene! , transition: transition )
     */
    
}
/*
 override func didMove(to view: SKView) {
     scoreLabel = (self.childNode(withName: "scoreLabel") as! SKLabelNode)
     scoreLabel.text = "\(score)"
     
     newGameButton = (self.childNode(withName: "newGameButton") as! SKSpriteNode)
     newGameButton.texture = SKTexture(imageNamed: "newGameButton")
 }
 */
