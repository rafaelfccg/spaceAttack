//
//  Coordinator.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 9/14/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import SpriteKit

protocol Explodable {
    func explode(_ scene: GameScene)
}

protocol Hitable {
    func hittedBy(_ node: SKNode?) -> Bool
}

protocol Lauchable {
    func lauch(scene: SKScene)
}

protocol Mode {
    var spaceship: Spaceship { get }
    func shoot()
    func hit() -> Bool
    func powerUp()
    func getSpeedBonus() -> Double
    func deactivate() -> Bool
    func activate()
}

protocol MovementPattern {
    var currDirection: CGVector { get set }
    func applyMovement(node: SKNode)
}

protocol PowerUp {
    func poweUp(_ ship: Spaceship)
}

protocol ShotManager {
    var nextLaserSpawn: Double { get }
    var shotInterval: Double { get }
    var shootDirection: CGVector{ get set }
    var target: UInt32 { get set }
    var category: UInt32 { get set }
    func shot(_ node: SKNode)
}
