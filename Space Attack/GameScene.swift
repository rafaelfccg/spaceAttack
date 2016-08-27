//
//  GameScene.swift
//  Space Attack
//
//  Created by Miguel Araújo on 8/25/16.
//  Copyright (c) 2016 Miguel Araújo. All rights reserved.
//

import AVFoundation
import SpriteKit
import Darwin

enum EndReason {
    case Win
    case Lose
}

class BackgroundMusicSingleton {
    static let sharedInstance = BackgroundMusicSingleton()
    var backgroundAudioPlayer = AVAudioPlayer()
    
    init() {
        let path = NSURL.init(fileURLWithPath: Assets.backgroundMusic)
        
        do {
            self.backgroundAudioPlayer = try AVAudioPlayer.init(contentsOfURL: path)
        } catch _ {
            print("error `background music`")
        }
        
        self.backgroundAudioPlayer.prepareToPlay()
        self.backgroundAudioPlayer.numberOfLoops = -1
        self.backgroundAudioPlayer.volume = 1.0
        self.backgroundAudioPlayer.play()
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    let kNumAsteroids = 10
    let kNumLasers = 25
    let distTOP = 250
    
    var OnTrilaser = Bool()
    var gameOver = Bool()
    var nextAsteroid = Int()
    var nextShipLaser = Int()
    var lives = Int()
    var score = Int()
    var nextAsteroidSpawn = Double()
    var nextItemSpawn = Double()
    var nextLaserSpawn = Double()
    var gameOverTime = Double()
    var last_hit = Double()
    var trilaserTime = Double()
    var ship_Speed = CGFloat()
    var initMove = CGPoint()
    var shipLasers = []
    var asteroids = []
    
    var spaceship = Spaceship()
    var backgroundMusic = BackgroundMusicSingleton()
    var animaAst = SKAction()
    var LabelScore = SKLabelNode()
    var restartLabel = SKLabelNode()
    var parallaxNodeBackgrounds = ParallaxNode()
    var parallaxSpaceDust = ParallaxNode()
    
    
    override func didMoveToView(view: SKView) {
        // setup background
        self.backgroundColor = UIColor.blackColor()
        
        // setup physics
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        // setup label
        self.LabelScore = SKLabelNode.init(fontNamed: Assets.gameFont)
        self.LabelScore.name = "scoreLabel"
        self.LabelScore.text = String(format: "Score: %@", arguments: [score])
        self.LabelScore.position = CGPointMake(CGRectGetMaxX(self.frame) * 0.9 - 25, CGRectGetMaxY(self.frame) * 0.95 - 5)
        self.LabelScore.fontColor = UIColor.whiteColor()
        self.LabelScore.zPosition = 100
        
        setupGameBackground()
        setupSpaceshipSprites()
        setupAsteroids()
        setupStars()
        
        start()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var cur = CACurrentMediaTime()
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((secondBody.categoryBitMask & Physics.asteroidCategory) && (firstBody.categoryBitMask & Physics.shipCategory)
            && (!secondBody.node?.hidden) && (last_hit + 1.0 < cur)) {
            last_hit = cur
            secondBody.node?.hidden = true
            var blink = SKAction.sequence([SKAction.fadeInWithDuration(0.1), SKAction.fadeOutWithDuration(0.1)])
            var blinkForTime = SKAction.repeatAction(blink, count: 5)
            
            self.spaceship.runAction(blinkForTime)
            self.childNodeWithName(String(format: "L%d", arguments: [self.lives - 1]))?.removeFromParent()
            self.lives -= 1
        } else if (((secondBody.categoryBitMask & Physics.laserCategory) && (firstBody.categoryBitMask & Physics.asteroidCategory))
            && !secondBody.node.hidden && !firstBody.node.hidden) {
            firstBody.node?.hidden = true
            secondBody.node?.hidden = true
            firstBody.collisionBitMask = 0
            secondBody.collisionBitMask = 0
            self.score += 50
            setScore()
            
            //var emitterPath = NSBundle()
            // GUARD!
            var emitterPath = NSBundle.mainBundle().pathForResource("explosion", ofType: nil) // explosion to constants
            var emitterNode = SKEmitterNode.unarchiveFromFile(emitterPath!)
            emitterNode?.position = (firstBody.node?.position)!
            self.addChild(emitterNode!)
        } else if ((secondBody.categoryBitMask & Physics.itemTrilaser) && (firstBody.categoryBitMask & Physics.shipCategory)
            && !secondBody.node.hidden) {
            secondBody.node?.hidden = true
            self.spaceship.OnTrilaser = true
            self.spaceship.trilaserTime = cur
        }
        
        
    }
    
    func setupGameBackground() {
        
    }
    
    func setupSpaceshipSprites() {
        
    }
    
    func setupAsteroids() {
        
    }
    
    func setupStars() {
        
    }
    
    func start() {
        
    }
    
    func setScore() {
        
    }
    
    func endTheScene(endReason: EndReason) {
        if (gameOver) {
            return
        }
        
        self.removeAllActions()
        
        spaceship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) * 0.2)
        spaceship.physicsBody?.velocity = CGVectorMake(0, 0)
        gameOver = true
        
        var message = String()
        if (endReason == EndReason.Win) {
            message = "You won!"
        } else {
            message = "You lost!"
        }
        
        var labelH = SKLabelNode.init(fontNamed: Assets.gameFont)
        labelH.name = "HSLabel"
        
        let n = NSUserDefaults.standardUserDefaults()
        var val = n.integerForKey("HS")
        
        if (score > val) {
            n.setInteger(score, forKey: "HS")
            val = score
        }
        
        labelH.text = String.init(format: "High Score: %ld", arguments: [val])
        labelH.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height * 0.8)
        let color = SKColor.init(red: 0.807, green: 0.717, blue: 0.439, alpha: 1)
        labelH.fontColor = color
        self.addChild(labelH)
        
        var label = SKLabelNode()
        label = SKLabelNode.init(fontNamed: Assets.gameFont)
        label.name = "winLoseLabel"
        label.text = message
        label.setScale(0.1)
        label.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height * 0.6)
        self.addChild(label)
        
        restartLabel = SKLabelNode.init(fontNamed: Assets.gameFont)
        restartLabel.name = "restartLabel"
        restartLabel.text = "Play again?"
        restartLabel.setScale(0.5)
        restartLabel.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height * 0.4)
        restartLabel.fontColor = color
        restartLabel.zPosition = 100
        self.addChild(restartLabel)
        
        let labelScaleAction = SKAction.scaleTo(1.0, duration: 0.5)
        restartLabel.runAction(labelScaleAction)
        label.runAction(labelScaleAction)
        labelH.runAction(labelScaleAction)
    }
    
    func checkGameOver() {
        let cur = CACurrentMediaTime()
        if lives <= 0 {
            self.endTheScene(EndReason.Lose)
        } else if (cur >= gameOverTime) {
            self.endTheScene(EndReason.Win)
        }
    }
}
