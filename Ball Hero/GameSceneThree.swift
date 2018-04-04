//
//  GameSceneThree.swift
//  Ball Hero
//
//  Created by David Taylor on 9/3/15.
//  Copyright (c) 2015 Hyper Elephant. All rights reserved.
//

import SpriteKit
import GameKit

class GameSceneThree: TimedGameBase  {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        scoreKey = "highScoreLevelThree"
        UserDefaults.standard.set(3, forKey: "currentLevel")
        
    }
    
    override func makeTarget() {
        self.size = self.view!.frame.size
        
        let targetWidth = self.frame.size.width / 10
        let targetHeight = self.frame.size.height / 24
        let target = SKSpriteNode(color: UIColor(red: 0.937, green: 0.208, blue: 0.239, alpha: 1), size: CGSize(width: targetWidth, height: targetHeight))
        let targetFadeIn = SKAction.fadeIn(withDuration: 1)
        
        let endValue = UInt32(self.frame.size.width - target.size.width)
        var placement = arc4random_uniform(endValue)
        placement = placement + UInt32(target.size.width / 2)
        
        target.position = CGPoint(x: CGFloat(placement), y: self.frame.midY / 2 )
        target.zPosition = 10
        
        target.physicsBody = SKPhysicsBody(rectangleOf: target.size)
        target.physicsBody?.isDynamic = false
        target.physicsBody?.categoryBitMask = targetGroup
        
        target.name = targetGroupName
        
        target.alpha = 0
        
        targetObjects.addChild(target)
        target.run(targetFadeIn)
    }
    
}

