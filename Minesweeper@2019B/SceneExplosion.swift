//
//  SceneExplosion.swift
//  Minesweeper@2019B
//
//  Created by Athar Mass on 06/06/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit
import SpriteKit

class SceneExplosion: SKScene {
    
    var explosionFrames:[SKTexture]?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = UIColor.white
        var frames:[SKTexture] = []
        
        let gameOverAtlas = SKTextureAtlas(named: "gameOver")
        
        for index in 0 ... 13 {
            let textureName = "gameOver_\(index)"
            let texture = gameOverAtlas.textureNamed(textureName)
            frames.append(texture)
        }
        
        self.explosionFrames = frames
        
    }
    
    
    func playAnimation() {
        let texture = self.explosionFrames![0]
        
        let animation = SKSpriteNode(texture: texture);
        
        animation.size = CGSize(width: self.frame.size.width*10, height: self.frame.size.width*10);
        animation.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2);
        
        self.addChild(animation);
        animation.run(SKAction.repeatForever(SKAction.animate(with: explosionFrames!, timePerFrame: 28/1000, resize: true, restore: true)))
//        repeat(SKAction.animate(with: explosionFrames!, timePerFrame: 14/1000, resize: true, restore: true), count: 6))
//        animation.run(SKAction.repeat(SKAction.animate(with: frame?, timePerFrame: 23/1000, resize: false, restore: true), count: 3));
        
        
        
    }
    
    
    
    
    

}
