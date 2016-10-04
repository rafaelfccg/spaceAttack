//
//  ModeButton.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 10/4/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import SpriteKit

class ModeButton: SKShapeNode {
    
    var mode:ShipModes = ShipModes.shooter
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(rectOfSize: CGSize, mode:ShipModes) {
        super.init()
        let rect = CGRect(origin: CGPoint(x:-rectOfSize.width/2,y:-rectOfSize.height/2), size: rectOfSize)
        self.path = CGPath(rect: rect, transform: nil)
        self.mode = mode
    }
}
