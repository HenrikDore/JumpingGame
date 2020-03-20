//
//  GameWon.swift
//  TheGameDummyProject
//
//  Created by Henrik Doré on 2020-03-11.
//  Copyright © 2020 Henrik Doré. All rights reserved.
//

import Foundation
import SpriteKit
import Firebase

class gameWonScene : SKScene {
    var addHighScore = SKSpriteNode(imageNamed: "addHighscore")
    var button = SKSpriteNode(imageNamed: "newGameBtn")
    var score: Int = 0
    var scoreLabel:SKLabelNode!
    let ref = Database.database().reference()
    let userRef = Database.database().reference().child("user")
    var bestHighscore: SKLabelNode!
    
    //Defaults
    let defaults = UserDefaults.standard
    

    override func didMove(to view: SKView) {
        scoreLabel = (self.childNode(withName: "scoreLabel") as! SKLabelNode)
        scoreLabel.text = "\(score)"
        button = (self.childNode(withName: "newGameBtn") as! SKSpriteNode)
        button.texture = SKTexture(imageNamed: "newGameBtn")
        button = (self.childNode(withName: "addHighscore") as! SKSpriteNode)
        button.texture = SKTexture(imageNamed: "addHighscore")
    }
    
    func setHighScore(score: Int, name: String){
        var identifier: String?

        //Check if userdefaults is empty or not.
        if let userIdentifier = defaults.string(forKey: "reference"){
           //Retrieves the UUID from userDefaults if not emepty
           identifier = userIdentifier
        }
        else{
            //Creates a new UUID if userDefaults is empty.
            identifier = UUID().uuidString
            
            //Saving the new UUID in userdefaults
            defaults.set(identifier, forKey: "reference")
            defaults.synchronize()
        }

        ref.child("users").child(identifier!).setValue([
            "username": name,
            "score": score
        ]) { (err, _) in
            if let err = err{
                print(err.localizedDescription)
            }
            else{
                print("New data was added to the database")
            }
        }
    }
    func presentHighscore(){
        userRef.childByAutoId()

    }
    
    func getHighScoreFromFirebase(score: Int ,name: String){
        
        
        /*ref.child("players/"/* + name + "/score"*/).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.childrenCount > 0{
                /*for child in 0..<snapshot.childrenCount{
                    print(snapshot.children.allObjects ?? "inget printas")
                }*/
            }
            //let highscore = snapshot. //as? String
            //print("hej" + highscore)
        } */
        
        //let ref = FIRDatabase.database().reference().child("Users").child("Family1").child("Income")

    }
    func addPlayerName(){
        //UIView 
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "newGameBtn"{
            let transition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameScene = GameScene(fileNamed: "GameScene")
                self.view?.presentScene(gameScene! , transition: transition )
                
        
            }else if nodesArray.first?.name == "addHighscore"{

                //Will display an alertview with a textfield
                displayAlertView { (userName) in
                    print(userName, "abcdefg") //ggött
                    
                    self.setHighScore(score: self.score, name: userName)
                }

                //setHighScore(score: score, name: testname)
                
            }else if nodesArray.first?.name == "viewHighscoreBtn"{
                self.view!.window!.rootViewController!.performSegue(withIdentifier: "viewHighScore", sender: self)
            }
        }
    }
    
    fileprivate func displayAlertView(didSave: @escaping (String) -> ()){
        //Create an alert
        let alert = UIAlertController(title: "Användarnamn", message: "", preferredStyle: .alert)
        
        //Add textfield with placeholder
        alert.addTextField { (textField) in
            textField.placeholder = "Ange ett användarnamn"
        }
        
        //Add a button for executing the query
        alert.addAction(UIAlertAction(title: "Spara", style: .default, handler: { (_) in
            let textField = alert.textFields![0]
            
            //User entered an username
            didSave(textField.text!)
        }))
        
        //Add a button for cancelling
        alert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}


