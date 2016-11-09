//
//  SKNode+SafeRemove.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 9/14/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import SpriteKit

extension SKNode {
    func safeRemoveFromParent(){
        self.removeAllActions()
        self.physicsBody?.categoryBitMask = 0
        self.physicsBody?.collisionBitMask = 0
        for child in self.children {
            child.safeRemoveFromParent()
        }
        self.removeFromParent()
    }
}
