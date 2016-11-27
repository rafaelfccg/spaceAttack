//
//  Utils.swift
//  Space Attack
//
//  Created by Miguel Araújo on 8/27/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import SpriteKit

open class Utils {
  static func random(_ min: CGFloat, max: CGFloat) -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * (max - min) + min
  }
  
  static func removeAfter(_ time: TimeInterval) -> SKAction {
    return SKAction.sequence([SKAction.wait(forDuration: time), SKAction.removeFromParent()])
  }
  
  static func norm(_ x: CGFloat, y: CGFloat) -> CGFloat {
    return sqrt(x * x + y * y)
  }
  
  static func getRootNode(node: SKNode) -> SKNode {
    var sceneNode = node
    while let parent = sceneNode.parent {
      sceneNode = parent
    }
    
    return sceneNode
  }
  
  static func rotateVector(vector: CGVector, byAngle angle: CGFloat) -> CGVector {
    let x = CGFloat(vector.dx * cos(angle) - vector.dy * sin(angle))
    let y = CGFloat(vector.dy * cos(angle) + vector.dx * sin(angle))
    return CGVector(dx: x, dy: y)
  }
  
  static func scaleVector(vector: CGVector, byScale scale: CGFloat) -> CGVector {
    return CGVector(dx: vector.dx * scale, dy: vector.dy * scale)
  }
}
