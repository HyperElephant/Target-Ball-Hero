//
//  SettingScene.swift
//  Ball Hero
//
//  Created by David Taylor on 7/28/15.
//  Copyright (c) 2015 Hyper Elephant. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import Photos

class SettingScene: SKScene, UINavigationControllerDelegate {
    
    let backgroundLabel = SKLabelNodeButton()
    let soundsLabel = SKLabelNodeButton()
    let backLabel = SKLabelNodeButton()
    let toggleLabel = SKLabelNodeButton()
    let titleLabel = SKLabelNodeButton()
    let tutorialLabel = SKLabelNodeButton()
    let startupLabel = SKLabelNodeButton()
    
    var soundToggle = Bool()
    var startupToggle = Bool()
    
    var titleFontName = "HelveticaNeue-Bold"
    var titleSize = CGFloat(36)
    var fontName = "HelveticaNeue"
    var labelSize = CGFloat(28)
    var backFontName = "HelveticaNeue-Light"
    var backLabelSize = CGFloat(28)
    var fontScale = CGFloat(1)
    
    override func didMoveToView(view: SKView) {
        self.size = self.view!.frame.size
        
        let background = SKSpriteNode(color: UIColor(red: 0.404, green: 0.945, blue: 0.49, alpha: 1), size: CGSizeMake(self.frame.width, self.frame.height))
        
        if NSUserDefaults.standardUserDefaults().objectForKey("soundState") != nil {
            soundToggle = NSUserDefaults.standardUserDefaults().boolForKey("soundState")
        } else {
            soundToggle = true
        }
        
        if NSUserDefaults.standardUserDefaults().objectForKey("startupState") != nil {
            startupToggle = NSUserDefaults.standardUserDefaults().boolForKey("startupState")
        } else {
            startupToggle = false
        }
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            fontScale = 1.5
        }
        labelSize = labelSize * fontScale
        backLabelSize = backLabelSize * fontScale
        titleSize = titleSize * fontScale
        
        titleLabel.fontName = titleFontName
        titleLabel.fontSize = titleSize
        titleLabel.fontColor = UIColor.blackColor()
        titleLabel.text = "Settings"
        titleLabel.position = CGPointMake(self.frame.midX, self.frame.midY * 5 / 3)
        titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        self.addChild(titleLabel)
        
        backgroundLabel.fontName = fontName
        backgroundLabel.fontSize = labelSize
        backgroundLabel.fontColor = UIColor.blackColor()
        backgroundLabel.text = "Set Background"
        backgroundLabel.position = CGPointMake(20, self.frame.midY * 4 / 3)
        backgroundLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.addChild(backgroundLabel)
        
        soundsLabel.fontName = fontName
        soundsLabel.fontSize = labelSize
        soundsLabel.fontColor = UIColor.blackColor()
        if soundToggle == true {
            soundsLabel.text = "Turn Sounds Off"
        } else {
            soundsLabel.text = "Turn Sounds On"
        }
        soundsLabel.position = CGPointMake(20, self.frame.midY)
        soundsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.addChild(soundsLabel)
        
        tutorialLabel.fontName = fontName
        tutorialLabel.fontSize = labelSize
        tutorialLabel.fontColor = UIColor.blackColor()
        tutorialLabel.text = "Replay Tutorial"
        tutorialLabel.position = CGPointMake(20, self.frame.midY * 2 / 3)
        tutorialLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.addChild(tutorialLabel)
        
        startupLabel.fontName = fontName
        startupLabel.fontSize = labelSize
        startupLabel.fontColor = UIColor.blackColor()
        if startupToggle == true {
            startupLabel.text = "Open Level Menu"
        } else {
            startupLabel.text = "Open in Game"
        }
        startupLabel.position = CGPointMake(self.frame.midX + 20, self.frame.midY * 4 / 3)
        startupLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.addChild(startupLabel)

        
        backLabel.fontName = backFontName
        backLabel.fontSize = backLabelSize
        backLabel.fontColor = UIColor.blackColor()
        backLabel.text = "Tap to Go Back"
        backLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)  * 1 / 3)
        self.addChild(backLabel)

        background.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(background)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        self.size = self.view!.frame.size
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if backgroundLabel.containsPoint(location) {
                backgroundLabel.select()
            } else if soundsLabel.containsPoint(location) {
                soundsLabel.select()
            } else if startupLabel.containsPoint(location) {
                startupLabel.select()
            } else if tutorialLabel.containsPoint(location){
                tutorialLabel.select()
            } else {
                backLabel.select()
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if backgroundLabel.containsPoint(location) && backgroundLabel.selected == true {
                backgroundLabel.deselect()
                chooseBackground()
            } else if soundsLabel.containsPoint(location) && soundsLabel.selected == true {
                soundsLabel.deselect()
                if self.soundToggle == true {
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "soundState")
                    self.soundToggle = false
                    self.soundsLabel.text = "Turn Sounds On"
                } else {
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "soundState")
                    self.soundToggle = true
                    self.soundsLabel.text = "Turn Sounds Off"
                }
            } else if startupLabel.containsPoint(location) && startupLabel.selected == true {
                startupLabel.deselect()
                if self.startupToggle == true {
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "startupState")
                    self.startupToggle = false
                    self.startupLabel.text = "Open in Game"
                } else {
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "startupState")
                    self.startupToggle = true
                    self.startupLabel.text = "Open Level Menu"
                }
            } else if tutorialLabel.containsPoint(location) && tutorialLabel.selected == true {
                tutorialLabel.deselect()
                replayTutorial()
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
        let transition = SKTransition.pushWithDirection(SKTransitionDirection.Down, duration: 1.0)
        let scene = GameOverScene(size: self.size)
        
        scene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene?.view?.presentScene(scene, transition: transition)
    }
    
    func chooseBackground() {
        let access = PHPhotoLibrary.authorizationStatus()
        if access == .Authorized {
            let imagePicker = LandscapePhotoPicker()
            let vc = self.view?.window?.rootViewController
            vc?.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Photo Library Access Not Enabled", message: "Please allow access in settings", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                let url: NSURL? = NSURL(string: UIApplicationOpenSettingsURLString)
                if url != nil
                {
                    UIApplication.sharedApplication().openURL(url!)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.view?.window?.rootViewController!.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func replayTutorial() {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasCompletedTutorial")
        let transition = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 1.0)
        let scene = GameScene(size: self.size)
        
        scene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene?.view?.presentScene(scene, transition: transition)
    }
    
    func deselectAll() {
        backgroundLabel.deselect()
        soundsLabel.deselect()
        backLabel.deselect()
        toggleLabel.deselect()
        titleLabel.deselect()
        tutorialLabel.deselect()
        startupLabel.deselect()
    }
     
   
}
