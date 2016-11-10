//
//  SKNode+SafeRemove.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 9/14/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import SpriteKit

extension SKNode {
    func safeRemoveFromParent() {
        removeAllActions()
        physicsBody?.categoryBitMask = 0
        physicsBody?.collisionBitMask = 0
        
        for child in children {
            child.safeRemoveFromParent()
        }
        
        removeFromParent()
    }
}
