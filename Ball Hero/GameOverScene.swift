//
//  GameOverScene.swift
//  Ball Hero
//
//  Created by David Taylor on 3/25/15.
//  Copyright (c) 2015 Hyper Elephant. All rights reserved.
//

import SpriteKit
import UIKit
import GameKit


class GameOverScene: SKScene, GKGameCenterControllerDelegate {
   
    let titleLabel = SKLabelNode()
    let scoreLabel = SKLabelNode()
    let backLabel = SKLabelNodeButton()
    let storeLabel = SKLabelNodeButton()
    let leaderboardLabel = SKLabelNodeButton()
    let toggleLabel = SKLabelNode()
    let settingLabel = SKLabelNodeButton()
    let levelLabel = SKLabelNodeButton()
    
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
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            fontScale = 1.5
        }
        
        labelSize = labelSize * fontScale
        backLabelSize = backLabelSize * fontScale
        titleSize = titleSize * fontScale
        subLabelSize = subLabelSize * fontScale
        
        let background = SKSpriteNode(color: UIColor(red: 0.965, green: 0.882, blue: 0.094, alpha: 1), size: CGSizeMake(self.frame.width, self.frame.height))
        
        let highScore = getOverallHighScore()
        let lastScore = getLastScore()
        
        titleLabel.fontName = titleFontName
        titleLabel.fontSize = titleSize
        titleLabel.fontColor = UIColor.blackColor()
        titleLabel.text = "Menu"
        titleLabel.position = CGPointMake(self.frame.midX, self.frame.midY * 5 / 3)
        titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        self.addChild(titleLabel)
        
        settingLabel.fontName = fontName
        settingLabel.fontSize = labelSize
        settingLabel.fontColor = UIColor.blackColor()
        settingLabel.text = "Settings"
        settingLabel.position = CGPointMake(self.frame.width / 4, self.frame.height * 2 / 3)
        settingLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        //        settingLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        self.addChild(settingLabel)
        
        storeLabel.fontName = fontName
        storeLabel.fontSize = labelSize
        storeLabel.fontColor = UIColor.blackColor()
        storeLabel.text = "Store"
        storeLabel.position = CGPointMake(self.frame.width * 3 / 4, self.frame.height * 2 / 3)
        storeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
//        storeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        self.addChild(storeLabel)
        
        leaderboardLabel.fontName = fontName
        leaderboardLabel.fontSize = labelSize
        leaderboardLabel.fontColor = UIColor.blackColor()
        leaderboardLabel.text = "Leaderboard"
        leaderboardLabel.position = CGPointMake(self.frame.width / 4, self.frame.height * 2 / 5)
        leaderboardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
//        leaderboardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        self.addChild(leaderboardLabel)
        
        levelLabel.fontName = fontName
        levelLabel.fontSize = labelSize
        levelLabel.fontColor = UIColor.blackColor()
        levelLabel.text = "Select Level"
        levelLabel.position = CGPointMake(self.frame.width * 3 / 4, self.frame.height * 2 / 5)
        levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
//        levelLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        self.addChild(levelLabel)
        
        scoreLabel.fontName = subFontName
        scoreLabel.fontSize = subLabelSize
        scoreLabel.fontColor = UIColor.blackColor()
        scoreLabel.text = "Best: \(Int(highScore)), Last: \(Int(lastScore))"
        scoreLabel.position = CGPointMake(self.frame.width / 4, self.frame.height / 3)
        self.addChild(scoreLabel)
        
        backLabel.fontName = backFontName
        backLabel.fontSize = backLabelSize
        backLabel.fontColor = UIColor.blackColor()
        backLabel.text = "Tap to Start Again"
        backLabel.position = CGPointMake(self.frame.width / 2, CGRectGetMidY(self.frame)  * 1 / 3)
        self.addChild(backLabel)

        background.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(background)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if leaderboardLabel.containsPoint(location) {
                leaderboardLabel.select()
            } else if storeLabel.containsPoint(location) {
                storeLabel.select()
            } else if settingLabel.containsPoint(location) {
                settingLabel.select()
            } else if backLabel.containsPoint(location){
                backLabel.select()
            } else if levelLabel.containsPoint(location){
                levelLabel.select()
            } else {
                backLabel.select()
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if leaderboardLabel.containsPoint(location) && leaderboardLabel.selected == true {
                leaderboardLabel.deselect()
                showLeader()
            } else if storeLabel.containsPoint(location) && storeLabel.selected == true {
                storeLabel.deselect()
                showStore()
            } else if settingLabel.containsPoint(location) && settingLabel.selected == true {
                settingLabel.deselect()
                showSettings()
            } else if backLabel.containsPoint(location) && backLabel.selected == true {
                backLabel.deselect()
                backToGame()
            } else if levelLabel.containsPoint(location) && levelLabel.selected == true {
                levelLabel.deselect()
                showLevels()
            } else {
                if backLabel.selected == true {
                    backToGame()
                }
                deselectAll()
            }
        }
    }
    
    func getLastScore() -> Double {
        var lastScore = Double()
        
        if NSUserDefaults.standardUserDefaults().objectForKey("lastScore") != nil {
            lastScore = NSUserDefaults.standardUserDefaults().objectForKey("lastScore") as!  Double
        } else {
            lastScore = 0.0
        }
        return lastScore
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
    
    func showLeader() {
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        gc.leaderboardIdentifier = nil
        vc?.presentViewController(gc, animated: true, completion: { () -> Void in
        })
    }
    
    func showStore() {
        let vc = self.view?.window?.rootViewController
        let sc = StoreViewController()
        vc?.presentViewController(sc, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showSettings() {
        let transition = SKTransition.pushWithDirection(SKTransitionDirection.Up, duration: 1.0)
        let scene = SettingScene(size: self.size)
        
        scene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene?.view?.presentScene(scene, transition: transition)
    }
    
    func showLevels() {
        let transition = SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 1.0)
        let scene = SelectLevelScene(size: self.size)
        
        scene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene?.view?.presentScene(scene, transition: transition)
    }
    
    func getOverallHighScore() -> Double {
        var total = 0.0
        for x in 1...4 {
            if total < getHighScore(x) {
                total = getHighScore(x)
            }
        }
        return total
    }
    
    func backToGame() {
        var currentLevel = 1
        
        if NSUserDefaults.standardUserDefaults().objectForKey("currentLevel") != nil {
            currentLevel = NSUserDefaults.standardUserDefaults().objectForKey("currentLevel") as! Int
        }
        let transition = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 1.0)
        var scene : SKScene
        
        switch currentLevel {
        case 1:
             scene = GameScene(size: self.size)
        case 2:
             scene = GameSceneTwo(size: self.size)
        case 3:
             scene = GameSceneThree(size: self.size)
        case 4:
             scene = GameSceneFour(size: self.size)
        default:
             scene = GameScene(size: self.size)
        }

        scene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene?.view?.presentScene(scene, transition: transition)
    }
    
    func deselectAll() {
        leaderboardLabel.deselect()
        storeLabel.deselect()
        backLabel.deselect()
        settingLabel.deselect()
        levelLabel.deselect()
    }
    
}
