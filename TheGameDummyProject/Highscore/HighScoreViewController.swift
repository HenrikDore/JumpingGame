//
//  HighScoreViewController.swift
//  TheGameDummyProject
//
//  Created by Henrik Doré on 2020-03-19.
//  Copyright © 2020 Henrik Doré. All rights reserved.
//

import UIKit
import Firebase

class HighScoreViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let ref = Database.database().reference()
    
    //Array for holding our tableview data
    var dataArray:[HighScoreData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //retrieveHighScoreFromDatabase()
        retrieveHighScoreFromDatabase { (resultArray) in
            self.dataArray = resultArray
            
            //Sorting the array
            self.dataArray = self.dataArray.sorted() { $0.score > $1.score}
            
            self.tableView.reloadData()
        }
        
        //Delegate & datasource
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    fileprivate func retrieveHighScoreFromDatabase(completed: @escaping ([HighScoreData]) -> ()){
                
        //Retrieve data from Firebase
        ref.child("users").queryOrdered(byChild: "score").queryLimited(toFirst: 10).observe(.value) { (snapshot) in
            
            var tempArray:[HighScoreData] = []
            
            for child in snapshot.children{
                let childSnap = child as! DataSnapshot
                let data = childSnap.value as! [String:Any]
                
                //Retrieving the data
                let username = data["username"] as! String
                let score = data["score"] as! Int
                
                let txt = HighScoreData.init(username: username, score: score)
                tempArray.append(txt)
                
                DispatchQueue.main.async {
                    completed(tempArray)
                }
            }
        }
    }
    
    @IBAction func closeHighScore(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Tableview properties
extension HighScoreViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "highScore", for: indexPath) as! HighScoreTableViewCell
        
        let score = "\(dataArray[indexPath.row].score)"
        cell.username.text = dataArray[indexPath.row].username
        cell.score.text = score
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
