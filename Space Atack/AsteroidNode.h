//
//  AsteroidNode.h
//  Space Atack
//
//  Created by Rafael Gouveia on 8/16/16.
//  Copyright © 2016 Mini Challenge 2. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface AsteroidNode : SKSpriteNode
//Fazer isso ser um construtor mais pra frente.
+(void)spawnAsteroid:(SKScene*)scene animation:(SKAction *)animation;

@end
