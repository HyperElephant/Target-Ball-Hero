//
//  TimedGameBase.swift
//  Ball Hero
//
//  Created by David Taylor on 4/3/18.
//  Copyright © 2018 Hyper Elephant. All rights reserved.
//

import SpriteKit
import GameKit

class TimedGameBase: GameBase  {
    
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
        super.didMove(to: view)
        timerSpeed = 1.0
        addTimerBar()
    }
    override func setupUI() {
        super.setupUI()
        startLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        startLabel.text = "Tap to Start"
        startLabel.fontSize = 64 * fontScale
        startLabel.fontColor = UIColor.black
        self.addChild(startLabel)
    }
    
    override func handleGameTouch(_ touch: UITouch) {
        if !hasStarted {
            hasStarted = true
            startLabel.removeFromParent()
            timer = Timer.scheduledTimer(timeInterval: timerSpeed, target: self, selector: #selector(GameSceneThree.updateTimer), userInfo: nil, repeats: true)
        } else {
            super.handleGameTouch(touch)
        }
    }
    
    override func handleTargetContact(_ contact: SKPhysicsContact, ball: SKPhysicsBody) {
        super.handleTargetContact(contact, ball: ball)
        
        updateTimerSpeed()
        resetTimer()
    }
    
    override func handleContinueTouch(_ touch: UITouch) {
        super.handleContinueTouch(touch)
        updateTimerSpeed()
        resetTimer()
    }
    
    func updateTimerSpeed() {
        var speed = 1.0 / (score / 10.0 + 1.0)
        if speed < 0.1 {
            speed = 0.1
        }
        timerSpeed = speed
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
            saveHighscore(Int(score))
            if inContinue == false {
                continueMenu(true)
            }
        }
    }
    
}
