//
//  ParallaxNode.swift
//  Space Attack
//
//  Created by Miguel Araújo on 8/27/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import SpriteKit

class Parallax: SKNode {
  var lastUpdatedTime: TimeInterval = 0
  var deltaTime: TimeInterval = 0
  var parallaxSpeed: CGFloat
  var imageCount: CGFloat
  var backgrounds: [SKSpriteNode]
  var frameSize: CGSize
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(withFile: String, imageRepetitions: Int, size: CGSize, speed: CGFloat, frameSize: CGSize) {
    parallaxSpeed = speed
    imageCount = CGFloat(imageRepetitions)
    backgrounds = []
    self.frameSize = frameSize
    super.init()
    
    for i in 0...(imageRepetitions - 1) {
      let node = SKSpriteNode(imageNamed: withFile)
      node.size = size
      node.anchorPoint = CGPoint.zero
      node.position = CGPoint(x: 0, y: size.height * CGFloat(i))
      node.name = "p" + String(i)
      backgrounds.append(node)
      addChild(node)
    }
  }
  
  func update(_ currentTime: TimeInterval) {
    if lastUpdatedTime <= 0 {
      deltaTime = 0
    } else {
      deltaTime = currentTime - lastUpdatedTime
    }
    
    lastUpdatedTime = currentTime
    
    let movement = CGPoint(x: 0, y: -parallaxSpeed * CGFloat(deltaTime))
    position = CGPoint(x: position.x + movement.x, y: position.y+movement.y)
    let backgroundScreen = parent
    
    for backgroundNode in backgrounds {
      let screenPos = convert(backgroundNode.position, to: backgroundScreen!)
      if screenPos.y <= -backgroundNode.size.height {
        backgroundNode.position = CGPoint(x: backgroundNode.position.x, y:
          backgroundNode.size.height * self.imageCount + backgroundNode.position.y)
      }
    }
    
  }
}

