//
//  GameScene.swift
//  Space Attack
//
//  Created by Miguel Araújo on 8/25/16.
//  Copyright (c) 2016 Miguel Araújo. All rights reserved.
//

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
    var multiplier = 1
    var lastHit: Double = 0
    var nextAsteroidSpawn = Double()
    var nextEnemySpawn = Double()
    var nextItemSpawn = Double()
    var gameOverTime = Double()
    var animaAst = SKAction()
    var labelScore = SKLabelNode()
    var restartLabel = SKLabelNode()
    var hud: HUD? = nil
    var spaceship = Spaceship()
    var asteroids: [Asteroid] = []
    var parallaxNodeBackgrounds: Parallax?
    var backgroundMusic = BackgroundMusicSingleton.getInstance()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init(size: CGSize) {
        super.init(size: size)
        
        // setup background color
        backgroundColor = SKColor.black
        
        // setup physics world
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        // setup label
        labelScore = SKLabelNode.init(fontNamed: Assets.gameFont)
        labelScore.name = "scoreLabel"
        labelScore.text = String(format: "Score: %@", arguments: [score])
        labelScore.position = CGPoint(x: frame.maxX * 0.9 - 25, y: frame.maxY * 0.95 - 5)
        labelScore.fontColor = UIColor.white
        labelScore.zPosition = 100
        
        // game background
        parallaxNodeBackgrounds = Parallax.init(withFile: Assets.space, imageRepetitions: 2, size: size, speed: 30, frameSize: size)
        parallaxNodeBackgrounds?.position = CGPoint(x: 0, y: 0)
        parallaxNodeBackgrounds?.zPosition = -10
        parallaxNodeBackgrounds?.name = "parallaxNode"
        addChild(parallaxNodeBackgrounds!)
        
        let randSecs = Double(Utils.random(30, max: 45))
        nextItemSpawn = randSecs + CACurrentMediaTime()
        nextEnemySpawn = 0
        
        // setup spaceship sprite
        spaceship.position = CGPoint(x: frame.midX, y: frame.maxY * 0.2)
        addChild(spaceship)
        
        // setup stars
        setUpEmmitters()
        hud = HUD(scene: self)
        hud?.setUp()
        
        start()
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
                self.spaceship.applyMovement(cropPositionPoint(pos), reposition: cropPositionPoint)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        for touch in touches {
            let pos = touch.location(in: self)
            let node = atPoint(pos)
            if node.name == NodeNames.callToActionLabel {
                restartGame()
            } else if !gameOver{
                spaceship.applyMovement(cropPositionPoint(pos),reposition: cropPositionPoint)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        parallaxNodeBackgrounds?.update(currentTime)
        checkShip()
        if !gameOver {
            doLauchables()
            spaceship.doLasers()
            checkEndGame()
        }
    }
    
    private func start() {
        let cur = CACurrentMediaTime()
        let randSecs = Double(Utils.random(10, max: 40))
        
        nextAsteroidSpawn = 0
        lives = 3
        score = 0
        gameOverTime = 180 + cur
        gameOver = false
        
        restartLabel.isHidden = false
        nextItemSpawn = cur + randSecs
        nextAsteroidSpawn = cur + 2.5
        setScore()
        
        spaceship.position = CGPoint(x: frame.midX, y: frame.maxY * 0.2)
        spaceship.restrictMovement(toFrame: frame)
        spaceship.isHidden = false
        
        hud?.setLives()
        
        addChild(labelScore)
    }
    
    func setUpEmmitters() {
        let point = CGPoint(x: frame.minX, y: frame.minY)
        let star1Emitter = loadEmitterNode(Assets.star1)
        star1Emitter?.position = point
        if star1Emitter != nil {
            addChild(star1Emitter!)
        }
        
        let star2Emitter = loadEmitterNode(Assets.star2)
        star2Emitter?.position = point
        if star2Emitter != nil {
            addChild(star2Emitter!)
        }
        
        let star3Emitter = loadEmitterNode(Assets.star3)
        star3Emitter?.position = point
        if star3Emitter != nil {
            addChild(star3Emitter!)
        }
    }
    
    func restartGame() {
        childNode(withName: NodeNames.callToActionLabel)?.safeRemoveFromParent()
        childNode(withName: NodeNames.endMessage)?.safeRemoveFromParent()
        childNode(withName: NodeNames.highScore)?.safeRemoveFromParent()
        labelScore.safeRemoveFromParent()
        enumerateChildNodes(withName: NodeNames.removable) { (node, stop) in
            node.safeRemoveFromParent()
        }

        multiplier = 1
        spaceship.speed = 1
        start()
    }
    
    func loadEmitterNode(_ emitterFileName: String) -> SKEmitterNode? {
        let emitterPath = Bundle.main.path(forResource: emitterFileName, ofType: "sks")
        let emitterNode:SKEmitterNode? = NSKeyedUnarchiver.unarchiveObject(withFile: emitterPath!) as? SKEmitterNode
        emitterNode?.particlePosition = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        emitterNode?.particlePositionRange = CGVector(dx: size.width, dy: size.height + 150)
        return emitterNode
    }
    
    func doLauchables() {
        let curTime = CACurrentMediaTime()
        
        if curTime > nextItemSpawn {
            let randSecs = Utils.random(15, max: 45)
            nextItemSpawn = curTime + Double(randSecs)
            let triLaserItem = TrilaserItem(scene: self)
            triLaserItem.name = NodeNames.removable
            addChild(triLaserItem)
            triLaserItem.lauch(scene: self)
        }
        
        if curTime > nextAsteroidSpawn {
            nextAsteroidSpawn = DificultyManager.sharedInstance.getNextAsteroidSpawn()
            let asteroid:Asteroid = Asteroid.init()
            asteroid.name = NodeNames.removable
            addChild(asteroid)
            asteroid.lauch(scene: self)
        }
        
        if curTime > nextEnemySpawn {
            nextEnemySpawn = Double(Utils.random(12, max: 20)) + curTime
            let xPosition = Utils.random(0, max: frame.maxX)
            let enemy = EnemyShip(scene: self)
            enemy.name = NodeNames.removable
            enemy.position = CGPoint(x: xPosition, y: frame.maxY)
            addChild(enemy)
        }
    }
    
    func cropPositionPoint(_ point: CGPoint) -> CGPoint {
        var pointRet: CGPoint = point
        if point.x >= frame.maxX - ScreenLimits.limitX {
            pointRet = CGPoint(x: frame.maxX - ScreenLimits.limitX - 1 , y: pointRet.y)
        } else if pointRet.x <= frame.minX + ScreenLimits.limitX {
            pointRet = CGPoint(x: frame.minX + ScreenLimits.limitX + 1 , y: pointRet.y)
        }
        
        if pointRet.y >= frame.maxY - ScreenLimits.distTOP {
            pointRet = CGPoint(x: pointRet.x, y: frame.maxY - ScreenLimits.distTOP - 1)
        } else if pointRet.y <= frame.minY + ScreenLimits.limitY {
            pointRet = CGPoint(x: pointRet.x ,y: frame.minY + ScreenLimits.limitY + 1)
        }
        
        return pointRet
        
    }
    
    func checkShip() {
        if !gameOver {
            multiplier = spaceship.getSpeed()
            hud?.setMultiplerValue(value: multiplier)
            DificultyManager.sharedInstance.multiplier = CGFloat(multiplier)
        }
    }
    
    func endTheScene(_ endReason: EndReason) {
        if (gameOver) {
            return
        }
        
        removeAllActions()
        spaceship.position = CGPoint(x: frame.midX, y: frame.maxY * 0.2)
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
        labelH.position = CGPoint(x: frame.size.width / 2, y: frame.size.height * 0.8)
        let color = SKColor.init(red: 0.807, green: 0.717, blue: 0.439, alpha: 1)
        labelH.fontColor = color
        addChild(labelH)
        
        var label = SKLabelNode()
        label = SKLabelNode.init(fontNamed: Assets.gameFont)
        label.name = NodeNames.endMessage
        label.text = message
        label.setScale(0.1)
        label.position = CGPoint(x: frame.size.width / 2, y: frame.size.height * 0.6)
        addChild(label)
        
        restartLabel = SKLabelNode.init(fontNamed: Assets.gameFont)
        restartLabel.name = NodeNames.callToActionLabel
        restartLabel.text = GameMessages.playAgain
        restartLabel.setScale(0.5)
        restartLabel.position = CGPoint(x: frame.size.width / 2, y: frame.size.height * 0.4)
        restartLabel.fontColor = color
        restartLabel.zPosition = 100
        addChild(restartLabel)
        
        let labelScaleAction = SKAction.scale(to: 1.0, duration: 0.5)
        restartLabel.run(labelScaleAction)
        label.run(labelScaleAction)
        labelH.run(labelScaleAction)
    }
    
    func setScore() {
        // count chars for number
        let count = String(score).characters.count
        
        let first = frame.maxX * 0.9 - CGFloat(count * 9)
        let second = frame.maxY * 0.95
        labelScore.position = CGPoint(x: first, y: second)
        labelScore.text = "Score: \(self.score)"
    }
    
    func addScore(value:Int) {
        score += value * multiplier
        setScore()
    }
    
    func checkEndGame() {
        let cur = CACurrentMediaTime()
        
        if lives <= 0 {
            endTheScene(EndReason.lose)
        } else if (cur >= gameOverTime) {
            endTheScene(EndReason.win)
        }
    }
}
