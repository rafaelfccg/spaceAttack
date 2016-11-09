//
//  Constants.swift
//  Space Attack
//
//  Created by Miguel Araújo on 8/25/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import SpriteKit

struct BodyScales {
    static let laserScale: CGFloat = 0.8
}

struct PhysicsCategory {
    static let spaceship: UInt32 = 1 << 0
    static let asteroid: UInt32 = 1 << 1
    static let laser: UInt32 = 1 << 2
    static let enemyLaser: UInt32 = 1 << 3
    static let enemy: UInt32 = 1 << 4
    static let trilaser: UInt32 = 1 << 5
}

struct ScreenLimits {
    static let limitX: CGFloat = 15
    static let limitY: CGFloat = 10
    static let distTOP: CGFloat = 100
}

struct Resources {
    static let backgroundMusic = "background_music"
    static let explosionAsteroid = "explosion_asteroid"
    static let explosionEnemy = "explosion_enemy"
    static let explosionPlayer = "explosion_player"
    static let gameplayMusic = "gameplay_music"
    static let weaponEnemy = "weapon_enemy"
    static let weaponPlayer = "weapon_player"
}

struct GameMessages {
    static let win = "You Won!"
    static let lose = "You Lost!"
    static let playAgain = "Play Again?"
}

struct NodeNames {
    static let highScore = "HSLabel"
    static let endMessage = "endMessageLabel"
    static let callToActionLabel = "callToActionLabel"
    static let removable = "removable"
}

struct Assets {
    static let gameFont = "Futura-CondensedMedium"
    
    static let rock1 = "rock-1"
    static let rock2 = "rock-2"
    static let rock3 = "rock-3"
    static let rock4 = "rock-4"
    static let rock5 = "rock-5"
    static let rock6 = "rock-6"
    static let rock7 = "rock-7"
    static let rock8 = "rock-8"
    static let rock9 = "rock-9"
    static let rock10 = "rock-10"
    static let rock11 = "rock-11"
    static let rock12 = "rock-12"
    static let rock13 = "rock-13"
    static let rock14 = "rock-14"
    static let rock15 = "rock-15"
    
    static let shotBlueLong = "shot-blue-long"
    static let shotBlue = "shot-blue"
    static let shotRedLong = "shot-red-long"
    static let shotRed = "shot-red"
    
    static let space = "space"
    
    static let spaceshipBgbattle = "spaceship-bgbattle"
    static let spaceshipBgspeed = "spaceship-bgspeed"
    static let spaceshipBgspeed2 = "spaceship-bgspeed2"
    static let spaceshipDrakir1 = "spaceship-drakir1"
    static let spaceshipDrakir2 = "spaceship-drakir2"
    static let spaceshipDrakir3 = "spaceship-drakir3"
    static let spaceshipDrakir4 = "spaceship-drakir4"
    static let spaceshipDrakir5 = "spaceship-drakir5"
    static let spaceshipDrakir6 = "spaceship-drakir6"
    static let spaceshipDrakir7 = "spaceship-drakir7"
    static let spaceshipFreighterspr = "spaceship-freighterspr"
    static let spaceshipHeavyfreighter = "spaceship-heavyfreighter"
    static let spaceshipMedfighter = "spaceship-medfighter"
    static let spaceshipMedfrighter = "spaceship-medfrighter"
    static let spaceshipSpeed = "spaceship-speed"
    static let spaceshipSsp = "spaceship-ssp"
    static let spaceshipXspr5 = "spaceship-xspr5"
    
    static let spark = "spark"
    
    static let star1 = "stars1"
    static let star2 = "stars2"
    static let star3 = "stars3"
}
