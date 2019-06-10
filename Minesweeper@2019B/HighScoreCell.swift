//
//  HighScoreCell.swift
//  Minesweeper@2019B
//
//  Created by Athar Mass on 06/06/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit

class HighScoreCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var difficulty: UILabel!
    @IBOutlet weak var lat: UILabel!
    @IBOutlet weak var lng: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
