//
//  GameScene.swift
//  Ball Hero
//
//  Created by David Taylor on 3/23/15.
//  Copyright (c) 2015 Hyper Elephant. All rights reserved.
//

import SpriteKit
import GameKit
import Photos

class GameScene: SKScene, SKPhysicsContactDelegate  {
    var score = 0.0
    var scoreLabel = SKLabelNode()
    var labelHolder = SKSpriteNode()
    var highTest = false
    var inContinue = false

    var fontName = "HelveticaNeue"
    var fontScale = CGFloat(1)
    
    let ballGroup: UInt32 = 0x1 << 0
    let targetGroup: UInt32 = 0x1 << 1
    let obstacleGroup: UInt32 = 0x1 << 2
    let groundGroup: UInt32 = 0x1 << 3
    
    let ballGroupName = "ball"
    let targetGroupName = "target"
    
    var targetObjects = SKNode()
    
    //Sounds
    var soundToggle = Bool()
    let hitSound = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
    let ballSound = SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false)
    let trumpetSound = SKAction.playSoundFileNamed("trumpets.mp3", waitForCompletion: false)
    let thudSound = SKAction.playSoundFileNamed("thud.mp3", waitForCompletion: false)
    
    //Continue Menu
    var continuePane = SKSpriteNode()
    var continueLabel = SKLabelNode()
    var yesLabel = SKLabelNode()
    var noLabel = SKLabelNode()
    var restartLabel = SKLabelNode()
    
    var continueNum = 0
    
    //Tutorial
    var tutorialPane = SKSpriteNode()
    var tutorialLabel = SKLabelNode()
    var infoLabel = SKLabelNode()
    var tutorialNext = SKLabelNode()
    var arrow = SKSpriteNode(imageNamed: "Arrow.png")
    var inTutorial = false
    var tutorialStage = 1
    
    override func didMoveToView(view: SKView) {
        self.size = self.view!.frame.size
        
        NSUserDefaults.standardUserDefaults().setObject(1, forKey: "currentLevel")

        let completedTutorial = NSUserDefaults.standardUserDefaults().boolForKey("hasCompletedTutorial")
        authenticateLocalPlayer()
        self.addChild(labelHolder)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            fontScale = 1.5
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateContinues", name: "updateContinues", object: nil)
        scoreLabel.fontName = fontName
        scoreLabel.fontSize = 64 * fontScale
        scoreLabel.fontColor = UIColor.blackColor()
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height * 2 / 3)
        scoreLabel.zPosition = 7
        labelHolder.addChild(scoreLabel)
        
        let bg = getBackground()
        bg.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(bg)
        let groundRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width * 5, 1)
        let ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(edgeLoopFromRect: groundRect)
        ground.physicsBody?.categoryBitMask = groundGroup
        self.addChild(ground)
        
        self.physicsWorld.contactDelegate = self
        self.addChild(targetObjects)
        
        makeTarget()
        
        if NSUserDefaults.standardUserDefaults().objectForKey("soundState") != nil {
            soundToggle = NSUserDefaults.standardUserDefaults().boolForKey("soundState")
        } else {
            soundToggle = true
        }
        
        if completedTutorial == false {
            tutorial(1)
        } 
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        self.size = self.view!.frame.size
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if inContinue == false && inTutorial == false {
                let ballWidth = self.frame.size.height / 30
                let dx = (location.x) * 2
                let dy = (location.y - CGRectGetMidY(self.frame)) * 2
                let ball = SKShapeNode(circleOfRadius: ballWidth)
                ball.fillColor = UIColor(red: 0.267, green: 0.529, blue: 0.925, alpha: 1)
                ball.strokeColor = UIColor(red: 0.267, green: 0.529, blue: 0.925, alpha: 1)
                ball.position = CGPoint(x: self.frame.minX, y: CGRectGetMidY(self.frame))
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ballWidth)
                ball.physicsBody?.dynamic = true
                ball.physicsBody?.velocity = CGVectorMake(dx, dy)
                ball.name = ballGroupName
                ball.zPosition = 10
                ball.physicsBody?.categoryBitMask = ballGroup
                ball.physicsBody?.contactTestBitMask = targetGroup | groundGroup
                self.addChild(ball)
                
                if soundToggle == true {
                    
                    self.runAction(ballSound)
                }
            } else if inContinue == true {
                if yesLabel.containsPoint(location) {
                    if continueNum > 0 {
                        continueNum -= 1
                        NSUserDefaults.standardUserDefaults().setInteger(continueNum, forKey: "continues")
                        continueMenu(false)
                    } else {
                        let alert = UIAlertController(title: "No Continues Left", message: "Buy more at the store.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
                            self.gameOver()
                        }))
                        alert.addAction(UIAlertAction(title: "Store", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
                            self.showStore()
                        }))
                        self.view?.window?.rootViewController!.presentViewController(alert, animated: true, completion: nil)
                    }
                    
                } else if noLabel.containsPoint(location) {
                    gameOver()
                } else {
                    score = 0
                    scoreLabel.text = "\(Int(score))"
                    let dropDist = self.frame.size.height / 3
                    let dropOut = SKAction.moveBy(CGVector(dx: 0, dy: -dropDist), duration: 0.25)
                    targetObjects.runAction(dropOut, completion: { () -> Void in
                        let targetsMoveUp = SKAction.moveBy(CGVector(dx: 0, dy: dropDist), duration: 0)
                        self.targetObjects.removeAllChildren()
                        self.targetObjects.runAction(targetsMoveUp)
                        self.makeTarget()
                    })
                    continueMenu(false)
                }
            } else if inTutorial == true {
                tutorial(tutorialStage)
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        self.size = self.view!.frame.size
        
        let dropDist = self.frame.size.height / 3
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == ballGroup && secondBody.categoryBitMask == targetGroup {
            let dropOut = SKAction.moveBy(CGVector(dx: 0, dy: -dropDist), duration: 0.25)
            if soundToggle == true {
                
                self.runAction(hitSound)
            }
            score++
            scoreLabel.text = "\(Int(score))"
            if highScore(score) {
                scoreLabel.fontColor = UIColor.redColor()
                highTest = true
                if score == 10 || score == 25 || score == 50 || score == 100 || score == 250 || score == 500 || score == 1000 && soundToggle == true {
                    
                    self.runAction(trumpetSound)
                }
            }
            firstBody.categoryBitMask = obstacleGroup
            firstBody.node?.runAction(SKAction.fadeOutWithDuration(0.25), completion: { () -> Void in
                firstBody.node?.removeFromParent()
            })
            targetObjects.runAction(dropOut, completion: { () -> Void in
                let targetsMoveUp = SKAction.moveBy(CGVector(dx: 0, dy: dropDist), duration: 0)
                self.targetObjects.removeAllChildren()
                self.targetObjects.runAction(targetsMoveUp)
                self.makeTarget()
            })
            
        } else if firstBody.categoryBitMask == ballGroup && secondBody.categoryBitMask == groundGroup {
            firstBody.categoryBitMask = obstacleGroup
            firstBody.node?.runAction(SKAction.fadeOutWithDuration(0.25), completion: { () -> Void in
                firstBody.node?.removeFromParent()
            })
            //if highTest == true {
                saveHighscore(Int(score))
            //}
            if soundToggle == true {
                
                self.runAction(thudSound, completion: { () -> Void in
                    if self.inContinue == false {
                        self.continueMenu(true)
                    }
                })
            } else {
                if inContinue == false {
                    continueMenu(true)
                }
            }
        }
    }
    
    func makeTarget() {
        self.size = self.view!.frame.size
        
        let targetWidth = self.frame.size.width / 2
        let targetHeight = self.frame.size.height / 24
        let target = SKSpriteNode(color: UIColor(red: 0.937, green: 0.208, blue: 0.239, alpha: 1), size: CGSizeMake(targetWidth, targetHeight))
        let targetSize = 1 / ((0.05 * score * score) + 1.0)
        let targetFadeIn = SKAction.fadeInWithDuration(1)
        target.xScale = CGFloat(targetSize)
        if target.size.width < 1 {
            target.size.width = 1
        }
        let endValue = UInt32(self.frame.size.width - target.size.width)
        var placement = arc4random_uniform(endValue)
        placement = placement + UInt32(target.size.width / 2)
        
        target.position = CGPoint(x: CGFloat(placement), y: CGRectGetMidY(self.frame) / 2 )
        target.zPosition = 10
        
        target.physicsBody = SKPhysicsBody(rectangleOfSize: target.size)
        target.physicsBody?.dynamic = false
        target.physicsBody?.categoryBitMask = targetGroup
        
        target.name = targetGroupName
        
        target.alpha = 0
        
        targetObjects.addChild(target)
        target.runAction(targetFadeIn)
    }
    
    func highScore(score: Double) -> Bool {
        var isHigh = Bool()
        if NSUserDefaults.standardUserDefaults().objectForKey("highScore") != nil {
            let oldScore = NSUserDefaults.standardUserDefaults().objectForKey("highScore") as! Double
            if score > oldScore {
                NSUserDefaults.standardUserDefaults().setObject(score, forKey: "highScore")
                isHigh = true
            } else {
                isHigh = false
            }
        } else {
            NSUserDefaults.standardUserDefaults().setObject(score, forKey: "highScore")
            isHigh = true
        }
        NSUserDefaults.standardUserDefaults().setObject(score, forKey: "lastScore")
        return isHigh
    }
    
    func authenticateLocalPlayer(){
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) {
                self.view?.window?.rootViewController?.presentViewController(viewController!, animated: true, completion: nil)
            } else {
//                println(error)
            }
        }
    }
    
    func saveHighscore(score:Int) {
        if GKLocalPlayer.localPlayer().authenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "targetballheroleaderboard74656")
            scoreReporter.value = Int64(score)
            let scoreArray: [GKScore] = [scoreReporter]
            GKScore.reportScores(scoreArray, withCompletionHandler: { (error: NSError?) -> Void in
                if error != nil {
//                    println(error)
                }
            })
        }
    }
    
    func continueMenu(toggleContinue:Bool) {
        self.size = self.view!.frame.size
        inContinue = true
        continueNum = NSUserDefaults.standardUserDefaults().integerForKey("continues")
        
        if toggleContinue == true {
            continuePane.size = CGSizeMake(self.frame.width, self.frame.height)
            continuePane.color = UIColor.blackColor()
            continuePane.position = CGPointMake(self.frame.midX, self.frame.midY)
            continuePane.alpha = 0
            continuePane.zPosition = 80
            self.addChild(continuePane)
            
            continueLabel.text = "Continue?"
            continueLabel.fontSize = 64 * fontScale
            continueLabel.position = CGPointMake(self.frame.midX, self.frame.height * 2/3)
            continueLabel.zPosition = 81
            continueLabel.fontName = fontName
            self.addChild(continueLabel)

            noLabel.text = "No"
            noLabel.position = CGPointMake(self.frame.width / 3, self.frame.height / 2)
            noLabel.fontSize = 32 * fontScale
            noLabel.zPosition = 81
            noLabel.fontName = fontName
            self.addChild(noLabel)
            
            yesLabel.text = "Yes (\(continueNum))"
            yesLabel.position = CGPointMake(self.frame.width * 2/3, self.frame.height / 2)
            yesLabel.fontSize = 32 * fontScale
            yesLabel.zPosition = 81
            yesLabel.fontName = fontName
            self.addChild(yesLabel)
            
            restartLabel.text = "Restart"
            restartLabel.position = CGPointMake(self.frame.width / 2, self.frame.height / 3)
            restartLabel.fontSize = 32 * fontScale
            restartLabel.zPosition = 81
            restartLabel.fontName = "HelveticaNeue-Light"
            self.addChild(restartLabel)
            
            let fadeIn = SKAction.fadeAlphaTo(0.7, duration: 0.8)
            let fadeInLetters = SKAction.fadeAlphaTo(1.0, duration: 0.8)
            continuePane.runAction(fadeIn)
            continueLabel.runAction(fadeInLetters)
            yesLabel.runAction(fadeInLetters)
            noLabel.runAction(fadeInLetters)
            restartLabel.runAction(fadeInLetters)
        } else {
            continuePane.removeFromParent()
            continueLabel.removeFromParent()
            yesLabel.removeFromParent()
            noLabel.removeFromParent()
            restartLabel.removeFromParent()
            scoreLabel.fontColor = UIColor.blackColor()
            inContinue = false
        }
    }
    
    func tutorial(stage: Int) {
        tutorialPane.color = UIColor.blackColor()
        tutorialPane.size = self.size
        tutorialPane.position = CGPointMake(self.frame.midX, self.frame.midY)
        tutorialPane.alpha = 0.6
        tutorialLabel.text = "Tutorial"
        tutorialLabel.fontName = fontName
        tutorialLabel.fontSize = 48 * fontScale
        tutorialNext.text = "Tap to continue"
        tutorialNext.fontName = "HelveticaNeue-Light"
        tutorialNext.fontSize = 20 * fontScale
        infoLabel.fontName = fontName
        infoLabel.fontSize = 20 * fontScale
        tutorialPane.zPosition = 80
        tutorialLabel.zPosition = 81
        tutorialNext.zPosition = 81
        infoLabel.zPosition = 81
        arrow.zPosition = 81
        
        
        inTutorial = true
        
        switch stage {
        case 1:
            tutorialLabel.position = CGPointMake(self.frame.midX, self.frame.height * 7 / 8)
            tutorialNext.position = CGPointMake(self.frame.midX, self.frame.height * 1 / 8)
            arrow.position = CGPointMake(arrow.size.height / 2 + 10, self.frame.midY)
            arrow.zRotation = CGFloat(M_PI_2)
            infoLabel.text = "The ball enters from here"
            infoLabel.position = CGPointMake(arrow.size.height + 10, self.frame.midY)
            infoLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            infoLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            self.addChild(tutorialPane)
            self.addChild(tutorialLabel)
            self.addChild(infoLabel)
            self.addChild(arrow)
            self.addChild(tutorialNext)
            tutorialStage += 1
        case 2:
            arrow.position = CGPointMake(self.frame.midX, self.frame.height * 2 / 5 + 10)
            arrow.zRotation = CGFloat(M_PI)
            infoLabel.text = "The targets will appear along here"
            infoLabel.position = CGPointMake(self.frame.midX, self.frame.height * 2 / 5 + arrow.size.height / 2 + 25)
            infoLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
            infoLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            tutorialStage += 1
        case 3:
            arrow.alpha = 0
            infoLabel.position = CGPointMake(self.frame.midX, self.frame.midY)
            infoLabel.text = "Tap anywhere on the screen to release a ball"
            tutorialStage += 1
        case 4:
            infoLabel.text = "Where you tap determines the ball's trajectory"
            tutorialStage += 1
        case 5:
            infoLabel.text = "Tap here to send the ball slowly downward"
            arrow.alpha = 1
            arrow.position = CGPointMake(self.frame.width / 4, self.frame.height / 4)
            arrow.zRotation = CGFloat(M_PI_2 + 0.4)
            tutorialStage += 1
        case 6:
            infoLabel.text = "Tap here to send the ball quickly upward"
            arrow.position = CGPointMake(self.frame.width * 3/4, self.frame.height * 3/4)
            arrow.zRotation = CGFloat(-M_PI_2 + 0.4)
            tutorialStage += 1
        case 7:
            arrow.alpha = 0
            infoLabel.text = "Hit as many targets as you can in a row"
            tutorialStage += 1
        case 8:
            infoLabel.text = "The targets will get smaller with every hit"
            tutorialStage += 1
        case 9:
            infoLabel.text = "And if you miss, it's game over"
            tutorialStage += 1
        case 10:
            infoLabel.text = "Unless you have continues, which let you keep going"
            tutorialStage += 1
        case 11:
            infoLabel.text = "Buy as many continues as you'd like in the store"
            tutorialStage += 1
        case 12:
            infoLabel.text = "That's all. Good luck!"
            tutorialStage += 1
        case 13:
            tutorialPane.removeFromParent()
            tutorialLabel.removeFromParent()
            arrow.removeFromParent()
            infoLabel.removeFromParent()
            tutorialNext.removeFromParent()
            tutorialStage = 1
            inTutorial = false
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasCompletedTutorial")
        default:
            break
        }
    }
    
    func gameOver() {
        let transition = SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 1.0)
        let scene = GameOverScene(size: self.size)
        scene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene?.view?.presentScene(scene, transition: transition)
    }
    
    func showStore() {
        let vc = self.view?.window?.rootViewController
        let sc = StoreViewController()
        vc?.presentViewController(sc, animated: true, completion: nil)
    }
    
    func updateContinues() {
        continueNum = NSUserDefaults.standardUserDefaults().integerForKey("continues")
        yesLabel.text = "Yes (\(continueNum))"
    }
    
    func getBackground() -> SKSpriteNode {
        var bg = SKSpriteNode()
        var authorizationStatus = PHPhotoLibrary.authorizationStatus()
        if NSUserDefaults.standardUserDefaults().objectForKey("backgroundID") != nil && authorizationStatus == .Authorized{
            var images: PHFetchResult!
            let imageManager = PHImageManager()
            var backgroundID : [String] = []
            
            backgroundID.append(NSUserDefaults.standardUserDefaults().objectForKey("backgroundID")! as! String)
            images = PHAsset.fetchAssetsWithLocalIdentifiers(backgroundID, options: nil)
            var backgroundImage = UIImage()
            var options:PHImageRequestOptions = PHImageRequestOptions()
            options.synchronous = true
            var imageAsset: PHAsset? {
                didSet {
                    imageManager.requestImageForAsset(imageAsset!, targetSize:CGSize(width: self.frame.width * 8, height: self.frame.height * 8), contentMode: .AspectFill, options: options) { image, info in
                        if image != nil {
                            let texture = SKTexture(image: image!)
                            bg = SKSpriteNode(texture: texture, size: self.frame.size)
                            
                            switch image!.imageOrientation {
                            case UIImageOrientation.Down:
                                bg.yScale = -1
                                bg.xScale = -1
                            case UIImageOrientation.Left:
                                bg.zRotation = CGFloat(M_PI_2)
                            case UIImageOrientation.Right:
                                bg.zRotation = CGFloat(-M_PI_2)
                            default:
                                break
                            }
                            backgroundImage = image!
                        } else {
                            bg = SKSpriteNode(color: UIColor(red: 0.404, green: 0.945, blue: 0.49, alpha: 1), size: CGSizeMake(self.frame.width, self.frame.height))
                        }
                    }
                }
            }
            imageAsset = images[0] as? PHAsset
        } else {
            bg = SKSpriteNode(color: UIColor(red: 0.404, green: 0.945, blue: 0.49, alpha: 1), size: CGSizeMake(self.frame.width, self.frame.height))
        }
        return bg
    }
    
    
}
