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
    class func unarchiveFromFile(_ file : NSString) -> SKNode? {
        if let path = Bundle.main.path(forResource: file as String, ofType: "sks") {
            let sceneData = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
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
        
        removeAds = UserDefaults.standard.bool(forKey: "RemoveAds")
        
        if UserDefaults.standard.object(forKey: "currentLevel") != nil {
            currentLevel = UserDefaults.standard.object(forKey: "currentLevel") as! Int
        }
        
        if UserDefaults.standard.object(forKey: "startupState") != nil {
            directToGame = UserDefaults.standard.bool(forKey: "startupState")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.removeBannerAds), name: NSNotification.Name(rawValue: "removeAds"), object: nil)
        
        iAdBanner.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.width, height: iAdBanner.bounds.height)
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
                    scene.scaleMode = .aspectFill
                    
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
                scene.scaleMode = .aspectFill
                
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
                scene.scaleMode = .aspectFill
                
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
                scene.scaleMode = .aspectFill
                
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
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        }

    }

    override var shouldAutorotate : Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // Show banner, if Ad is successfully loaded.
    func bannerViewDidLoadAd(_ banner: ADBannerView!) {
        if(bannerVisible == false) {
            
            removeAds = UserDefaults.standard.bool(forKey: "RemoveAds")

            // Add banner Ad to the view
            if(iAdBanner.superview == nil && removeAds == false) {
                self.view!.addSubview(iAdBanner)
            }
            // Move banner into visible screen frame:
            UIView.beginAnimations("iAdBannerShow", context: nil)
            banner.frame = banner.frame.offsetBy(dx: 0, dy: -banner.frame.size.height)
            UIView.commitAnimations()
            
            bannerVisible = true
        }
    }
    
    // Hide banner, if Ad is not loaded.
    func bannerView(_ banner: ADBannerView!, didFailToReceiveAdWithError error: Error!) {
        if(bannerVisible == true) {
            // Move banner below screen frame:
            UIView.beginAnimations("iAdBannerHide", context: nil)
            banner.frame = banner.frame.offsetBy(dx: 0, dy: banner.frame.size.height)
            UIView.commitAnimations()
            bannerVisible = false
        }
    }
    
    func removeBannerAds() {
        iAdBanner.removeFromSuperview()
    }
    
}
