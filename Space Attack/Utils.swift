//
//  Utils.swift
//  Space Attack
//
//  Created by Miguel Araújo on 8/27/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import SpriteKit

public class Utils {
    static func random(min: Double, max: Double) -> Double {
        return Double( Double(arc4random())/Double(UINT32_MAX))*(max - min) + min;
    }
    
    static func removeAfter(time:NSTimeInterval) -> SKAction {
        return SKAction.sequence([SKAction.waitForDuration(time), SKAction.removeFromParent()])
    }
    
    static func norm(x: CGFloat, y: CGFloat) -> CGFloat {
        return sqrt(x * x + y * y)
    }
}