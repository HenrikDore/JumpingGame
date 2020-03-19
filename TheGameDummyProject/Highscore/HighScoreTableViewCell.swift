//
//  HighScoreTableViewCell.swift
//  TheGameDummyProject
//
//  Created by Henrik Doré on 2020-03-19.
//  Copyright © 2020 Henrik Doré. All rights reserved.
//

import UIKit

class HighScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var score: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(data: HighScoreData){
        username.text = data.username
        //kaN DU GÖra backslash? haha
        score.text = "\(data.score)"
    }

}
