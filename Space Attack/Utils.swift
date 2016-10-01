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
    static func random(_ min: Double, max: Double) -> Double {
        return Double( Double(arc4random())/Double(UINT32_MAX))*(max - min) + min;
    }
    
    static func removeAfter(_ time:TimeInterval) -> SKAction {
        return SKAction.sequence([SKAction.wait(forDuration: time), SKAction.removeFromParent()])
    }
    
    static func norm(_ x: CGFloat, y: CGFloat) -> CGFloat {
        return sqrt(x * x + y * y)
    }
    
    static func getRootNode(node:SKNode)->SKNode{
        var sceneNode = node
        while let parent = sceneNode.parent {
            sceneNode = parent
        }
        return sceneNode
    }
}
