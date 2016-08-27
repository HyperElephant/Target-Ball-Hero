//
//  GameViewController.swift
//  Ball Hero
//
//  Created by David Taylor on 3/23/15.
//  Copyright (c) 2015 Hyper Elephant. All rights reserved.
//

import UIKit
import SpriteKit
import iAd

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, ADBannerViewDelegate {

    var removeAds = false
    var iAdBanner = ADBannerView()
    var bannerVisible = false
    var currentLevel = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var directToGame = false
        
        removeAds = NSUserDefaults.standardUserDefaults().boolForKey("RemoveAds")
        
        if NSUserDefaults.standardUserDefaults().objectForKey("currentLevel") != nil {
            currentLevel = NSUserDefaults.standardUserDefaults().objectForKey("currentLevel") as! Int
        }
        
        if NSUserDefaults.standardUserDefaults().objectForKey("startupState") != nil {
            directToGame = NSUserDefaults.standardUserDefaults().boolForKey("startupState")
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.removeBannerAds), name: "removeAds", object: nil)
        
        iAdBanner.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.width, iAdBanner.bounds.height)
        iAdBanner.delegate = self
        bannerVisible = false
        
        if directToGame == true {
            if currentLevel == 1 {
                if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
                    // Configure the view.
                    let skView = self.view as! SKView
                    skView.showsFPS = false
                    skView.showsNodeCount = false
                    
                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView.ignoresSiblingOrder = true
                    
                    /* Set the scale mode to scale to fit the window */
                    scene.scaleMode = .AspectFill
                    
                    skView.presentScene(scene)
                }
            } else if currentLevel == 2 {
                let scene = GameSceneTwo()
                // Configure the view.
                let skView = self.view as! SKView
                skView.showsFPS = false
                skView.showsNodeCount = false
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFill
                
                skView.presentScene(scene)
                
            } else if currentLevel == 3 {
                let scene = GameSceneThree()
                // Configure the view.
                let skView = self.view as! SKView
                skView.showsFPS = false
                skView.showsNodeCount = false
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFill
                
                skView.presentScene(scene)
                
            } else if currentLevel == 4 {
                let scene = GameSceneFour()
                // Configure the view.
                let skView = self.view as! SKView
                skView.showsFPS = false
                skView.showsNodeCount = false
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFill
                
                skView.presentScene(scene)
                
            }

        } else {
            let scene = SelectLevelScene()
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }

    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Show banner, if Ad is successfully loaded.
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        if(bannerVisible == false) {
            
            removeAds = NSUserDefaults.standardUserDefaults().boolForKey("RemoveAds")

            // Add banner Ad to the view
            if(iAdBanner.superview == nil && removeAds == false) {
                self.view!.addSubview(iAdBanner)
            }
            // Move banner into visible screen frame:
            UIView.beginAnimations("iAdBannerShow", context: nil)
            banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height)
            UIView.commitAnimations()
            
            bannerVisible = true
        }
    }
    
    // Hide banner, if Ad is not loaded.
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        if(bannerVisible == true) {
            // Move banner below screen frame:
            UIView.beginAnimations("iAdBannerHide", context: nil)
            banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height)
            UIView.commitAnimations()
            bannerVisible = false
        }
    }
    
    func removeBannerAds() {
        iAdBanner.removeFromSuperview()
    }
    
}
