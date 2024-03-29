//
//  CollectionViewCell.swift
//  Minesweeper@2019B
//
//  Created by Athar Mass on 03/04/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    //ImageView
    @IBOutlet weak var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
       /* self.isUserInteractionEnabled = true
        let long = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        long.delaysTouchesBegan = true
        self.addGestureRecognizer(long)*/
        
    

    }
    
    func setupCell(size_changed: Int){
        //Resize Image View
        let new_size = CGSize(width: size_changed, height: size_changed)
        self.imageView.frame.size = new_size
        self.imageView.image = UIImage(named: "button")
        self.imageView.contentMode = .scaleAspectFill
        if( self.imageView.image != nil){
            self.imageView.image = UIImage(named: "button")
            self.imageView.contentMode = .scaleAspectFill
        }
    }
    
}
