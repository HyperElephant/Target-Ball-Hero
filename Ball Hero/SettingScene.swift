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
    
    override func didMove(to view: SKView) {
        self.size = self.view!.frame.size
        
        let background = SKSpriteNode(color: UIColor(red: 0.404, green: 0.945, blue: 0.49, alpha: 1), size: CGSize(width: self.frame.width, height: self.frame.height))
        
        if UserDefaults.standard.object(forKey: "soundState") != nil {
            soundToggle = UserDefaults.standard.bool(forKey: "soundState")
        } else {
            soundToggle = true
        }
        
        if UserDefaults.standard.object(forKey: "startupState") != nil {
            startupToggle = UserDefaults.standard.bool(forKey: "startupState")
        } else {
            startupToggle = false
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontScale = 1.5
        }
        labelSize = labelSize * fontScale
        backLabelSize = backLabelSize * fontScale
        titleSize = titleSize * fontScale
        
        titleLabel.fontName = titleFontName
        titleLabel.fontSize = titleSize
        titleLabel.fontColor = UIColor.black
        titleLabel.text = "Settings"
        titleLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 5 / 3)
        titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
        self.addChild(titleLabel)
        
        backgroundLabel.fontName = fontName
        backgroundLabel.fontSize = labelSize
        backgroundLabel.fontColor = UIColor.black
        backgroundLabel.text = "Set Background"
        backgroundLabel.position = CGPoint(x: 20, y: self.frame.midY * 4 / 3)
        backgroundLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.addChild(backgroundLabel)
        
        soundsLabel.fontName = fontName
        soundsLabel.fontSize = labelSize
        soundsLabel.fontColor = UIColor.black
        if soundToggle == true {
            soundsLabel.text = "Turn Sounds Off"
        } else {
            soundsLabel.text = "Turn Sounds On"
        }
        soundsLabel.position = CGPoint(x: 20, y: self.frame.midY)
        soundsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.addChild(soundsLabel)
        
        tutorialLabel.fontName = fontName
        tutorialLabel.fontSize = labelSize
        tutorialLabel.fontColor = UIColor.black
        tutorialLabel.text = "Replay Tutorial"
        tutorialLabel.position = CGPoint(x: 20, y: self.frame.midY * 2 / 3)
        tutorialLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.addChild(tutorialLabel)
        
        startupLabel.fontName = fontName
        startupLabel.fontSize = labelSize
        startupLabel.fontColor = UIColor.black
        if startupToggle == true {
            startupLabel.text = "Open Level Menu"
        } else {
            startupLabel.text = "Open in Game"
        }
        startupLabel.position = CGPoint(x: self.frame.midX + 20, y: self.frame.midY * 4 / 3)
        startupLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.addChild(startupLabel)

        
        backLabel.fontName = backFontName
        backLabel.fontSize = backLabelSize
        backLabel.fontColor = UIColor.black
        backLabel.text = "Tap to Go Back"
        backLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY  * 1 / 3)
        self.addChild(backLabel)

        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(background)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        self.size = self.view!.frame.size
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if backgroundLabel.contains(location) {
                backgroundLabel.select()
            } else if soundsLabel.contains(location) {
                soundsLabel.select()
            } else if startupLabel.contains(location) {
                startupLabel.select()
            } else if tutorialLabel.contains(location){
                tutorialLabel.select()
            } else {
                backLabel.select()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if backgroundLabel.contains(location) && backgroundLabel.selected == true {
                backgroundLabel.deselect()
                chooseBackground()
            } else if soundsLabel.contains(location) && soundsLabel.selected == true {
                soundsLabel.deselect()
                if self.soundToggle == true {
                    UserDefaults.standard.set(false, forKey: "soundState")
                    self.soundToggle = false
                    self.soundsLabel.text = "Turn Sounds On"
                } else {
                    UserDefaults.standard.set(true, forKey: "soundState")
                    self.soundToggle = true
                    self.soundsLabel.text = "Turn Sounds Off"
                }
            } else if startupLabel.contains(location) && startupLabel.selected == true {
                startupLabel.deselect()
                if self.startupToggle == true {
                    UserDefaults.standard.set(false, forKey: "startupState")
                    self.startupToggle = false
                    self.startupLabel.text = "Open in Game"
                } else {
                    UserDefaults.standard.set(true, forKey: "startupState")
                    self.startupToggle = true
                    self.startupLabel.text = "Open Level Menu"
                }
            } else if tutorialLabel.contains(location) && tutorialLabel.selected == true {
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
    
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func goBack() {
        let transition = SKTransition.push(with: SKTransitionDirection.down, duration: 1.0)
        let scene = GameOverScene(size: self.size)
        
        scene.scaleMode = SKSceneScaleMode.aspectFill
        self.scene?.view?.presentScene(scene, transition: transition)
    }
    
    func chooseBackground() {
        let access = PHPhotoLibrary.authorizationStatus()
        if access == .authorized {
            let imagePicker = LandscapePhotoPicker()
            let vc = self.view?.window?.rootViewController
            vc?.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Photo Library Access Not Enabled", message: "Please allow access in settings", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: { alertAction in
                alert.dismiss(animated: true, completion: nil)
                
                let url: URL? = URL(string: UIApplicationOpenSettingsURLString)
                if url != nil
                {
                    UIApplication.shared.openURL(url!)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.view?.window?.rootViewController!.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func replayTutorial() {
        UserDefaults.standard.set(false, forKey: "hasCompletedTutorial")
        let transition = SKTransition.push(with: SKTransitionDirection.left, duration: 1.0)
        let scene = GameScene(size: self.size)
        
        scene.scaleMode = SKSceneScaleMode.aspectFill
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
