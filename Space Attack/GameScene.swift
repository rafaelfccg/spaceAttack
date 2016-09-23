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
    
    private init() {
        playMusic(Resources.backgroundMusic, withFormat: "wav")
    }
    
    func playMusic(name: String, withFormat format:String) {
        let audioPath = NSBundle.mainBundle().pathForResource(name, ofType:format)
        let path = NSURL.init(fileURLWithPath: audioPath!)
        do{
            self.backgroundAudioPlayer = try AVAudioPlayer.init(contentsOfURL: path)
            self.backgroundAudioPlayer.prepareToPlay()
            self.backgroundAudioPlayer.numberOfLoops = -1
            self.backgroundAudioPlayer.volume = 1.0
            self.backgroundAudioPlayer.play()
        }catch _ {
            print("error `background music` not found")
        }
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    let kNumAsteroids = 10
    let kNumLasers = 25
    
    var OnTrilaser = Bool()
    var gameOver = Bool()
    var nextAsteroid = Int()
    var nextShipLaser = Int()
    var lives = 0
    var score = 0
    var nextAsteroidSpawn = Double()
    var nextItemSpawn = Double()
    var nextLaserSpawn = Double()
    var gameOverTime = Double()
    var last_hit = Double()
    var trilaserTime = Double()
    var ship_Speed = CGFloat()
    var shipLasers = [SKSpriteNode]()
    var asteroids = []
    
    var spaceship = Spaceship()
    var backgroundMusic = BackgroundMusicSingleton()
    var animaAst = SKAction()
    var LabelScore = SKLabelNode()
    var restartLabel = SKLabelNode()
    var parallaxNodeBackgrounds:Parallax?
    
    static func sceneFromFileNamed(fileNamed:String!)->GameScene?{
        let gameScene = GameScene.unarchiveFromFile(fileNamed) as? GameScene;
        gameScene?.initialize()
        return gameScene
    }
    
    func initialize() {
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
        self.parallaxNodeBackgrounds = Parallax.init(withFile: Assets.space, imageRepetitions: 2, size: size, speed: 30, frameSize: size)
        parallaxNodeBackgrounds?.position = CGPointMake(0, 0)
        parallaxNodeBackgrounds?.zPosition = -10;
        parallaxNodeBackgrounds?.name = "parallaxNode"
        self.addChild(parallaxNodeBackgrounds!)
        
        let randSecs = Utils.random(30, max: 45)
        nextItemSpawn = randSecs + CACurrentMediaTime()
        
        // setup spaceship sprite
        spaceship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) * 0.2)
        self.addChild(spaceship)
        ship_Speed = 0
        
        // setup stars
        self.setUpEmmitters()
        
        startTheGame()
    }
    
    func setUpEmmitters() {
        let point = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame))
        let star1Emitter = loadEmitterNode(Assets.star1)
        star1Emitter?.position = point;
        if star1Emitter != nil {
            self.addChild(star1Emitter!)
        }
        let star2Emitter = loadEmitterNode(Assets.star2)
        star2Emitter?.position = point;
        if star2Emitter != nil {
            self.addChild(star2Emitter!)
        }
        let star3Emitter = loadEmitterNode(Assets.star3)
        star3Emitter?.position = point;
        if star3Emitter != nil {
            self.addChild(star3Emitter!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    required override init(size: CGSize) {
        super.init(size: size)
        self.initialize()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        /* Called when a touch begins */
        for touch in touches {
            let pos = touch.locationInNode(self)
            let node = self.nodeAtPoint(pos)
            if node.name == NodeNames.callToActionLabel {
                restartGame()
            } else if !gameOver{
                self.spaceship.applyMovement(cropPositionPoint(pos), reposition:self.cropPositionPoint)
            }
            
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch in touches {
            let pos = touch.locationInNode(self)
            let node = self.nodeAtPoint(pos)
            if node.name == NodeNames.callToActionLabel {
                restartGame()
            } else if !gameOver{
                
                self.spaceship.applyMovement(cropPositionPoint(pos),reposition: self.cropPositionPoint)
            }
            
        }
    }
    
    func restartGame(){
        self.childNodeWithName(NodeNames.callToActionLabel)?.safeRemoveFromParent()
        self.childNodeWithName(NodeNames.endMessage)?.safeRemoveFromParent()
        self.childNodeWithName(NodeNames.highScore)?.safeRemoveFromParent()
        self.LabelScore.safeRemoveFromParent()
        
        self.startTheGame()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        self.checkShip()
        parallaxNodeBackgrounds?.update(currentTime)
        if !gameOver {
            self.doLauchables()
            spaceship.doLasers(self)
            self.checkEndGame()
            
        }
    }
    
    func loadEmitterNode(emitterFileName: String) -> SKEmitterNode? {
        let emitterPath = NSBundle.mainBundle().pathForResource(emitterFileName, ofType: "sks")
        let emitterNode:SKEmitterNode? = NSKeyedUnarchiver.unarchiveObjectWithFile(emitterPath!) as? SKEmitterNode
        
         emitterNode?.particlePosition = CGPointMake(self.size.width / 2.0, self.size.height / 2.0);
         emitterNode?.particlePositionRange = CGVectorMake(self.size.width, self.size.height + 150);
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
        
        let livesArr = [
            SKSpriteNode.init(imageNamed: Assets.spaceshipBgspeed),
            SKSpriteNode.init(imageNamed: Assets.spaceshipBgspeed),
            SKSpriteNode.init(imageNamed: Assets.spaceshipBgspeed)
        ]
        var count = 0
        let x = CGRectGetMinX(self.frame)
        let y = CGRectGetMinY(self.frame)
        
        for i in livesArr {
            i.xScale = 0.25
            i.yScale = 0.25
            let xL = CGFloat((x + CGFloat(2 * (count + 1)) * i.size.width)/2)
            let yL = CGFloat(y + i.size.height)
            i.position = CGPointMake(xL, yL)
            i.name = String(format: "L%d", arguments: [count])
            self.addChild(i)
            count += 1
        }
        
        self.addChild(LabelScore)
        self.backgroundMusic = BackgroundMusicSingleton()
    }
    
    func doLauchables() {
        let curTime = CACurrentMediaTime()
        
        if curTime > nextItemSpawn {
            let randSecs = 5.0 //Utils.random(15, max: 45)
            nextItemSpawn = curTime + randSecs
            let triLaserItem = TrilaserItem(scene: self)
            self.addChild(triLaserItem)
            triLaserItem.lauch();
            
        }
        
        if curTime > nextAsteroidSpawn {
            nextAsteroidSpawn = Utils.random(0.1, max: 0.8) + curTime
            let asteroid:Asteroid = Asteroid.init(scene: self)
            asteroid.name = "asteroid" + String(nextAsteroidSpawn)
            self.addChild(asteroid)
            asteroid.lauch()
        }
    }
    
    func cropPositionPoint(point:CGPoint) -> CGPoint{
        var pointRet:CGPoint = point;
        if point.x >= CGRectGetMaxX(self.frame) - ScreenLimits.limitX {
            pointRet = CGPointMake(CGRectGetMaxX(self.frame) - ScreenLimits.limitX - 1 , pointRet.y)
        } else if pointRet.x <= CGRectGetMinX(self.frame) + ScreenLimits.limitX {
            pointRet = CGPointMake(CGRectGetMinX(self.frame) + ScreenLimits.limitX + 1 , pointRet.y)
        }
        if pointRet.y >= CGRectGetMaxY(self.frame) - ScreenLimits.distTOP {
            pointRet = CGPointMake(pointRet.x, CGRectGetMaxY(self.frame) - ScreenLimits.distTOP - 1)
        } else if pointRet.y <= CGRectGetMinY(self.frame) + ScreenLimits.limitY {
            pointRet = CGPointMake(pointRet.x ,CGRectGetMinY(self.frame) + ScreenLimits.limitY + 1)
        }
        return pointRet
        
    }
    func checkShip() {
        let oldPos = self.spaceship.position;
        let newPos = cropPositionPoint(oldPos);
        
        self.spaceship.position = newPos
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
            message = GameMessages.win
        } else {
            message = GameMessages.lose
        }
        
        let labelH = SKLabelNode.init(fontNamed: Assets.gameFont)
        labelH.name = NodeNames.highScore
        
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
        label.name = NodeNames.endMessage
        label.text = message
        label.setScale(0.1)
        label.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height * 0.6)
        self.addChild(label)
        
        restartLabel = SKLabelNode.init(fontNamed: Assets.gameFont)
        restartLabel.name = NodeNames.callToActionLabel
        restartLabel.text = GameMessages.playAgain
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
        LabelScore.text = "Score: \(self.score)"
    }
    
    func checkEndGame() {
        let cur = CACurrentMediaTime()
        if lives <= 0 {
            self.endTheScene(EndReason.Lose)
        } else if (cur >= gameOverTime) {
            self.endTheScene(EndReason.Win)
        }
    }
}
