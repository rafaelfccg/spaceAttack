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
        let path = NSURL.init(fileURLWithPath: Resources.gameplayMusic)
        
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
    let distTOP = CGFloat(250)
    
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
    var shipLasers = [SKSpriteNode]()
    var asteroids = []
    
    var spaceship = Spaceship()
    var backgroundMusic = BackgroundMusicSingleton()
    var animaAst = SKAction()
    var LabelScore = SKLabelNode()
    var restartLabel = SKLabelNode()
    var parallaxNodeBackgrounds = Parallax()
    var parallaxSpaceDust = Parallax()
    
    static func sceneFromFileNamed(fileNamed:String!)->GameScene?{
        let gameScene = GameScene.unarchiveFromFile(fileNamed) as? GameScene;
        return gameScene
    }
    
    override init(size: CGSize) {
        
        super.init(size: size)
        // setup background color
        self.backgroundColor = SKColor.blackColor()
        
        // setup physics world
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        
        // setup label
        self.LabelScore = SKLabelNode.init(fontNamed: Assets.gameFont)
        self.LabelScore.name = "scoreLabel"
        self.LabelScore.text = String(format: "Score: %@", arguments: [score])
        self.LabelScore.position = CGPointMake(CGRectGetMaxX(self.frame) * 0.9 - 25, CGRectGetMaxY(self.frame) * 0.95 - 5)
        self.LabelScore.fontColor = UIColor.whiteColor()
        self.LabelScore.zPosition = 100
        
        // game backgorund
        var parallaxBackground2Names = [Assets.space, Assets.space]
        // self.parallaxSpaceDust = initWithBackgrounds(parallaxBackground2Names, size, 30.0, size)
        parallaxSpaceDust.position = CGPointMake(0, 0)
        self.addChild(parallaxSpaceDust)
        let randSecs = Utils.random(25, max: 45)
        nextItemSpawn = randSecs
        
        // setup spaceship sprite
        spaceship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) * 0.2)
        self.addChild(spaceship)
        ship_Speed = 0
        
        // setup asteroids
        let animaAstTexture = [
            SKTexture.init(imageNamed: Assets.rock1),
            SKTexture.init(imageNamed: Assets.rock2),
            SKTexture.init(imageNamed: Assets.rock3),
            SKTexture.init(imageNamed: Assets.rock4),
            SKTexture.init(imageNamed: Assets.rock5),
            SKTexture.init(imageNamed: Assets.rock6),
            SKTexture.init(imageNamed: Assets.rock7),
            SKTexture.init(imageNamed: Assets.rock8),
            SKTexture.init(imageNamed: Assets.rock9),
            SKTexture.init(imageNamed: Assets.rock10),
            SKTexture.init(imageNamed: Assets.rock11),
            SKTexture.init(imageNamed: Assets.rock12),
            SKTexture.init(imageNamed: Assets.rock13),
            SKTexture.init(imageNamed: Assets.rock14),
            SKTexture.init(imageNamed: Assets.rock15)
        ]
        let anima = SKAction.animateWithTextures(animaAstTexture, timePerFrame: 0.025)
        animaAst = SKAction.repeatActionForever(anima)
        
        // setup lasers
        for _ in 1...kNumLasers {
            let shipLaser = SKSpriteNode.init(imageNamed: Assets.shotBlue)
            shipLaser.hidden = true
            shipLasers.append(shipLaser)
            self.addChild(shipLaser)
        }
        
        // setup stars
        self.addChild(loadEmitterNode(Assets.star1))
        
        startTheGame()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        if !restartLabel.hidden {
            for touch in touches {
                let n = SKNode.nodeAtPoint(self)
                
                
            }
        }
        
        if gameOver {
            return
        }
        
        for touch in touches {
            let pos = touch.locationInNode(self)
            initMove = pos
            let x = pos.x - spaceship.position.x
            let y = pos.y - spaceship.position.y
            let normT = norm(x, y: y)
            let thrustVector = CGVectorMake(40 * x / normT, 40 * y / normT)
            spaceship.physicsBody?.applyImpulse(thrustVector)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        self.checkShip()
        // parallaxSpaceDust.update(currentTime)
        // parallaxNodeBackgrounds.update(currentTime)
        if !gameOver {
            self.doAsteroids()
            spaceship.doLasers(self)
            self.checkEndGame()
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let cur = CACurrentMediaTime()
        
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((secondBody.categoryBitMask & PhysicsCategory.asteroid == PhysicsCategory.asteroid) &&
            (firstBody.categoryBitMask & PhysicsCategory.spaceship == PhysicsCategory.asteroid) &&
            (!secondBody.node!.hidden == true) && (last_hit + 1.0 < cur)) {
            last_hit = cur
            secondBody.node?.hidden = true
            let blink = SKAction.sequence([SKAction.fadeInWithDuration(0.1), SKAction.fadeOutWithDuration(0.1)])
            let blinkForTime = SKAction.repeatAction(blink, count: 5)
            self.spaceship.runAction(blinkForTime)
            self.childNodeWithName(String(format: "L%d", arguments: [self.lives - 1]))?.removeFromParent()
            lives -= 1
        } else if (((secondBody.categoryBitMask & PhysicsCategory.laser == PhysicsCategory.laser) &&
            (firstBody.categoryBitMask & PhysicsCategory.asteroid == PhysicsCategory.asteroid))
            && (!secondBody.node!.hidden == true) && !firstBody.node!.hidden) {
            firstBody.node?.hidden = true
            firstBody.collisionBitMask = 0
            secondBody.node?.hidden = true
            secondBody.collisionBitMask = 0
            self.score += 50
            setScore()
            
            let emitterPath = NSBundle.mainBundle().pathForResource("explosion", ofType: nil)
            let emitterNode = SKEmitterNode.unarchiveFromFile(emitterPath!)
            emitterNode?.position = (firstBody.node?.position)!
            self.addChild(emitterNode!)
        } else if ((secondBody.categoryBitMask & PhysicsCategory.trilaser == 1) &&
            (firstBody.categoryBitMask & PhysicsCategory.spaceship == 1) &&
            secondBody.node!.hidden == true) {
            secondBody.node?.hidden = true
            self.spaceship.OnTrilaser = true
            self.spaceship.trilaserTime = cur
        }
    }
    
    func loadEmitterNode(emitterFileName: String) -> SKEmitterNode {
        let emitterPath = NSBundle.mainBundle().pathForResource(emitterFileName, ofType: "sks")
        let emitterNode:SKEmitterNode = SKEmitterNode.unarchiveFromFile(emitterPath!) as! SKEmitterNode
        
         emitterNode.particlePosition = CGPointMake(self.size.width / 2.0, self.size.height / 2.0);
         emitterNode.particlePositionRange = CGVectorMake(self.size.width, self.size.height + 150);
         return emitterNode
    }
    
    func startTheGame() {
        let cur = CACurrentMediaTime()
        
        nextAsteroidSpawn = 0
        lives = 3
        score = 0
        gameOverTime = 180 + cur
        gameOver = false
        OnTrilaser = false
        
        restartLabel.hidden = false
        let randSecs = Utils.random(10, max: 40)
        nextItemSpawn = cur + randSecs
        nextAsteroidSpawn = cur + 2.5
        setScore()
        
        spaceship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) * 0.2)
        spaceship.hidden = false
        
        let arr = [
            SKSpriteNode.init(imageNamed: Assets.spaceshipBgspeed),
            SKSpriteNode.init(imageNamed: Assets.spaceshipBgspeed),
            SKSpriteNode.init(imageNamed: Assets.spaceshipBgspeed)
        ]
        var count = 0
        let x = CGRectGetMinX(self.frame)
        let y = CGRectGetMinY(self.frame)
        
        for i in arr {
            i.xScale = 0.25
            i.yScale = 0.25
            let fir = CGFloat((x + CGFloat(2 * count + 1) * i.size.width) / 7)
            let sec = CGFloat(y - i.size.height / -5)
            i.position = CGPointMake(fir, sec)
            i.name = String(format: "L%d", arguments: [count])
            self.addChild(i)
            count += 1
        }
        
        self.addChild(LabelScore)
        self.backgroundMusic = BackgroundMusicSingleton()
    }
    
    func doAsteroids() {
        let curTime = CACurrentMediaTime()
        
        if curTime > nextItemSpawn {
            let randSecs = Utils.random(15, max: 45)
            nextItemSpawn = curTime + randSecs
            
            let randX = Utils.random(0, max: Double(self.frame.size.width))
            let trilaserItem = SKSpriteNode.init(imageNamed: Assets.shotRed)
            
            // setup trilaserItem
            trilaserItem.position = CGPointMake(CGFloat(randX),CGRectGetMaxY(self.frame))
            trilaserItem.hidden = false
            trilaserItem.xScale = 1.4
            trilaserItem.yScale = 1.4
            
            // setup trilaserItem physics
            trilaserItem.physicsBody = SKPhysicsBody.init(texture: trilaserItem.texture!, size: (trilaserItem.texture?.size())!)
            trilaserItem.physicsBody?.categoryBitMask = PhysicsCategory.trilaser
            trilaserItem.physicsBody?.contactTestBitMask = PhysicsCategory.spaceship
            trilaserItem.physicsBody?.collisionBitMask = 0
            trilaserItem.physicsBody?.allowsRotation = false
            
            let remove = SKAction.removeFromParent()
            let seq = SKAction.sequence([SKAction.waitForDuration(15), remove])
            self.addChild(trilaserItem)
            trilaserItem.runAction(seq)
            let blink = SKAction.sequence([
                SKAction.fadeOutWithDuration(0.2),
                SKAction.fadeInWithDuration(0.2)
            ])
            let blinkForTime = SKAction.repeatAction(blink, count: 30)
            trilaserItem.runAction(blinkForTime)
            trilaserItem.physicsBody?.applyImpulse(CGVectorMake(0, -5))
        }
        
        if curTime > nextAsteroidSpawn {
            let asteroid = Asteroid.init(scene: self, animation: animaAst)
        }
    }
    
    func doLasers() {
        let curTime = CACurrentMediaTime()
        
        if curTime > trilaserTime + 15 {
            OnTrilaser = false
        }
        
        if !OnTrilaser && curTime > nextLaserSpawn {
            let shipLaser = SKSpriteNode.init(imageNamed: Assets.shotBlue)
            
            shipLaser.position = CGPointMake(spaceship.position.x, shipLaser.size.height / 2 + spaceship.position.y)
            shipLaser.hidden = false
            shipLaser.removeAllActions()
            
            // setup shipLaser physics
            shipLaser.physicsBody = SKPhysicsBody.init(texture: shipLaser.texture!, size: (shipLaser.texture?.size())!)
            shipLaser.physicsBody?.categoryBitMask = PhysicsCategory.laser
            shipLaser.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
            shipLaser.physicsBody?.collisionBitMask = 0
            shipLaser.physicsBody?.allowsRotation = false
            
            let remove = SKAction.removeFromParent()
            let seq = SKAction.sequence([SKAction.waitForDuration(5), remove])
            self.addChild(shipLaser)
            shipLaser.runAction(seq)
            shipLaser.physicsBody?.applyImpulse(CGVectorMake(0, 10))
        } else if curTime > nextLaserSpawn {
            nextLaserSpawn = 0.15 + curTime
            
            let shots = [
                SKSpriteNode.init(imageNamed: Assets.shotRed),
                SKSpriteNode.init(imageNamed: Assets.shotRed),
                SKSpriteNode.init(imageNamed: Assets.shotRed)
            ]
            
            for shipLaser in shots {
                shipLaser.position = CGPointMake(spaceship.position.x, shipLaser.size.height / 2 + spaceship.position.y)
                shipLaser.hidden = false
                shipLaser.removeAllActions()
                
                // setup physics
                shipLaser.physicsBody = SKPhysicsBody.init(texture: shipLaser.texture!, size: (shipLaser.texture?.size())!)
                shipLaser.physicsBody?.categoryBitMask = PhysicsCategory.laser
                shipLaser.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
                shipLaser.physicsBody?.collisionBitMask = 0
                shipLaser.physicsBody?.allowsRotation = false
                
                let remove = SKAction.removeFromParent()
                let seq = SKAction.sequence([SKAction.waitForDuration(5), remove])
                self.addChild(shipLaser)
                shipLaser.runAction(seq)
            }
            
            shots[0].physicsBody?.applyImpulse(CGVectorMake(1, 10))
            shots[1].physicsBody?.applyImpulse(CGVectorMake(0, 10))
            shots[2].physicsBody?.applyImpulse(CGVectorMake(-1, 10))
        }
    }
    
    func checkShip() {
        if spaceship.position.x >= CGRectGetMaxX(self.frame) - 30 {
            spaceship.position = CGPointMake(CGRectGetMaxX(self.frame) - 31 , spaceship.position.y)
            spaceship.physicsBody?.velocity = CGVectorMake(0, spaceship.physicsBody!.velocity.dy)
        } else if spaceship.position.x <= CGRectGetMinX(self.frame) + 30 {
            spaceship.position = CGPointMake(CGRectGetMinX(self.frame) + 31 , spaceship.position.y)
            spaceship.physicsBody?.velocity = CGVectorMake(0, spaceship.physicsBody!.velocity.dy)
        }
        
        if spaceship.position.y >= CGRectGetMaxY(self.frame) - distTOP {
            spaceship.position = CGPointMake(spaceship.position.x, CGRectGetMaxY(self.frame) - distTOP - 1)
            spaceship.physicsBody?.velocity = CGVectorMake((spaceship.physicsBody?.velocity.dx)!, 0)
        } else if spaceship.position.y <= CGRectGetMinY(self.frame) + 10 {
            spaceship.position = CGPointMake(spaceship.position.x ,CGRectGetMinY(self.frame) + 11)
            spaceship.physicsBody?.velocity = CGVectorMake(spaceship.physicsBody!.velocity.dx, 0)
        }
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
        
        let labelH = SKLabelNode.init(fontNamed: Assets.gameFont)
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
    
    func setScore() {
        var aux = score
        var count = 1
        while aux > 9 {
            aux /= 10
            count += 1
        }
        let first = CGRectGetMaxX(self.frame) * 0.9 - CGFloat(count * 9)
        let second = CGRectGetMaxY(self.frame) * 0.95
        LabelScore.position = CGPointMake(first, second);
        LabelScore.name = String(format: "Score: %d", arguments: [score])
    }
    
    func checkEndGame() {
        let cur = CACurrentMediaTime()
        if lives <= 0 {
            self.endTheScene(EndReason.Lose)
        } else if (cur >= gameOverTime) {
            self.endTheScene(EndReason.Win)
        }
    }
    
    func norm(x: CGFloat, y: CGFloat) -> CGFloat {
        return sqrt(x * x + y * y)
    }
}
