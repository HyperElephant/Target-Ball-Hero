//
//  SelectLevelScene.swift
//  Ball Hero
//
//  Created by David Taylor on 9/1/15.
//  Copyright (c) 2015 Hyper Elephant. All rights reserved.
//

import UIKit
import GameKit
import SpriteKit

class SelectLevelScene: SKScene {
    let levelOneLabel = SKLabelNodeButton()
    let levelTwoLabel = SKLabelNodeButton()
    let levelThreeLabel = SKLabelNodeButton()
    let levelFourLabel = SKLabelNodeButton()
    let levelOneScore = SKLabelNode()
    let levelTwoScore = SKLabelNode()
    let levelThreeScore = SKLabelNode()
    let levelFourScore = SKLabelNode()
    let levelTwoUnlock = SKLabelNode()
    let levelThreeUnlock = SKLabelNode()
    let levelFourUnlock = SKLabelNode()
    let levelTwoPane = SKSpriteNode()
    let levelThreePane = SKSpriteNode()
    let levelFourPane = SKSpriteNode()
    
    let backLabel = SKLabelNodeButton()
    let toggleLabel = SKLabelNode()
    let titleLabel = SKLabelNode()
    
    var soundToggle = Bool()
    
    var titleFontName = "HelveticaNeue-Bold"
    var titleSize = CGFloat(36)
    var fontName = "HelveticaNeue"
    var labelSize = CGFloat(32)
    var subFontName = "HelveticaNeue-Light"
    var subLabelSize = CGFloat(24)
    var backFontName = "HelveticaNeue-Light"
    var backLabelSize = CGFloat(28)
    var fontScale = CGFloat(1)
    
    override func didMoveToView(view: SKView) {
        self.size = self.view!.frame.size
        authenticateLocalPlayer()
        
        let background = SKSpriteNode(color: UIColor(red: 0.267, green: 0.529, blue: 0.925, alpha: 1), size: CGSizeMake(self.frame.width, self.frame.height))
        
        if NSUserDefaults.standardUserDefaults().objectForKey("soundState") != nil {
            soundToggle = NSUserDefaults.standardUserDefaults().boolForKey("soundState")
        } else {
            soundToggle = true
        }
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            fontScale = 1.5
        }
        labelSize = labelSize * fontScale
        subLabelSize = subLabelSize * fontScale
        backLabelSize = backLabelSize * fontScale
        titleSize = titleSize * fontScale
        
        titleLabel.fontName = titleFontName
        titleLabel.fontSize = titleSize
        titleLabel.fontColor = UIColor.blackColor()
        titleLabel.text = "Select Level"
        titleLabel.position = CGPointMake(self.frame.midX, self.frame.midY * 5 / 3)
        titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        self.addChild(titleLabel)
        
        levelOneLabel.fontName = fontName
        levelOneLabel.fontSize = labelSize
        levelOneLabel.fontColor = UIColor.blackColor()
        levelOneLabel.text = "Level One"
        levelOneLabel.position = CGPointMake(self.frame.width / 4, self.frame.height * 2 / 3)
        levelOneLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        levelOneLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        self.addChild(levelOneLabel)
        
        levelOneScore.fontName = subFontName
        levelOneScore.fontSize = subLabelSize
        levelOneScore.fontColor = UIColor.blackColor()
        levelOneScore.text = "High Score: \(Int(getHighScore(1)))"
        levelOneScore.position = CGPointMake(self.frame.width / 4, self.frame.height * 2 / 3)
        levelOneScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        levelOneScore.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        self.addChild(levelOneScore)
        
        
        levelTwoLabel.fontName = fontName
        levelTwoLabel.fontSize = labelSize
        levelTwoLabel.fontColor = UIColor.blackColor()
        levelTwoLabel.text = "Level Two"
        levelTwoLabel.position = CGPointMake(self.frame.width * 3 / 4, self.frame.height * 2 / 3)
        levelTwoLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        levelTwoLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        self.addChild(levelTwoLabel)
        
        levelTwoScore.fontName = subFontName
        levelTwoScore.fontSize = subLabelSize
        levelTwoScore.fontColor = UIColor.blackColor()
        levelTwoScore.text = "High Score: \(Int(getHighScore(2)))"
        levelTwoScore.position = CGPointMake(self.frame.width * 3 / 4, self.frame.height * 2 / 3)
        levelTwoScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        levelTwoScore.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        self.addChild(levelTwoScore)
        
        levelTwoUnlock.fontName = fontName
        levelTwoUnlock.fontSize = subLabelSize
        levelTwoUnlock.fontColor = UIColor.whiteColor()
        levelTwoUnlock.text = "Score 25 to Unlock"
        levelTwoUnlock.position = CGPointMake(self.frame.width * 3 / 4, self.frame.height * 2 / 3)
        levelTwoUnlock.zPosition = 81
//        levelTwoUnlock.zRotation = CGFloat(M_PI_4)
        levelTwoUnlock.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        levelTwoUnlock.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        self.addChild(levelTwoUnlock)
        
        levelTwoPane.size = CGSizeMake(self.frame.width / 3, self.frame.height / 5)
        levelTwoPane.color = UIColor.blackColor()
        levelTwoPane.position = CGPointMake(self.frame.width * 3 / 4, self.frame.height * 2 / 3)
        levelTwoPane.alpha = 0.4
        levelTwoPane.zPosition = 80
        self.addChild(levelTwoPane)
        
        
        levelThreeLabel.fontName = fontName
        levelThreeLabel.fontSize = labelSize
        levelThreeLabel.fontColor = UIColor.blackColor()
        levelThreeLabel.text = "Level Three"
        levelThreeLabel.position = CGPointMake(self.frame.width / 4, self.frame.height / 3)
        levelThreeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        levelThreeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        self.addChild(levelThreeLabel)
        
        levelThreeScore.fontName = subFontName
        levelThreeScore.fontSize = subLabelSize
        levelThreeScore.fontColor = UIColor.blackColor()
        levelThreeScore.text = "High Score: \(Int(getHighScore(3)))"
        levelThreeScore.position = CGPointMake(self.frame.width / 4, self.frame.height / 3)
        levelThreeScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        levelThreeScore.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        self.addChild(levelThreeScore)
        
        levelThreeUnlock.fontName = fontName
        levelThreeUnlock.fontSize = subLabelSize
        levelThreeUnlock.fontColor = UIColor.whiteColor()
        levelThreeUnlock.text = "Score 50 to Unlock"
        levelThreeUnlock.position = CGPointMake(self.frame.width / 4, self.frame.height / 3)
//        levelThreeUnlock.zRotation = CGFloat(M_PI_4)
        levelThreeUnlock.zPosition = 81
        levelThreeUnlock.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        levelThreeUnlock.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        self.addChild(levelThreeUnlock)
        
        levelThreePane.size = CGSizeMake(self.frame.width / 3, self.frame.height / 5)
        levelThreePane.color = UIColor.blackColor()
        levelThreePane.position = CGPointMake(self.frame.width / 4, self.frame.height / 3)
        levelThreePane.alpha = 0.4
        levelThreePane.zPosition = 80
        self.addChild(levelThreePane)
        
        levelFourLabel.fontName = fontName
        levelFourLabel.fontSize = labelSize
        levelFourLabel.fontColor = UIColor.blackColor()
        levelFourLabel.text = "Level Four"
        levelFourLabel.position = CGPointMake(self.frame.width * 3 / 4, self.frame.height / 3)
        levelFourLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        levelFourLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        self.addChild(levelFourLabel)
        
        levelFourScore.fontName = subFontName
        levelFourScore.fontSize = subLabelSize
        levelFourScore.fontColor = UIColor.blackColor()
        levelFourScore.text = "High Score: \(Int(getHighScore(4)))"
        levelFourScore.position = CGPointMake(self.frame.width * 3 / 4, self.frame.height / 3)
        levelFourScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        levelFourScore.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        self.addChild(levelFourScore)
        
        levelFourUnlock.fontName = fontName
        levelFourUnlock.fontSize = subLabelSize
        levelFourUnlock.fontColor = UIColor.whiteColor()
        levelFourUnlock.text = "Score 75 to Unlock"
        levelFourUnlock.position = CGPointMake(self.frame.width * 3 / 4, self.frame.height / 3)
//        levelFourUnlock.zRotation = CGFloat(M_PI_4)
        levelFourUnlock.zPosition = 81
        levelFourUnlock.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        levelFourUnlock.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        self.addChild(levelFourUnlock)
        
        levelFourPane.size = CGSizeMake(self.frame.width / 3, self.frame.height / 5)
        levelFourPane.color = UIColor.blackColor()
        levelFourPane.position = CGPointMake(self.frame.width * 3 / 4, self.frame.height / 3)
        levelFourPane.alpha = 0.4
        levelFourPane.zPosition = 80
        self.addChild(levelFourPane)
        
        backLabel.fontName = backFontName
        backLabel.fontSize = backLabelSize
        backLabel.fontColor = UIColor.blackColor()
        backLabel.text = "Tap to Go to the Menu"
        backLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)  * 1 / 3)
        self.addChild(backLabel)
        
        background.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(background)
        
        unlock()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        self.size = self.view!.frame.size
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if levelOneLabel.containsPoint(location) {
                levelOneLabel.select()
            } else if levelTwoLabel.containsPoint(location) {
                levelTwoLabel.select()
            } else if levelThreeLabel.containsPoint(location) {
                levelThreeLabel.select()
            }else if levelFourLabel.containsPoint(location) {
                levelFourLabel.select()
            } else {
                backLabel.select()
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if levelOneLabel.containsPoint(location) && levelOneLabel.selected == true {
                goToLevelOne()
            } else if levelTwoLabel.containsPoint(location) && levelTwoLabel.selected == true {
                goToLevelTwo()
            } else if levelThreeLabel.containsPoint(location) && levelThreeLabel.selected == true {
                goToLevelThree()
            }else if levelFourLabel.containsPoint(location) && levelFourLabel.selected == true {
                goToLevelFour()
            } else {
                if backLabel.selected == true {
                    goBack()
                }
                deselectAll()
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func goBack() {
        let transition = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 1.0)
        let scene = GameOverScene(size: self.size)
        
        scene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene?.view?.presentScene(scene, transition: transition)
    }
    
    func goToLevelOne() {
        let transition = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 1.0)
        let scene = GameScene(size: self.size)
        
        scene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene?.view?.presentScene(scene, transition: transition)
    }
    
    func goToLevelTwo() {
        let transition = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 1.0)
        let scene = GameSceneTwo(size: self.size)
        
        scene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene?.view?.presentScene(scene, transition: transition)
    }
    
    func goToLevelThree() {
        let transition = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 1.0)
        let scene = GameSceneThree(size: self.size)
        
        scene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene?.view?.presentScene(scene, transition: transition)
    }
    
    func goToLevelFour() {
        let transition = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 1.0)
        let scene = GameSceneFour(size: self.size)
        
        scene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene?.view?.presentScene(scene, transition: transition)
    }
    
    func getHighScore(level:Int) -> Double {
        var highScore = Double()
        var scoreString = String()
        switch level{
        case 1:
            scoreString = "highScore"
        case 2:
            scoreString = "highScoreLevelTwo"
        case 3:
            scoreString = "highScoreLevelThree"
        case 4:
            scoreString = "highScoreLevelFour"
        default:
            scoreString = "highScore"
        }
        
        
        if NSUserDefaults.standardUserDefaults().objectForKey(scoreString) != nil {
            highScore = NSUserDefaults.standardUserDefaults().objectForKey(scoreString) as!  Double
        } else {
            highScore = 0.0
        }
        return highScore
    }
    
    func getTotalHighScore() -> Double {
        var total = 0.0
        for x in 1...4 {
            if total < getHighScore(x) {
                total = getHighScore(x)
            }
        }
        return total
    }
    
    func unlock() {
        if getTotalHighScore() > 25 {
            levelTwoUnlock.removeFromParent()
            levelTwoPane.removeFromParent()
        }
        
        if getTotalHighScore() > 50 {
            levelThreeUnlock.removeFromParent()
            levelThreePane.removeFromParent()
        }
        
        if getTotalHighScore() > 75 {
            levelFourUnlock.removeFromParent()
            levelFourPane.removeFromParent()
        }

    }
    
    func authenticateLocalPlayer(){
        
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) {
                self.view?.window?.rootViewController?.presentViewController(viewController!, animated: true, completion: nil)
            } else {
                                //print(error)
            }
        }
    }
    
    func deselectAll() {
        
        backLabel.deselect()
        
        levelOneLabel.deselect()
        levelTwoLabel.deselect()
        levelThreeLabel.deselect()
        levelFourLabel.deselect()
    }
    

}
