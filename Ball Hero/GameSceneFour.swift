//
//  GameSceneFour.swift
//  Ball Hero
//
//  Created by David Taylor on 9/3/15.
//  Copyright (c) 2015 Hyper Elephant. All rights reserved.
//

import SpriteKit
import GameKit
import Photos

class GameSceneFour: TimedGameBase  {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        scoreKey = "highScoreLevelFour"
        UserDefaults.standard.set(4, forKey: "currentLevel")
    }
    
    override func makeTarget() {
        self.size = self.view!.frame.size
        
        let targetSide = self.frame.size.width / 16
        let target = SKShapeNode(circleOfRadius: targetSide)
        target.fillColor = UIColor(red: 0.937, green: 0.208, blue: 0.239, alpha: 1)
        target.strokeColor = UIColor(red: 0.937, green: 0.208, blue: 0.239, alpha: 1)
        let targetFadeIn = SKAction.fadeIn(withDuration: 1)
        
        let endValueX = UInt32(self.frame.size.width - targetSide * 2)
        var placementX = arc4random_uniform(endValueX)
        placementX = placementX + UInt32(targetSide)
        
        let endValueY = UInt32(self.frame.size.height - targetSide * 2)
        var placementY = arc4random_uniform(endValueY)
        placementY = placementY + UInt32(targetSide)
        
        target.position = CGPoint(x: CGFloat(placementX), y: CGFloat(placementY) )
        target.zPosition = 10
        
        target.physicsBody = SKPhysicsBody(circleOfRadius: targetSide)
        target.physicsBody?.isDynamic = false
        target.physicsBody?.categoryBitMask = targetGroup
        
        target.name = targetGroupName
        
        target.alpha = 0
        
        targetObjects.addChild(target)
        target.run(targetFadeIn)
    }
}
