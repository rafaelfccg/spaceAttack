//
//  AsteroidNode.m
//  Space Atack
//
//  Created by Rafael Gouveia on 8/16/16.
//  Copyright © 2016 Mini Challenge 2. All rights reserved.
//

#import "AsteroidNode.h"
#import "Utils.h"
#import "Constants.h"

static double _nextAsteroidSpawn = 0;

@implementation AsteroidNode

+(void)spawnAsteroid:(SKScene*)scene animation:(SKAction *)animation
{
    double curTime = CACurrentMediaTime();
    if (curTime > _nextAsteroidSpawn) {
        //NSLog(@"spawning new asteroid");
        float randSecs = [Utils randomValueBetween:0.10 andValue:0.80];
        _nextAsteroidSpawn = randSecs + curTime;
        
        float randX = [Utils randomValueBetween:0.0 andValue:scene.frame.size.width];
        float randDuration = [Utils randomValueBetween:4.0 andValue:10.0];
        
        SKSpriteNode *asteroid = [SKSpriteNode spriteNodeWithImageNamed:@"A1"];
        [asteroid setXScale:0.8];
        [asteroid setYScale:0.8];
        asteroid.position = CGPointMake(randX,CGRectGetMaxY(scene.frame));
        asteroid.hidden = NO;
        
        asteroid.physicsBody = [SKPhysicsBody bodyWithTexture:asteroid.texture size:asteroid.texture.size];
        asteroid.physicsBody.categoryBitMask = asteroidCategory;
        asteroid.physicsBody.contactTestBitMask = shipCategory| laserCategory;
        asteroid.physicsBody.collisionBitMask = shipCategory;
        asteroid.physicsBody.allowsRotation =NO;
        SKAction* remove = [SKAction removeFromParent];
        SKAction* seq = [SKAction sequence:@[[SKAction waitForDuration:15],remove]];
        [scene addChild:asteroid];
        // CGPoint location = CGPointMake(randX, -self.frame.size.height-asteroid.size.height);
        [asteroid runAction:seq];
        [asteroid runAction:animation withKey:@"asteroidAnima"];
        [asteroid.physicsBody applyImpulse:CGVectorMake(0, -randDuration)];
    }

}

@end
