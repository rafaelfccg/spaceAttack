//
//  HUD.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 10/2/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import SpriteKit

class HUD: AnyObject {
    let charFont32Size = 9
    let butHeight: CGFloat = 0.08
    let uiZPositon: CGFloat = 100
    let topPosition: CGFloat = 0.95
    
    var score = 0
    var shootModeButton: SKShapeNode
    var shieldModeButton: SKShapeNode
    var propulsorModeButton: SKShapeNode
    var multiplierLabel = SKLabelNode()
    var labelScore = SKLabelNode()
    var scene: SKScene
    
    init(scene: SKScene) {
        self.scene = scene
        let butWidth = self.scene.size.width / 3
        let butHeight = self.scene.size.height * self.butHeight
        let sizeBut = CGSize(width: butWidth, height: butHeight)
        
        shootModeButton = ModeButton(rectOfSize: sizeBut, mode:ShipModes.shooter)
        shieldModeButton = ModeButton(rectOfSize: sizeBut, mode:ShipModes.shield)
        propulsorModeButton = ModeButton(rectOfSize: sizeBut, mode:ShipModes.propulsor)
        multiplierLabel = SKLabelNode(fontNamed: Assets.gameFont)
        
        // setup label
        labelScore = SKLabelNode.init(fontNamed: Assets.gameFont)
        labelScore.name = "scoreLabel"
        labelScore.text = String(format: "Score: %@", arguments: [score])
        labelScore.position = CGPoint(x: scene.frame.maxX * 0.9 - 25, y: scene.frame.maxY * 0.95 - 5)
        labelScore.fontColor = UIColor.white
        labelScore.zPosition = 100
        scene.addChild(labelScore)
        
        setModeButtons()
        setLives()
        setMultiplierNode()
    }
    
    func checkHUDTouch() -> Bool {
        return false
    }
    
    func setMultiplierNode() {
        let x = scene.frame.midX
        let y = scene.frame.maxY
        
        scene.addChild(self.multiplierLabel)
        self.multiplierLabel.position = CGPoint(x: x, y: y * self.topPosition)
        self.multiplierLabel.zPosition = self.uiZPositon
        setMultiplerValue(value: 1)
    }
    
    func setMultiplerValue(value:Int) {
        self.multiplierLabel.text = String(format:"x%d", value)
        
        // count chars for value
        let count = String(value).characters.count
        let currPos = self.multiplierLabel.position
        let x = scene.frame.midX - CGFloat(count/2 * charFont32Size)
        self.multiplierLabel.position = CGPoint(x: x, y: currPos.y)
    }
    
    func setScore() {
        // count chars for number
        let count = String(score).characters.count
        
        let first = scene.frame.maxX * 0.9 - CGFloat(count * 9)
        let second = scene.frame.maxY * 0.95
        labelScore.position = CGPoint(x: first, y: second)
        labelScore.text = "Score: \(score)"
    }
    
    func addScore(value: Int, multiplier: Int) {
        score += value * multiplier
        setScore()
    }
    
    private func updateScore(val: Int) {
        if score > val {
            
        }
    }
    
    func setModeButtons() {
        var offSetX = self.shootModeButton.frame.width/2
        let offSetY = self.shootModeButton.frame.height/2
        
        self.scene.addChild(shootModeButton)
        shootModeButton.position = CGPoint(x: offSetX, y: offSetY)
        offSetX += self.shootModeButton.frame.width
        
        self.scene.addChild(shieldModeButton)
        shieldModeButton.position = CGPoint(x: offSetX, y: offSetY)
        offSetX += self.shieldModeButton.frame.width
        
        self.scene.addChild(propulsorModeButton)
        propulsorModeButton.position = CGPoint(x: offSetX, y: offSetY)
        
        shootModeButton.fillColor = UIColor.red
        propulsorModeButton.fillColor = UIColor.yellow
        shieldModeButton.fillColor = UIColor.blue
    }
    
    func setLives() {
        let livesArr = [
            SKSpriteNode.init(imageNamed: Assets.spaceshipBgspeed),
            SKSpriteNode.init(imageNamed: Assets.spaceshipBgspeed),
            SKSpriteNode.init(imageNamed: Assets.spaceshipBgspeed)
        ]
        
        var count = 0
        let x = scene.frame.minX
        let y = scene.frame.maxY
        
        for i in livesArr {
            i.xScale = 0.20
            i.yScale = 0.20
            let xL = CGFloat((x + CGFloat(2 * (count + 1)) * i.size.width)/2)
            let yL = CGFloat(y - i.size.height)
            i.position = CGPoint(x: xL, y: yL)
            i.name = String(format: "L%d", arguments: [count])
            scene.addChild(i)
            count += 1
        }
    }
}
