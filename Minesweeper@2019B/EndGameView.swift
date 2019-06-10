//
//  EndGameView.swift
//  Minesweeper@2019B
//
//  Created by Athar Mass on 15/04/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit

class EndGameView: UIViewController {
    
    @IBOutlet weak var statusEnd: UIImageView!
    @IBOutlet weak var statusLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    public func setupView(/*gameStatus: String*/) {
        
        if GamePage.GameVariables.gameStatus == "GameOver"{
            statusEnd.image = UIImage(named: "gameOver");
            statusLogo.image = UIImage(named: "cry");
        }else{
            statusEnd.image = UIImage(named: "youWon");
            statusLogo.image = UIImage(named: "s_success");
       }
    }

    @IBAction func backToHomePage(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Main") as! ViewController
        self.present(vc, animated: true, completion: nil)
        
    }
}
