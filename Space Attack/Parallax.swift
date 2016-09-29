//
//  ParallaxNode.swift
//  Space Attack
//
//  Created by Miguel Araújo on 8/27/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import SpriteKit

class Parallax: SKNode {
    
    var parallaxSpeed:CGFloat
    var imageCount:CGFloat
    var backgrounds:[SKSpriteNode]
    var frameSize:CGSize
    var lastUpdatedTime:TimeInterval = 0
    var deltaTime:TimeInterval = 0
    
    
    init(withFile:String, imageRepetitions:Int, size:CGSize, speed:CGFloat,frameSize:CGSize) {
        self.parallaxSpeed = speed
        self.imageCount = CGFloat(imageRepetitions)
        self.backgrounds = []
        self.frameSize = frameSize
        super.init()
        for i in 0...(imageRepetitions-1) {
            let node = SKSpriteNode(imageNamed: withFile);
            node.size = size
            node.anchorPoint = CGPoint.zero
            node.position = CGPoint(x: 0, y: size.height*CGFloat(i))
            node.name = "p"+String(i)
            self.backgrounds.append(node)
            self.addChild(node)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ currentTime:TimeInterval){
        if self.lastUpdatedTime <= 0 {
            self.deltaTime = 0
        }else {
            self.deltaTime = currentTime - self.lastUpdatedTime
        }
        self.lastUpdatedTime = currentTime

        let movement = CGPoint(x: 0, y: -self.parallaxSpeed * CGFloat(self.deltaTime))
        self.position = CGPoint(x: self.position.x + movement.x, y: self.position.y+movement.y)
        let backgroundScreen = self.parent;
        for backgroundNode in self.backgrounds{
            let screenPos = self.convert(backgroundNode.position, to: backgroundScreen!)
            if screenPos.y <= -backgroundNode.size.height {
                backgroundNode.position = CGPoint(x: backgroundNode.position.x, y: backgroundNode.size.height * self.imageCount + backgroundNode.position.y)
            }
        }
        
    }
}

