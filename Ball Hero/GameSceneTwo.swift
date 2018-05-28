//
//  GameSceneTwo.swift
//  Ball Hero
//
//  Created by David Taylor on 9/1/15.
//  Copyright (c) 2015 Hyper Elephant. All rights reserved.
//

import SpriteKit
import GameKit
import Photos

class GameSceneTwo: GameBase  {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        scoreKey = "highScoreLevelTwo"
        UserDefaults.standard.set(2, forKey: "currentLevel")
        
    }
    
    override func makeTarget() {
        self.size = self.view!.frame.size
        
        var targetSide = self.frame.size.width / 8
        let targetSize = 1 / ((0.05 * score * score) + 1.0)
        let targetFadeIn = SKAction.fadeIn(withDuration: 1)
        targetSide = targetSide * CGFloat(targetSize)
        if targetSide < 1 {
            targetSide = 1.0
        }
        let target = SKShapeNode(circleOfRadius: targetSide)
        target.fillColor = UIColor(red: 0.937, green: 0.208, blue: 0.239, alpha: 1)
        target.strokeColor = UIColor(red: 0.937, green: 0.208, blue: 0.239, alpha: 1)
        
        let endValueX = self.frame.size.width - targetSide * 2
        var placementX = CGFloat(arc4random_uniform(UInt32(endValueX)))
        
        let vy = self.size.height / 2
        let gravity = self.physicsWorld.gravity.dy
        let time = self.size.height / 2 / gravity
        let posY = vy - 0.5 * gravity * time * time
        let maxY = posY / 130 + self.size.height / 2
        
        var placementY = CGFloat(arc4random_uniform(UInt32(maxY)))

        placementY = placementY + targetSide
        placementX = placementX + targetSide
        
        target.position = CGPoint(x: placementX, y: placementY )
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
