//
//  SKAction+Extention.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 10/26/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import SpriteKit

extension SKAction {
  // TODO unused method. Remove later!
  static func oscillation(amplitude a: CGFloat, timePeriod t: CGFloat, midPoint: CGPoint) -> SKAction {
    let action = SKAction.customAction(withDuration: Double(t)) { node, currentTime in
      let displacement = a * sin(2 * CGFloat(M_PI) * currentTime / t)
      node.position.x = midPoint.x + displacement
    }
    
    return action
  }
}
