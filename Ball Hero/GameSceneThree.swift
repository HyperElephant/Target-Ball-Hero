//
//  GameSceneThree.swift
//  Ball Hero
//
//  Created by David Taylor on 9/3/15.
//  Copyright (c) 2015 Hyper Elephant. All rights reserved.
//

import SpriteKit
import GameKit
import Photos

class GameSceneThree: SKScene, SKPhysicsContactDelegate  {
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
    
    //Timed
    var timer = Timer()
    var timerSpeed = TimeInterval()
    var startLabel = SKLabelNode()
    var hasStarted = false
    var timerProgress = 1
    var bar1 = SKSpriteNode()
    var bar2 = SKSpriteNode()
    var bar3 = SKSpriteNode()
    var bar4 = SKSpriteNode()
    var bar5 = SKSpriteNode()
    var remainingBars = [SKSpriteNode()]
    
    override func didMove(to view: SKView) {
        self.size = self.view!.frame.size
        
        UserDefaults.standard.set(3, forKey: "currentLevel")
        
        let completedTutorial = UserDefaults.standard.bool(forKey: "hasCompletedTutorial")
        authenticateLocalPlayer()
        self.addChild(labelHolder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameSceneThree.updateContinues), name: NSNotification.Name(rawValue: "updateContinues"), object: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontScale = 1.5
        }
        
        timerSpeed = 1.0
        
        scoreLabel.fontName = fontName
        scoreLabel.fontSize = 64 * fontScale
        scoreLabel.fontColor = UIColor.black
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height * 2 / 3)
        scoreLabel.zPosition = 72
        labelHolder.addChild(scoreLabel)
        self.physicsWorld.contactDelegate = self
        self.addChild(targetObjects)
        
        addTimerBar()
        
        startLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        startLabel.text = "Tap to Start"
        startLabel.fontSize = 64 * fontScale
        startLabel.fontColor = UIColor.black
        self.addChild(startLabel)
        let bg = getBackground()
        
        bg.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(bg)
        let groundRect = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width * 5, height: 1)
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: 0)
        ground.physicsBody = SKPhysicsBody(edgeLoopFrom: groundRect)
        self.addChild(ground)
        ground.physicsBody?.categoryBitMask = groundGroup
        makeTarget()
        if UserDefaults.standard.object(forKey: "soundState") != nil {
            soundToggle = UserDefaults.standard.bool(forKey: "soundState")
        } else {
            soundToggle = true
        }
        
        if completedTutorial == false {
            tutorial(1)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        self.size = self.view!.frame.size
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            if inContinue == false && inTutorial == false && hasStarted == true {
                let ballWidth = self.frame.size.height / 30
                let dx = (location.x) * 2
                let dy = (location.y - self.frame.midY) * 2
                let ball = SKShapeNode(circleOfRadius: ballWidth)
                ball.fillColor = UIColor(red: 0.267, green: 0.529, blue: 0.925, alpha: 1)
                ball.strokeColor = UIColor(red: 0.267, green: 0.529, blue: 0.925, alpha: 1)
                ball.position = CGPoint(x: 0, y: self.frame.midY)
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ballWidth)
                ball.physicsBody?.isDynamic = true
                ball.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
                ball.name = ballGroupName
                ball.zPosition = 10
                ball.physicsBody?.categoryBitMask = ballGroup
                ball.physicsBody?.contactTestBitMask = targetGroup | groundGroup
                self.addChild(ball)
                
                if soundToggle == true {
                    self.run(ballSound)
                }
            } else if inContinue == true {
                if yesLabel.contains(location) {
                    if continueNum > 0 {
                        continueNum -= 1
                        UserDefaults.standard.set(continueNum, forKey: "continues")
                        continueMenu(false)
                    } else {
                        let alert = UIAlertController(title: "No Continues Left", message: "Buy more at the store.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: { (alert) -> Void in
                            self.gameOver()
                        }))
                        alert.addAction(UIAlertAction(title: "Store", style: UIAlertActionStyle.default, handler: { (alert) -> Void in
                            self.showStore()
                        }))
                        self.view?.window?.rootViewController!.present(alert, animated: true, completion: nil)
                    }
                    
                } else if noLabel.contains(location) {
                    gameOver()
                } else {
                    score = 0
                    scoreLabel.fontColor = UIColor.black
                    updateTimerSpeed()
                    scoreLabel.text = "\(Int(score))"
                    let dropDist = self.frame.size.height / 3
                    let dropOut = SKAction.move(by: CGVector(dx: 0, dy: -dropDist), duration: 0.25)
                    targetObjects.run(dropOut, completion: { () -> Void in
                        let targetsMoveUp = SKAction.move(by: CGVector(dx: 0, dy: dropDist), duration: 0)
                        self.targetObjects.removeAllChildren()
                        self.targetObjects.run(targetsMoveUp)
                        self.makeTarget()
                    })
                    continueMenu(false)
                }
            } else if inTutorial == true {
                tutorial(tutorialStage)
            } else if hasStarted == false {
                hasStarted = true
                startLabel.removeFromParent()
                timer = Timer.scheduledTimer(timeInterval: timerSpeed, target: self, selector: #selector(GameSceneThree.updateTimer), userInfo: nil, repeats: true)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
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
            let dropOut = SKAction.move(by: CGVector(dx: 0, dy: -dropDist), duration: 0.25)
            if soundToggle == true {
                self.run(hitSound)
            }
            score += 1
            scoreLabel.text = "\(Int(score))"
            if highScore(score) {
                scoreLabel.fontColor = UIColor.red
                highTest = true
                if score == 10 || score == 25 || score == 50 || score == 100 || score == 250 || score == 500 || score == 1000 && soundToggle == true {
                    self.run(trumpetSound)
                }
            }
            firstBody.categoryBitMask = obstacleGroup
            firstBody.node?.run(SKAction.fadeOut(withDuration: 0.25), completion: { () -> Void in
                firstBody.node?.removeFromParent()
            })
            targetObjects.run(dropOut, completion: { () -> Void in
                let targetsMoveUp = SKAction.move(by: CGVector(dx: 0, dy: dropDist), duration: 0)
                self.targetObjects.removeAllChildren()
                self.targetObjects.run(targetsMoveUp)
                self.makeTarget()
            })
            updateTimerSpeed()
            resetTimer()
            
        } else if firstBody.categoryBitMask == ballGroup && secondBody.categoryBitMask == groundGroup {
            firstBody.categoryBitMask = obstacleGroup
            firstBody.node?.run(SKAction.fadeOut(withDuration: 0.25), completion: { () -> Void in
                firstBody.node?.removeFromParent()
            })
            
            //if highTest == true {
                saveHighscore(Int(score))
           // }
            if soundToggle == true {
                self.run(thudSound, completion: { () -> Void in
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
        
        let targetWidth = self.frame.size.width / 10
        let targetHeight = self.frame.size.height / 24
        let target = SKSpriteNode(color: UIColor(red: 0.937, green: 0.208, blue: 0.239, alpha: 1), size: CGSize(width: targetWidth, height: targetHeight))
        let targetFadeIn = SKAction.fadeIn(withDuration: 1)
        
        let endValue = UInt32(self.frame.size.width - target.size.width)
        var placement = arc4random_uniform(endValue)
        placement = placement + UInt32(target.size.width / 2)
        
        target.position = CGPoint(x: CGFloat(placement), y: self.frame.midY / 2 )
        target.zPosition = 10
        
        target.physicsBody = SKPhysicsBody(rectangleOf: target.size)
        target.physicsBody?.isDynamic = false
        target.physicsBody?.categoryBitMask = targetGroup
        
        target.name = targetGroupName
        
        target.alpha = 0
        
        targetObjects.addChild(target)
        target.run(targetFadeIn)
    }
    
    func updateTimerSpeed() {
       var speed = 1.0 / (score / 10.0 + 1.0)
        if speed < 0.1 {
            speed = 0.1
        }
        timerSpeed = speed
    }
    
    func highScore(_ score: Double) -> Bool {
        var isHigh = Bool()
        if UserDefaults.standard.object(forKey: "highScoreLevelThree") != nil {
            let oldScore = UserDefaults.standard.object(forKey: "highScoreLevelThree") as! Double
            if score > oldScore {
                UserDefaults.standard.set(score, forKey: "highScoreLevelThree")
                isHigh = true
            } else {
                isHigh = false
            }
        } else {
            UserDefaults.standard.set(score, forKey: "highScoreLevelThree")
            isHigh = true
        }
        UserDefaults.standard.set(score, forKey: "lastScore")
        return isHigh
    }
    
    func authenticateLocalPlayer(){
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) {
                self.view?.window?.rootViewController?.present(viewController!, animated: true, completion: nil)
            } else {
                //                println(error)
            }
        }
    }
    
    func saveHighscore(_ score:Int) {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "targetballheroleaderboardlevelthree74656")
            scoreReporter.value = Int64(score)
            let scoreArray: [GKScore] = [scoreReporter]
            GKScore.report(scoreArray, withCompletionHandler: { (error: Error?) -> Void in
                if error != nil {
                    //                    println(error)
                }
            })
        }
    }
    
    func continueMenu(_ toggleContinue:Bool) {
        self.size = self.view!.frame.size
        inContinue = true
        continueNum = UserDefaults.standard.integer(forKey: "continues")
        
        if toggleContinue == true {
            continuePane.size = CGSize(width: self.frame.width, height: self.frame.height)
            continuePane.color = UIColor.black
            continuePane.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            continuePane.alpha = 0
            continuePane.zPosition = 80
            self.addChild(continuePane)
            
            continueLabel.text = "Continue?"
            continueLabel.fontSize = 64 * fontScale
            continueLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height * 2/3)
            continueLabel.zPosition = 81
            continueLabel.fontName = fontName
            self.addChild(continueLabel)
            
            noLabel.text = "No"
            noLabel.position = CGPoint(x: self.frame.width / 3, y: self.frame.height / 2)
            noLabel.fontSize = 32 * fontScale
            noLabel.zPosition = 81
            noLabel.fontName = fontName
            self.addChild(noLabel)
            
            yesLabel.text = "Yes (\(continueNum))"
            yesLabel.position = CGPoint(x: self.frame.width * 2/3, y: self.frame.height / 2)
            yesLabel.fontSize = 32 * fontScale
            yesLabel.zPosition = 81
            yesLabel.fontName = fontName
            self.addChild(yesLabel)
            
            restartLabel.text = "Restart"
            restartLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 3)
            restartLabel.fontSize = 32 * fontScale
            restartLabel.zPosition = 81
            restartLabel.fontName = "HelveticaNeue-Light"
            self.addChild(restartLabel)
            
            let fadeIn = SKAction.fadeAlpha(to: 0.7, duration: 0.8)
            let fadeInLetters = SKAction.fadeAlpha(to: 1.0, duration: 0.8)
            continuePane.run(fadeIn)
            continueLabel.run(fadeInLetters)
            yesLabel.run(fadeInLetters)
            noLabel.run(fadeInLetters)
            restartLabel.run(fadeInLetters)
        } else {
            continuePane.removeFromParent()
            continueLabel.removeFromParent()
            yesLabel.removeFromParent()
            noLabel.removeFromParent()
            restartLabel.removeFromParent()
            resetTimer()
            scoreLabel.fontColor = UIColor.black
            inContinue = false
        }
    }
    
    func resetTimer() {
        self.removeChildren(in: remainingBars)
        addTimerBar()
        timer.invalidate()
        timerProgress = 1
        timer = Timer.scheduledTimer(timeInterval: timerSpeed, target: self, selector: #selector(GameSceneThree.updateTimer), userInfo: nil, repeats: true)
    }
    
    func addTimerBar() {
        remainingBars = [bar1,bar2,bar3,bar4,bar5]
        let barHeight = self.frame.height / 20
        let barSpace = self.frame.width / 5
        let barWidth = barSpace - 10
        bar1.size = CGSize(width: barWidth, height: barHeight)
        bar1.color = UIColor.black
        bar1.position = CGPoint(x: barSpace - barSpace / 2, y: self.frame.height - barHeight / 2)
        bar1.alpha = 0.9
        bar1.zPosition = 80
        self.addChild(bar1)
        bar2.size = CGSize(width: barWidth, height: barHeight)
        bar2.color = UIColor.black
        bar2.position = CGPoint(x: barSpace * 2 - barSpace / 2, y: self.frame.height - barHeight / 2)
        bar2.alpha = 0.9
        bar2.zPosition = 80
        self.addChild(bar2)
        bar3.size = CGSize(width: barWidth, height: barHeight)
        bar3.color = UIColor.black
        bar3.position = CGPoint(x: barSpace * 3 - barSpace / 2, y: self.frame.height - barHeight / 2)
        bar3.alpha = 0.9
        bar3.zPosition = 80
        self.addChild(bar3)
        bar4.size = CGSize(width: barWidth, height: barHeight)
        bar4.color = UIColor.black
        bar4.position = CGPoint(x: barSpace * 4 - barSpace / 2, y: self.frame.height - barHeight / 2)
        bar4.alpha = 0.9
        bar4.zPosition = 80
        self.addChild(bar4)
        bar5.size = CGSize(width: barWidth, height: barHeight)
        bar5.color = UIColor.black
        bar5.position = CGPoint(x: barSpace * 5 - barSpace / 2, y: self.frame.height - barHeight / 2)
        bar5.alpha = 0.9
        bar5.zPosition = 80
        self.addChild(bar5)
 
    }
    
    func tutorial(_ stage: Int) {
        tutorialPane.color = UIColor.black
        tutorialPane.size = self.size
        tutorialPane.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
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
            tutorialLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height * 7 / 8)
            tutorialNext.position = CGPoint(x: self.frame.midX, y: self.frame.height * 1 / 8)
            arrow.position = CGPoint(x: arrow.size.height / 2 + 10, y: self.frame.midY)
            arrow.zRotation = CGFloat(Double.pi / 2)
            infoLabel.text = "The ball enters from here"
            infoLabel.position = CGPoint(x: arrow.size.height + 10, y: self.frame.midY)
            infoLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            infoLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            self.addChild(tutorialPane)
            self.addChild(tutorialLabel)
            self.addChild(infoLabel)
            self.addChild(arrow)
            self.addChild(tutorialNext)
            tutorialStage += 1
        case 2:
            arrow.position = CGPoint(x: self.frame.midX, y: self.frame.height * 2 / 5 + 10)
            arrow.zRotation = CGFloat(Double.pi)
            infoLabel.text = "The targets will appear along here"
            infoLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height * 2 / 5 + arrow.size.height / 2 + 25)
            infoLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            infoLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            tutorialStage += 1
        case 3:
            arrow.alpha = 0
            infoLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            infoLabel.text = "Tap anywhere on the screen to release a ball"
            tutorialStage += 1
        case 4:
            infoLabel.text = "Where you tap determines the ball's trajectory"
            tutorialStage += 1
        case 5:
            infoLabel.text = "Tap here to send the ball slowly downward"
            arrow.alpha = 1
            arrow.position = CGPoint(x: self.frame.width / 4, y: self.frame.height / 4)
            arrow.zRotation = CGFloat(Double.pi / 2 + 0.4)
            tutorialStage += 1
        case 6:
            infoLabel.text = "Tap here to send the ball quickly upward"
            arrow.position = CGPoint(x: self.frame.width * 3/4, y: self.frame.height * 3/4)
            arrow.zRotation = CGFloat(-Double.pi / 2 + 0.4)
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
            UserDefaults.standard.set(true, forKey: "hasCompletedTutorial")
        default:
            break
        }
    }
    
    func gameOver() {
        let transition = SKTransition.push(with: SKTransitionDirection.right, duration: 1.0)
        let scene = GameOverScene(size: self.size)
        scene.scaleMode = SKSceneScaleMode.aspectFill
        self.scene?.view?.presentScene(scene, transition: transition)
    }
    
    func showStore() {
        let vc = self.view?.window?.rootViewController
        let sc = StoreViewController()
        vc?.present(sc, animated: true, completion: nil)
    }
    
    @objc func updateContinues() {
        continueNum = UserDefaults.standard.integer(forKey: "continues")
        yesLabel.text = "Yes (\(continueNum))"
    }
    
    @objc func updateTimer() {
        switch timerProgress {
        case 1:
            bar1.removeFromParent()
            remainingBars.remove(at: 0)
            timerProgress += 1
        case 2:
            bar2.removeFromParent()
            remainingBars.remove(at: 0)
            timerProgress += 1
        case 3:
            bar3.removeFromParent()
            remainingBars.remove(at: 0)
            timerProgress += 1
        case 4:
            bar4.removeFromParent()
            remainingBars.remove(at: 0)
            timerProgress += 1
        case 5:
            bar5.removeFromParent()
            remainingBars.remove(at: 0)
            timerProgress += 1
        default:
            timer.invalidate()
            //if highTest == true {
                saveHighscore(Int(score))
            //}
            if inContinue == false {
                continueMenu(true)
            }
        }
    }
    func getBackground() -> SKSpriteNode {
        var bg = SKSpriteNode()
        var authorizationStatus = PHPhotoLibrary.authorizationStatus()
        if UserDefaults.standard.object(forKey: "backgroundID") != nil && authorizationStatus == .authorized{
            var images: PHFetchResult<PHAsset>!
            let imageManager = PHImageManager()
            var backgroundID : [String] = []
            
            backgroundID.append(UserDefaults.standard.object(forKey: "backgroundID")! as! String)
            images = PHAsset.fetchAssets(withLocalIdentifiers: backgroundID, options: nil)
            var backgroundImage = UIImage()
            var options:PHImageRequestOptions = PHImageRequestOptions()
            options.isSynchronous = true
            var imageAsset: PHAsset? {
                didSet {
                    imageManager.requestImage(for: imageAsset!, targetSize:CGSize(width: self.frame.width * 8, height: self.frame.height * 8), contentMode: .aspectFill, options: options) { image, info in
                        if image != nil {
                            let texture = SKTexture(image: image!)
                            bg = SKSpriteNode(texture: texture, size: self.frame.size)
                            
                            switch image!.imageOrientation {
                            case UIImageOrientation.down:
                                bg.yScale = -1
                                bg.xScale = -1
                            case UIImageOrientation.left:
                                bg.zRotation = CGFloat(Double.pi / 2)
                            case UIImageOrientation.right:
                                bg.zRotation = CGFloat(-Double.pi / 2)
                            default:
                                break
                            }
                            backgroundImage = image!
                        } else {

                            bg = SKSpriteNode(color: UIColor(red: 0.404, green: 0.945, blue: 0.49, alpha: 1), size: CGSize(width: self.frame.width, height: self.frame.height))
                        }
                    }
                }
            }
            imageAsset = images[0] 
        } else {
            bg = SKSpriteNode(color: UIColor(red: 0.404, green: 0.945, blue: 0.49, alpha: 1), size: CGSize(width: self.frame.width, height: self.frame.height))
        }
        return bg
    }
    
    
}

