//
//  HUD.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 10/2/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import SpriteKit

class HUD: AnyObject {
    var shootModeButton:SKShapeNode;
    var shieldModeButton:SKShapeNode;
    var propulsorModeButton:SKShapeNode;
    var scene:SKScene
    init(scene:SKScene) {
        self.scene = scene
        let butWidth = self.scene.size.width/3;
        let butHeight = self.scene.size.height * 0.1
        let sizeBut = CGSize(width: butWidth, height: butHeight)
        shootModeButton = ModeButton(rectOfSize: sizeBut, mode:ShipModes.shooter)
        shieldModeButton = ModeButton(rectOfSize: sizeBut, mode:ShipModes.shield)
        propulsorModeButton = ModeButton(rectOfSize: sizeBut, mode:ShipModes.propulsor)
    }
    func setUp() {
        var offSetX = self.shootModeButton.frame.width/2
        let offSetY = self.shootModeButton.frame.height/2
        
        self.scene.addChild(shootModeButton)
        shootModeButton.position = CGPoint(x: offSetX, y: offSetY)
        offSetX += self.shootModeButton.frame.width
        
        self.scene.addChild(shieldModeButton)
        shieldModeButton.position = CGPoint(x: offSetX, y: offSetY)
        offSetX += self.shieldModeButton.frame.width
        
        self.scene.addChild(propulsorModeButton)
        propulsorModeButton.position = CGPoint(x: offSetX, y: offSetY)
        
        shootModeButton.fillColor = UIColor.red
        propulsorModeButton.fillColor = UIColor.yellow
        shieldModeButton.fillColor = UIColor.blue
    }
    func checkHUDTouch() -> Bool {
        
        return false
    }
}
