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
    var lastUpdatedTime:NSTimeInterval = 0
    var deltaTime:NSTimeInterval = 0
    
    
    init(withFile:String, imageRepetitions:Int, size:CGSize, speed:CGFloat,frameSize:CGSize) {
        self.parallaxSpeed = speed
        self.imageCount = CGFloat(imageRepetitions)
        self.backgrounds = []
        self.frameSize = frameSize
        super.init()
        for i in 1...imageRepetitions {
            let node = SKSpriteNode(imageNamed: withFile);
            node.size = size
            node.anchorPoint = CGPointZero
            node.position = CGPointMake(0, size.height*CGFloat(i))
            self.backgrounds.append(node)
            self.addChild(node)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(currentTime:NSTimeInterval){
        if self.lastUpdatedTime <= 0 {
            self.deltaTime = currentTime - self.lastUpdatedTime
        }else {
            self.deltaTime = 0
        }
        self.lastUpdatedTime = currentTime
        CGPointMake(0, -self.parallaxSpeed)
        let movement = CGPointMake(0, -self.parallaxSpeed * CGFloat(self.deltaTime))
        self.position = CGPointMake(self.position.x + movement.x, self.position.y+movement.y)
        let backgroundScreen = self.parent;
        for backgroundNode in self.backgrounds{
            let screenPos = self.convertPoint(backgroundNode.position, toNode: backgroundScreen!)
            if screenPos.y <= -backgroundNode.size.height {
                backgroundNode.position = CGPointMake(backgroundNode.position.x, backgroundNode.size.height * self.imageCount + backgroundNode.position.y)
            }
        }
        
    }
}

