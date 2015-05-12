//
//  GameScene.m
//  Space Atack
//
//  Created by Rafael Gouveia on 5/11/15.
//  Copyright (c) 2015 Mini Challenge 2. All rights reserved.
//

#import "GameScene.h"
#define kNumAsteroids   10
#define kNumLasers      10



@implementation GameScene{
    SKSpriteNode * _ship;
    FMMParallaxNode *_parallaxNodeBackgrounds;
    FMMParallaxNode *_parallaxSpaceDust;
    CGFloat _ship_Speed;
    CGPoint initMove;
    NSMutableArray *_asteroids;
    int _nextAsteroid;
    double _nextAsteroidSpawn;
    
    int _nextShipLaser;
    NSMutableArray *_shipLasers;
    double  _nextLaserSpawn;
    
}

static  CGFloat thrust = 0.12;
-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
   
}




-(id)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        /* Setup your scene here */
        //2
        NSLog(@"SKScene:initWithSize %f x %f",size.width,size.height);
        
        //3
        self.backgroundColor = [SKColor blackColor];
        
#pragma mark - TBD - Game Backgrounds
        
       /* NSArray *parallaxBackgroundNames = @[@"P1",@"P2",@"P4",@"P1"];
        CGSize planetSizes = CGSizeMake(100.0, 100.0);
        //2
        _parallaxNodeBackgrounds = [[FMMParallaxNode alloc] initWithBackgrounds:parallaxBackgroundNames
                                                                           size:planetSizes
                                                           pointsPerSecondSpeed:70.0
                                                                      frameSize:size];
        //3
        _parallaxNodeBackgrounds.position = CGPointMake(size.width/2.0, size.height/2.0);
        //4
        [_parallaxNodeBackgrounds randomizeNodesPositions];*/
        
        //5
       // parallaxBackgroundNames.
        
        
        //6
        NSArray *parallaxBackground2Names = @[@"SpaceBack",@"SpaceBack"];
        _parallaxSpaceDust = [[FMMParallaxNode alloc] initWithBackgrounds:parallaxBackground2Names
                                                                     size:size
                                                     pointsPerSecondSpeed:25.0
                                                                frameSize:size];
        _parallaxSpaceDust.position = CGPointMake(0, 0);
        /*_parallaxSpaceDust.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
        _parallaxSpaceDust.physicsBody.affectedByGravity = NO;
        _parallaxSpaceDust.physicsBody.dynamic = NO;
        _parallaxSpaceDust.physicsBody .mass = 0.02;*/
        
        //_parallaxSpaceDust.physicsBody.
        [self addChild:_parallaxSpaceDust];
        //[self addChild:_parallaxNodeBackgrounds];
        
#pragma mark - Setup Sprite for the ship
        //Create space sprite, setup position on left edge centered on the screen, and add to Scene
        //4
        _ship = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        _ship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        _ship.xScale = 0.2;
        _ship.yScale =0.2;
        _ship.physicsBody = [SKPhysicsBody bodyWithTexture:_ship.texture  size:_ship.texture.size];
        _ship.physicsBody.affectedByGravity = NO;
        _ship.physicsBody.allowsRotation = NO;
        _ship.physicsBody.friction = 0.05;
        [self addChild:_ship];
        _ship_Speed = 0;
        
#pragma mark - TBD - Setup the asteroids

        _asteroids = [[NSMutableArray alloc] initWithCapacity:kNumAsteroids];
        for (int i = 0; i < kNumAsteroids; ++i) {
            SKSpriteNode *asteroid = [SKSpriteNode spriteNodeWithImageNamed:@"Asteroid1"];
            asteroid.hidden = YES;
            [asteroid setXScale:0.5];
            [asteroid setYScale:0.5];
            [_asteroids addObject:asteroid];
            [self addChild:asteroid];
        }
#pragma mark - TBD - Setup the lasers
        _shipLasers = [[NSMutableArray alloc] initWithCapacity:kNumLasers];
        for (int i = 0; i < kNumLasers; ++i) {
            SKSpriteNode *shipLaser = [SKSpriteNode spriteNodeWithImageNamed:@"SBlueShot"];
            shipLaser.hidden = YES;
            [_shipLasers addObject:shipLaser];
            [self addChild:shipLaser];
        }
#pragma mark - TBD - Setup the Accelerometer to move the ship
        
#pragma mark - TBD - Setup the stars to appear as particles
        [self addChild:[self loadEmitterNode:@"stars1"]];
        //[self addChild:[self loadEmitterNode:@"P2"]];
        //[self addChild:[self loadEmitterNode:@"P4"]];
        
#pragma mark - TBD - Start the actual game
        [self startTheGame];
    }
    return self;
}
- (float)randomValueBetween:(float)low andValue:(float)high {
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}
- (SKEmitterNode *)loadEmitterNode:(NSString *)emitterFileName
{
    NSString *emitterPath = [[NSBundle mainBundle] pathForResource:emitterFileName ofType:@"sks"];
    SKEmitterNode *emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
    
    //do some view specific tweaks
    emitterNode.particlePosition = CGPointMake(self.size.width/2.0, self.size.height/2.0);
    emitterNode.particlePositionRange = CGVectorMake(self.size.width, self.size.height+150);
    
    return emitterNode;
}
- (void)startTheGame
{
    _nextAsteroidSpawn = 0;
    
    for (SKSpriteNode *asteroid in _asteroids) {
        asteroid.hidden = YES;
    }
    _ship.hidden = NO;_ship_Speed = 0;
    for (SKSpriteNode *laser in _shipLasers) {
        laser.hidden = YES;
    }
    //reset ship position for new game
    //_ship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame)+_ship.size.height);
    
    //setup to handle accelerometer readings using CoreMotion Framework
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        CGPoint pos = [touch locationInNode:self];
        initMove = pos;
        //thrust = [self normX:fabs(pos.x - _ship.position.x) YVal:fabs(pos.y - _ship.position.y)];
        
       // CGVector thrustVector = CGVectorMake(10*(pos.x - _ship.position.x),
                                            // 10*(pos.y - _ship.position.y));
        //[_ship.physicsBody applyForce:thrustVector];
        /*
         //SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
         //[sprite runAction:[SKAction repeatActionForever:action]];
         
         [self addChild:sprite];*/
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint pos = [touch locationInNode:self];
        thrust = [self normX:fabs(pos.x -initMove.x) YVal:fabs(pos.y - initMove.y)];
        
        CGVector thrustVector = CGVectorMake((pos.x - _ship.position.x),
                                             (pos.y - _ship.position.y));
        [_ship.physicsBody applyForce:thrustVector];
        
    }

}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        
       // _ship.physicsBody.velocity = CGVectorMake(0, 0);
    }

}
-(CGFloat)normX:(CGFloat)x YVal:(CGFloat)Y
{
    return sqrt(x*x +Y*Y);
}

-(void)checkShip{
    if(_ship.position.x >= CGRectGetMaxX(self.frame)){
        _ship.position = CGPointMake(CGRectGetMaxX(self.frame) , _ship.position.y);
    }else if( _ship.position.x  <= CGRectGetMinX(self.frame)){
        _ship.position = CGPointMake(CGRectGetMinX(self.frame) ,_ship.position.y);
    }
    if(_ship.position.y >= CGRectGetMaxY(self.frame)){
        _ship.position = CGPointMake( _ship.position.x, CGRectGetMaxY(self.frame));
    }else if( _ship.position.y  <= CGRectGetMinY(self.frame)){
        _ship.position = CGPointMake(_ship.position.x ,CGRectGetMinY(self.frame));
    }
    
    
}


-(void) doAsteroids{
    double curTime = CACurrentMediaTime();
    if (curTime > _nextAsteroidSpawn) {
        //NSLog(@"spawning new asteroid");
        float randSecs = [self randomValueBetween:0.20 andValue:1.0];
        _nextAsteroidSpawn = randSecs + curTime;
        
        float randX = [self randomValueBetween:0.0 andValue:self.frame.size.width];
        float randDuration = [self randomValueBetween:4.0 andValue:10.0];
        
        SKSpriteNode *asteroid = [_asteroids objectAtIndex:_nextAsteroid];
        _nextAsteroid++;
        
        if (_nextAsteroid >= _asteroids.count) {
            _nextAsteroid = 0;
        }
        
        [asteroid removeAllActions];
        asteroid.position = CGPointMake(randX,self.frame.size.height+asteroid.size.height/2);
        asteroid.hidden = NO;
        
        CGPoint location = CGPointMake(randX, -self.frame.size.height-asteroid.size.height);
        
        SKAction *moveAction = [SKAction moveTo:location duration:randDuration];
        SKAction *doneAction = [SKAction runBlock:(dispatch_block_t)^() {
            //NSLog(@"Animation Completed");
            asteroid.hidden = YES;
        }];
        
        SKAction *moveAsteroidActionWithDone = [SKAction sequence:@[moveAction, doneAction ]];
        [asteroid runAction:moveAsteroidActionWithDone withKey:@"asteroidMoving"];
    }


}

-(void) doLasers{
    double curTime = CACurrentMediaTime();
    if (curTime > _nextLaserSpawn) {
        _nextLaserSpawn = 0.1+curTime;
        
        SKSpriteNode *shipLaser = [_shipLasers objectAtIndex:_nextShipLaser];
        _nextShipLaser++;
        if (_nextShipLaser >= _shipLasers.count) {
            _nextShipLaser = 0;
        }
    
    //2
        shipLaser.position = CGPointMake(_ship.position.x, shipLaser.size.height/2+_ship.position.y);
        shipLaser.hidden = NO;
        [shipLaser removeAllActions];
    
    //3
        CGPoint location = CGPointMake( _ship.position.x, CGRectGetMaxY(self.frame));
        CGFloat dura = fmin((CGRectGetMaxY(self.frame) -_ship.position.y)/CGRectGetMaxY(self.frame), 1.0);
        NSLog(@"dura %f, px %f, max %f",dura,_ship.position.y, CGRectGetMaxY(self.frame));
        
        SKAction *laserMoveAction = [SKAction moveTo:location duration:dura];
    //4
        SKAction *laserDoneAction = [SKAction runBlock:(dispatch_block_t)^() {
        //NSLog(@"Animation Completed");
                            shipLaser.hidden = YES;
        }];
    
    //5
        SKAction *moveLaserActionWithDone = [SKAction sequence:@[laserMoveAction,laserDoneAction]];
    //6
        [shipLaser runAction:moveLaserActionWithDone withKey:@"laserFired"];
    }

}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self checkShip];
    [_parallaxSpaceDust update:currentTime];
    [_parallaxNodeBackgrounds update:currentTime];
    [self doAsteroids];
    [self doLasers];
}

@end
