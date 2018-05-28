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
    
    let debug = false
    
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
    
    override func didMove(to view: SKView) {
        self.size = self.view!.frame.size
        Helpers.authenticateLocalPlayer(self.view)
        
        let background = SKSpriteNode(color: UIColor(red: 0.267, green: 0.529, blue: 0.925, alpha: 1), size: CGSize(width: self.frame.width, height: self.frame.height))
        
        if UserDefaults.standard.object(forKey: "soundState") != nil {
            soundToggle = UserDefaults.standard.bool(forKey: "soundState")
        } else {
            soundToggle = true
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontScale = 1.5
        }
        labelSize = labelSize * fontScale
        subLabelSize = subLabelSize * fontScale
        backLabelSize = backLabelSize * fontScale
        titleSize = titleSize * fontScale
        
        titleLabel.fontName = titleFontName
        titleLabel.fontSize = titleSize
        titleLabel.fontColor = UIColor.black
        titleLabel.text = "Select Level"
        titleLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 5 / 3)
        titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
        self.addChild(titleLabel)
        
        levelOneLabel.fontName = fontName
        levelOneLabel.fontSize = labelSize
        levelOneLabel.fontColor = UIColor.black
        levelOneLabel.text = "Level One"
        levelOneLabel.position = CGPoint(x: self.frame.width / 4, y: self.frame.height * 2 / 3)
        levelOneLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        levelOneLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
        self.addChild(levelOneLabel)
        
        levelOneScore.fontName = subFontName
        levelOneScore.fontSize = subLabelSize
        levelOneScore.fontColor = UIColor.black
        levelOneScore.text = "High Score: \(Int(getHighScore(1)))"
        levelOneScore.position = CGPoint(x: self.frame.width / 4, y: self.frame.height * 2 / 3)
        levelOneScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        levelOneScore.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        self.addChild(levelOneScore)
        
        
        levelTwoLabel.fontName = fontName
        levelTwoLabel.fontSize = labelSize
        levelTwoLabel.fontColor = UIColor.black
        levelTwoLabel.text = "Level Two"
        levelTwoLabel.position = CGPoint(x: self.frame.width * 3 / 4, y: self.frame.height * 2 / 3)
        levelTwoLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        levelTwoLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
        self.addChild(levelTwoLabel)
        
        levelTwoScore.fontName = subFontName
        levelTwoScore.fontSize = subLabelSize
        levelTwoScore.fontColor = UIColor.black
        levelTwoScore.text = "High Score: \(Int(getHighScore(2)))"
        levelTwoScore.position = CGPoint(x: self.frame.width * 3 / 4, y: self.frame.height * 2 / 3)
        levelTwoScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        levelTwoScore.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        self.addChild(levelTwoScore)
        
        levelTwoUnlock.fontName = fontName
        levelTwoUnlock.fontSize = subLabelSize
        levelTwoUnlock.fontColor = UIColor.white
        levelTwoUnlock.text = "Score 25 to Unlock"
        levelTwoUnlock.position = CGPoint(x: self.frame.width * 3 / 4, y: self.frame.height * 2 / 3)
        levelTwoUnlock.zPosition = 81
//        levelTwoUnlock.zRotation = CGFloat(M_PI_4)
        levelTwoUnlock.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        levelTwoUnlock.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
        self.addChild(levelTwoUnlock)
        
        levelTwoPane.size = CGSize(width: self.frame.width / 3, height: self.frame.height / 5)
        levelTwoPane.color = UIColor.black
        levelTwoPane.position = CGPoint(x: self.frame.width * 3 / 4, y: self.frame.height * 2 / 3)
        levelTwoPane.alpha = 0.4
        levelTwoPane.zPosition = 80
        self.addChild(levelTwoPane)
        
        
        levelThreeLabel.fontName = fontName
        levelThreeLabel.fontSize = labelSize
        levelThreeLabel.fontColor = UIColor.black
        levelThreeLabel.text = "Level Three"
        levelThreeLabel.position = CGPoint(x: self.frame.width / 4, y: self.frame.height / 3)
        levelThreeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        levelThreeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
        self.addChild(levelThreeLabel)
        
        levelThreeScore.fontName = subFontName
        levelThreeScore.fontSize = subLabelSize
        levelThreeScore.fontColor = UIColor.black
        levelThreeScore.text = "High Score: \(Int(getHighScore(3)))"
        levelThreeScore.position = CGPoint(x: self.frame.width / 4, y: self.frame.height / 3)
        levelThreeScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        levelThreeScore.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        self.addChild(levelThreeScore)
        
        levelThreeUnlock.fontName = fontName
        levelThreeUnlock.fontSize = subLabelSize
        levelThreeUnlock.fontColor = UIColor.white
        levelThreeUnlock.text = "Score 50 to Unlock"
        levelThreeUnlock.position = CGPoint(x: self.frame.width / 4, y: self.frame.height / 3)
//        levelThreeUnlock.zRotation = CGFloat(M_PI_4)
        levelThreeUnlock.zPosition = 81
        levelThreeUnlock.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        levelThreeUnlock.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
        self.addChild(levelThreeUnlock)
        
        levelThreePane.size = CGSize(width: self.frame.width / 3, height: self.frame.height / 5)
        levelThreePane.color = UIColor.black
        levelThreePane.position = CGPoint(x: self.frame.width / 4, y: self.frame.height / 3)
        levelThreePane.alpha = 0.4
        levelThreePane.zPosition = 80
        self.addChild(levelThreePane)
        
        levelFourLabel.fontName = fontName
        levelFourLabel.fontSize = labelSize
        levelFourLabel.fontColor = UIColor.black
        levelFourLabel.text = "Level Four"
        levelFourLabel.position = CGPoint(x: self.frame.width * 3 / 4, y: self.frame.height / 3)
        levelFourLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        levelFourLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
        self.addChild(levelFourLabel)
        
        levelFourScore.fontName = subFontName
        levelFourScore.fontSize = subLabelSize
        levelFourScore.fontColor = UIColor.black
        levelFourScore.text = "High Score: \(Int(getHighScore(4)))"
        levelFourScore.position = CGPoint(x: self.frame.width * 3 / 4, y: self.frame.height / 3)
        levelFourScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        levelFourScore.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        self.addChild(levelFourScore)
        
        levelFourUnlock.fontName = fontName
        levelFourUnlock.fontSize = subLabelSize
        levelFourUnlock.fontColor = UIColor.white
        levelFourUnlock.text = "Score 75 to Unlock"
        levelFourUnlock.position = CGPoint(x: self.frame.width * 3 / 4, y: self.frame.height / 3)
//        levelFourUnlock.zRotation = CGFloat(M_PI_4)
        levelFourUnlock.zPosition = 81
        levelFourUnlock.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        levelFourUnlock.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
        self.addChild(levelFourUnlock)
        
        levelFourPane.size = CGSize(width: self.frame.width / 3, height: self.frame.height / 5)
        levelFourPane.color = UIColor.black
        levelFourPane.position = CGPoint(x: self.frame.width * 3 / 4, y: self.frame.height / 3)
        levelFourPane.alpha = 0.4
        levelFourPane.zPosition = 80
        self.addChild(levelFourPane)
        
        backLabel.fontName = backFontName
        backLabel.fontSize = backLabelSize
        backLabel.fontColor = UIColor.black
        backLabel.text = "Tap to Go to the Menu"
        backLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY  * 1 / 3)
        self.addChild(backLabel)
        
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(background)
        
        unlock()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        self.size = self.view!.frame.size
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if levelOneLabel.contains(location) {
                levelOneLabel.select()
            } else if levelTwoLabel.contains(location) {
                levelTwoLabel.select()
            } else if levelThreeLabel.contains(location) {
                levelThreeLabel.select()
            }else if levelFourLabel.contains(location) {
                levelFourLabel.select()
            } else {
                backLabel.select()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if levelOneLabel.contains(location) && levelOneLabel.selected == true {
                goToLevelOne()
            } else if levelTwoLabel.contains(location) && levelTwoLabel.selected == true {
                goToLevelTwo()
            } else if levelThreeLabel.contains(location) && levelThreeLabel.selected == true {
                goToLevelThree()
            }else if levelFourLabel.contains(location) && levelFourLabel.selected == true {
                goToLevelFour()
            } else {
                if backLabel.selected == true {
                    goBack()
                }
                deselectAll()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func goBack() {
        let transition = SKTransition.push(with: SKTransitionDirection.left, duration: 1.0)
        let scene = GameOverScene(size: self.size)
        
        scene.scaleMode = SKSceneScaleMode.aspectFill
        self.scene?.view?.presentScene(scene, transition: transition)
    }
    
    func goToLevelOne() {
        let transition = SKTransition.push(with: SKTransitionDirection.left, duration: 1.0)
        let scene = GameScene(size: self.size)
        
        scene.scaleMode = SKSceneScaleMode.aspectFill
        self.scene?.view?.presentScene(scene, transition: transition)
    }
    
    func goToLevelTwo() {
        let transition = SKTransition.push(with: SKTransitionDirection.left, duration: 1.0)
        let scene = GameSceneTwo(size: self.size)
        
        scene.scaleMode = SKSceneScaleMode.aspectFill
        self.scene?.view?.presentScene(scene, transition: transition)
    }
    
    func goToLevelThree() {
        let transition = SKTransition.push(with: SKTransitionDirection.left, duration: 1.0)
        let scene = GameSceneThree(size: self.size)
        
        scene.scaleMode = SKSceneScaleMode.aspectFill
        self.scene?.view?.presentScene(scene, transition: transition)
    }
    
    func goToLevelFour() {
        let transition = SKTransition.push(with: SKTransitionDirection.left, duration: 1.0)
        let scene = GameSceneFour(size: self.size)
        
        scene.scaleMode = SKSceneScaleMode.aspectFill
        self.scene?.view?.presentScene(scene, transition: transition)
    }
    
    func getHighScore(_ level:Int) -> Double {
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
        
        
        if UserDefaults.standard.object(forKey: scoreString) != nil {
            highScore = UserDefaults.standard.object(forKey: scoreString) as!  Double
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
        if getTotalHighScore() > 25 || debug {
            levelTwoUnlock.removeFromParent()
            levelTwoPane.removeFromParent()
        }
        
        if getTotalHighScore() > 50 || debug {
            levelThreeUnlock.removeFromParent()
            levelThreePane.removeFromParent()
        }
        
        if getTotalHighScore() > 75 || debug {
            levelFourUnlock.removeFromParent()
            levelFourPane.removeFromParent()
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
