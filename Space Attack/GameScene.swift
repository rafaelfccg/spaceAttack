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
    case win
    case lose
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameOver = Bool()
    var lives = 0
    var score = 0
    var last_hit:Double = 0
    var nextAsteroidSpawn = Double()
    var nextEnemySpawn = Double()
    var nextItemSpawn = Double()
    var gameOverTime = Double()
    var asteroids:[Asteroid] = []
    var multiplier = 1
    
    var spaceship = Spaceship()
    var hud:HUD? = nil
    var backgroundMusic = BackgroundMusicSingleton.getInstance()
    var animaAst = SKAction()
    var LabelScore = SKLabelNode()
    var restartLabel = SKLabelNode()
    var parallaxNodeBackgrounds:Parallax?
    var enemy:EnemyShip?
    
    static func sceneFromFileNamed(_ fileNamed:String!)->GameScene?{
        let gameScene = GameScene.unarchiveFromFile(fileNamed) as? GameScene;
        gameScene?.initialize()
        return gameScene
    }
    
    func initialize() {
        // setup background color
        self.backgroundColor = SKColor.black
        // setup physics world
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        // setup label
        self.LabelScore = SKLabelNode.init(fontNamed: Assets.gameFont)
        self.LabelScore.name = "scoreLabel"
        self.LabelScore.text = String(format: "Score: %@", arguments: [score])
        self.LabelScore.position = CGPoint(x: self.frame.maxX * 0.9 - 25, y: self.frame.maxY * 0.95 - 5)
        self.LabelScore.fontColor = UIColor.white
        self.LabelScore.zPosition = 100
        
        // game backgorund
        self.parallaxNodeBackgrounds = Parallax.init(withFile: Assets.space, imageRepetitions: 2, size: size, speed: 30, frameSize: size)
        parallaxNodeBackgrounds?.position = CGPoint(x: 0, y: 0)
        parallaxNodeBackgrounds?.zPosition = -10;
        parallaxNodeBackgrounds?.name = "parallaxNode"
        self.addChild(parallaxNodeBackgrounds!)
        
        let randSecs = Utils.random(30, max: 45)
        nextItemSpawn = randSecs + CACurrentMediaTime()
        nextEnemySpawn = 0
        // setup spaceship sprite
        spaceship.position = CGPoint(x: self.frame.midX, y: self.frame.maxY * 0.2)
        self.addChild(spaceship)
        
        // setup stars
        self.setUpEmmitters()
        self.hud = HUD(scene: self)
        self.hud?.setUp()
        
        startTheGame()
    }
    
    func setUpEmmitters() {
        let point = CGPoint(x: self.frame.minX, y: self.frame.minY)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        /* Called when a touch begins */
        for touch in touches {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            if node.name == NodeNames.callToActionLabel {
                restartGame()
            } else if let modeBut = node as? ModeButton{
                _ = self.spaceship.setMode(mode: modeBut.mode)
            } else if !gameOver{
                self.spaceship.applyMovement(cropPositionPoint(pos), reposition:self.cropPositionPoint)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        for touch in touches {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            if node.name == NodeNames.callToActionLabel {
                restartGame()
            } else if !gameOver{
                
                self.spaceship.applyMovement(cropPositionPoint(pos),reposition: self.cropPositionPoint)
            }
        }
    }
    
    func restartGame(){
        self.childNode(withName: NodeNames.callToActionLabel)?.safeRemoveFromParent()
        self.childNode(withName: NodeNames.endMessage)?.safeRemoveFromParent()
        self.childNode(withName: NodeNames.highScore)?.safeRemoveFromParent()
        self.LabelScore.safeRemoveFromParent()        
        self.startTheGame()
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        parallaxNodeBackgrounds?.update(currentTime)
        self.checkShip()
        if !gameOver {
            self.doLauchables()
            spaceship.doLasers()
            self.checkEndGame()
            
        }
    }
    
    func loadEmitterNode(_ emitterFileName: String) -> SKEmitterNode? {
        let emitterPath = Bundle.main.path(forResource: emitterFileName, ofType: "sks")
        let emitterNode:SKEmitterNode? = NSKeyedUnarchiver.unarchiveObject(withFile: emitterPath!) as? SKEmitterNode
        
         emitterNode?.particlePosition = CGPoint(x: self.size.width / 2.0, y: self.size.height / 2.0);
         emitterNode?.particlePositionRange = CGVector(dx: self.size.width, dy: self.size.height + 150);
         return emitterNode
    }
    
    func startTheGame() {
        let cur = CACurrentMediaTime()
        
        nextAsteroidSpawn = 0
        lives = 3
        score = 0
        gameOverTime = 180 + cur
        gameOver = false
        
        restartLabel.isHidden = false
        let randSecs = Utils.random(10, max: 40)
        nextItemSpawn = cur + randSecs
        nextAsteroidSpawn = cur + 2.5
        setScore()
        
        spaceship.position = CGPoint(x: self.frame.midX, y: self.frame.maxY * 0.2)
        spaceship.restrictMovement(toFrame: self.frame)
        spaceship.isHidden = false
        
        self.addChild(LabelScore)
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
        
        if curTime > nextEnemySpawn {
            nextEnemySpawn = Utils.random(5, max: 10) + curTime
            self.enemy = EnemyShip(scene:self)
            //enemy.name = "asteroid" + String(nextAsteroidSpawn)
            self.enemy?.position = CGPoint(x: self.frame.midX, y: self.frame.maxY);
            self.addChild(self.enemy!)
            
        }
    }
    
    func cropPositionPoint(_ point:CGPoint) -> CGPoint{
        var pointRet:CGPoint = point;
        if point.x >= self.frame.maxX - ScreenLimits.limitX {
            pointRet = CGPoint(x: self.frame.maxX - ScreenLimits.limitX - 1 , y: pointRet.y)
        } else if pointRet.x <= self.frame.minX + ScreenLimits.limitX {
            pointRet = CGPoint(x: self.frame.minX + ScreenLimits.limitX + 1 , y: pointRet.y)
        }
        if pointRet.y >= self.frame.maxY - ScreenLimits.distTOP {
            pointRet = CGPoint(x: pointRet.x, y: self.frame.maxY - ScreenLimits.distTOP - 1)
        } else if pointRet.y <= self.frame.minY + ScreenLimits.limitY {
            pointRet = CGPoint(x: pointRet.x ,y: self.frame.minY + ScreenLimits.limitY + 1)
        }
        return pointRet
        
    }
    
    func checkShip() {
        if !gameOver {
            self.multiplier = self.spaceship.getSpeed()
            self.hud?.setMultiplerValue(value: self.multiplier)
        }
    }
    
    func endTheScene(_ endReason: EndReason) {
        if (gameOver) {
            return
        }
        
        self.removeAllActions()
        
        spaceship.position = CGPoint(x: self.frame.midX, y: self.frame.maxY * 0.2)
        spaceship.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        gameOver = true
        
        var message = String()
        if (endReason == EndReason.win) {
            message = GameMessages.win
        } else {
            message = GameMessages.lose
        }
        
        let labelH = SKLabelNode.init(fontNamed: Assets.gameFont)
        labelH.name = NodeNames.highScore
        
        let n = UserDefaults.standard
        var val = n.integer(forKey: "HS")
        
        if (score > val) {
            n.set(score, forKey: "HS")
            val = score
        }
        
        labelH.text = String.init(format: "High Score: %ld", arguments: [val])
        labelH.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height * 0.8)
        let color = SKColor.init(red: 0.807, green: 0.717, blue: 0.439, alpha: 1)
        labelH.fontColor = color
        self.addChild(labelH)
        
        var label = SKLabelNode()
        label = SKLabelNode.init(fontNamed: Assets.gameFont)
        label.name = NodeNames.endMessage
        label.text = message
        label.setScale(0.1)
        label.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height * 0.6)
        self.addChild(label)
        
        restartLabel = SKLabelNode.init(fontNamed: Assets.gameFont)
        restartLabel.name = NodeNames.callToActionLabel
        restartLabel.text = GameMessages.playAgain
        restartLabel.setScale(0.5)
        restartLabel.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height * 0.4)
        restartLabel.fontColor = color
        restartLabel.zPosition = 100
        self.addChild(restartLabel)
        
        let labelScaleAction = SKAction.scale(to: 1.0, duration: 0.5)
        restartLabel.run(labelScaleAction)
        label.run(labelScaleAction)
        labelH.run(labelScaleAction)
    }
    
    func setScore() {
        let count = Utils.countCharsForNumber(number: score)
        let first = self.frame.maxX * 0.9 - CGFloat(count * 9)
        let second = self.frame.maxY * 0.95
        LabelScore.position = CGPoint(x: first, y: second);
        LabelScore.text = "Score: \(self.score)"
    }
    
    func addScore(value:Int) {
        self.score += value * multiplier;
        setScore()
    }
    
    func checkEndGame() {
        let cur = CACurrentMediaTime()
        if lives <= 0 {
            self.endTheScene(EndReason.lose)
        } else if (cur >= gameOverTime) {
            self.endTheScene(EndReason.win)
        }
    }
}
