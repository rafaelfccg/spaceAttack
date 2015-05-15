//
//  GameScene.m
//  Space Atack
//
//  Created by Rafael Gouveia on 5/11/15.
//  Copyright (c) 2015 Mini Challenge 2. All rights reserved.
//

#import "GameScene.h"
@import AVFoundation;

//Add the following variable underneath the bool _gameOver; declaration

#define kNumAsteroids   10
#define kNumLasers      25
#define distTOP         250
typedef enum {
    kEndReasonWin,
    kEndReasonLose
} EndReason;



@implementation GameScene{
    SKSpriteNode * _ship;
    FMMParallaxNode *_parallaxNodeBackgrounds;
    FMMParallaxNode *_parallaxSpaceDust;
    CGFloat _ship_Speed;
    CGPoint initMove;
    NSMutableArray *_asteroids;
    int _nextAsteroid;
    double _nextAsteroidSpawn;
    int _lives;
    int _nextShipLaser;
    NSMutableArray *_shipLasers;
    double _nextItemSpawn;
    double  _nextLaserSpawn;
    double _gameOverTime;
    BOOL _gameOver;
    SKAction * _animaAst;
    SKLabelNode *restartLabel;
    double last_hit;
    int score;
    SKLabelNode* _LabelScore;
    //SKLabelNode* _Life;
    AVAudioPlayer *_backgroundAudioPlayer;
    bool OnTrilaser;
    double trilaserTime;
}

static const uint32_t shipCategory = 0x1<<1;
static const uint32_t asteroidCategory = 0x1<<2;
static const uint32_t laserCategory = 0x1<<3;
static const uint32_t itemTrilaser = 0x1<<5;
static const uint32_t eshipCategory = 0x1<<4;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
   
}




-(id)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        /* Setup your scene here */
        //2
        NSLog(@"SKScene:initWithSize %f x %f",size.width,size.height);
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        //3
        self.backgroundColor = [SKColor blackColor];
        
        _LabelScore = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
        _LabelScore.name = @"scoreLabel";
        _LabelScore.text = [NSString stringWithFormat:@"Score: %d",score ];
        //_LabelScore.scale = 0.1;
        _LabelScore.position = CGPointMake(CGRectGetMaxX(self.frame)*0.9-15,
                                           CGRectGetMaxY(self.frame)*0.95-5);
        _LabelScore.fontColor = [SKColor whiteColor];
        _LabelScore.zPosition = 100;
        
        /*_Life = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
        _Life.name = @"lifeLabel";
        _Life.text = @"Lifes:";
        _Life.position = CGPointMake(CGRectGetMinX(self.frame)+30,
                                           CGRectGetMaxY(self.frame)*0.95);
        _Life.fontColor = [SKColor whiteColor];
        _Life.zPosition = 100;*/
        
        
        
#pragma mark - TBD - Game Backgrounds
        
               //6
        NSArray *parallaxBackground2Names = @[@"SpaceBack",@"SpaceBack"];
        _parallaxSpaceDust = [[FMMParallaxNode alloc] initWithBackgrounds:parallaxBackground2Names
                                                                     size:size
                                                     pointsPerSecondSpeed:30.0
                                                                frameSize:size];
        _parallaxSpaceDust.position = CGPointMake(0, 0);
                [self addChild:_parallaxSpaceDust];
        
        float randSecs = [self randomValueBetween:25 andValue:45];
        _nextItemSpawn = randSecs;
        
#pragma mark - Setup Sprite for the ship
        //Create space sprite, setup position on left edge centered on the screen, and add to Scene
        //4
        _ship = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        _ship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)*0.2);
        _ship.xScale = 0.8;
        _ship.yScale =0.8;
        
        CGSize a  = _ship.texture.size;
        a.height = a.height*0.2;
        a.width =a.width *0.2;
        _ship.physicsBody = [SKPhysicsBody bodyWithTexture:_ship.texture  size:_ship.size];
        
        _ship.physicsBody.affectedByGravity = NO;
        _ship.physicsBody.allowsRotation = NO;
        _ship.physicsBody.categoryBitMask = shipCategory;
        _ship.physicsBody.collisionBitMask = 0x0;
        _ship.physicsBody.contactTestBitMask = shipCategory|eshipCategory|asteroidCategory| itemTrilaser;
        //_ship.physicsBody.usesPreciseCollisionDetection;
        [_ship.physicsBody setMass:0.366144];
        [self addChild:_ship];
        _ship_Speed = 0;
        NSLog(@"ship mass %f",_ship.physicsBody.mass);
        
#pragma mark - TBD - Setup the asteroids

        //_asteroids = [[NSMutableArray alloc] initWithCapacity:kNumAsteroids];
        //[SKTexture textureWithImageNamed:<#(NSString *)#>]
        NSArray *animaAst= @[([SKTexture textureWithImageNamed:@"A1"]),([SKTexture textureWithImageNamed:@"A2"]),
                            ([SKTexture textureWithImageNamed:@"A3"]),([SKTexture textureWithImageNamed:@"A4"]),
                            ([SKTexture textureWithImageNamed:@"A5"]),([SKTexture textureWithImageNamed:@"A6"]),
                            ([SKTexture textureWithImageNamed:@"A7"]),([SKTexture textureWithImageNamed:@"A8"]),
                             ([SKTexture textureWithImageNamed:@"A9"]),([SKTexture textureWithImageNamed:@"A10"]),
                             ([SKTexture textureWithImageNamed:@"A11"]),([SKTexture textureWithImageNamed:@"A12"]),
                             ([SKTexture textureWithImageNamed:@"A13"]),([SKTexture textureWithImageNamed:@"A14"]),
                             ([SKTexture textureWithImageNamed:@"A15"]),([SKTexture textureWithImageNamed:@"A0"])];
        SKAction *anima  =[SKAction animateWithTextures:animaAst timePerFrame:0.025];
        _animaAst = [SKAction repeatActionForever:anima];
        #pragma mark - TBD - Setup the lasers
        _shipLasers = [[NSMutableArray alloc] initWithCapacity:kNumLasers];
        for (int i = 0; i < kNumLasers; ++i) {
            SKSpriteNode *shipLaser = [SKSpriteNode spriteNodeWithImageNamed:@"SBlueShot"];
            shipLaser.hidden = YES;
            [_shipLasers addObject:shipLaser];
            [self addChild:shipLaser];
        }
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
#pragma  mark music
- (void)startBackgroundMusic
{
    NSError *err;
    NSURL *file = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Game-SPaceAttack.mp3" ofType:nil]];
    _backgroundAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:&err];
    if (err) {
        NSLog(@"error in audio play %@",[err userInfo]);
        return;
    }
    [_backgroundAudioPlayer prepareToPlay];
    
    // this will play the music infinitely
    _backgroundAudioPlayer.numberOfLoops = -1;
    [_backgroundAudioPlayer setVolume:1.0];
    [_backgroundAudioPlayer play];
}

#pragma  mark contact
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
   // NSLog(@"%ud %ud",firstBody.categoryBitMask,secondBody.categoryBitMask);
    double cur = CACurrentMediaTime();
    if ( (secondBody.categoryBitMask & asteroidCategory) && (firstBody.categoryBitMask & shipCategory)&& !secondBody.node.hidden && last_hit+1.0 <= cur)
    {
        last_hit = cur;
        secondBody.node.hidden = YES;
        NSLog(@"You have been HIT Contact!!");
        SKAction *blink = [SKAction sequence:@[[SKAction fadeOutWithDuration:0.1],
                                               [SKAction fadeInWithDuration:0.1]]];
        SKAction *blinkForTime = [SKAction repeatAction:blink count:5];
        [_ship runAction:blinkForTime];
        [[self childNodeWithName:[NSString stringWithFormat:@"L%d",(_lives-1)]]removeFromParent];
        
        _lives--;
    }else if (((secondBody.categoryBitMask & laserCategory) && (firstBody.categoryBitMask & asteroidCategory)) && !secondBody.node.hidden && !firstBody.node.hidden)
    {
        //last_hit = cur;
        secondBody.node.hidden = YES;
        secondBody.collisionBitMask = 0x0;
        firstBody.node.hidden = YES;
        firstBody.collisionBitMask = 0x0;
        score+= 50;
        [self setScore];
        NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"Explosion" ofType:@"sks"];
        SKEmitterNode *emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
        emitterNode.position = firstBody.node.position;
        
        [self addChild:emitterNode];
        
    } else if ( (secondBody.categoryBitMask & itemTrilaser) && (firstBody.categoryBitMask & shipCategory)&& !secondBody.node.hidden && last_hit+1.0 <= cur)
    {
        secondBody.node.hidden = YES;
        OnTrilaser = YES;
        trilaserTime = cur;
        
    }
    
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
    _lives = 3;
    double  cur = CACurrentMediaTime();
    _gameOverTime = cur+180;
    _gameOver = NO;
    restartLabel.hidden = YES;
    score = 0;
    OnTrilaser = NO;
    float randSecs = [self randomValueBetween:10 andValue:40];
    _nextItemSpawn = cur + randSecs;
    _nextAsteroidSpawn = cur+2.5;
    [self setScore];
    _ship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)*0.2);
    _ship.hidden = NO;
    NSArray *lives = @[[SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"],
                      [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"],
                      [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"]];
    int count = 0;
    CGFloat x = CGRectGetMinX(self.frame);
    CGFloat y = CGRectGetMaxY(self.frame);
    for (SKSpriteNode * livei in lives) {
        livei.xScale = 0.25;
        livei.yScale = 0.25;
        livei.position = CGPointMake(x + (2*count+1)*livei.size.width/2 +5, y-livei.size.height/2 -7);
        livei.name = [NSString stringWithFormat:@"L%d",count];
        [self addChild:livei];
        count++;
        
    }
    
    
    [self addChild:_LabelScore];
    //[self addChild:_Life];
    [self startBackgroundMusic];
    //reset ship position for new game
    //_ship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame)+_ship.size.height);
    
    //setup to handle accelerometer readings using CoreMotion Framework
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //check if they touched your Restart Label
    if(!restartLabel.hidden){
        for (UITouch *touch in touches) {
            SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
            NSLog(@"%@",n.name);
            
           
          if (n != self && [n.name isEqual: @"restartLabel"]) {
                [[self childNodeWithName:@"restartLabel"] removeFromParent];
                [[self childNodeWithName:@"winLoseLabel"] removeFromParent];
                [_LabelScore removeFromParent];
                //NSLog(@"RESTART GAME");
                [self startTheGame];
                
                return;
            }
        }
    }
    
    //do not process anymore touches since it's game over
    if (_gameOver) {
        return;
    }    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        CGPoint pos = [touch locationInNode:self];
        initMove = pos;
        CGFloat x =(pos.x - _ship.position.x);
        CGFloat y =(pos.y - _ship.position.y);
        
        
        CGFloat norm = [self normX:x YVal:y];
        CGVector thrustVector = CGVectorMake(40*x/norm,
                                             40*y/norm);
        [_ship.physicsBody applyImpulse:thrustVector];
    }
    
}
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    for (UITouch *touch in touches) {
//        CGPoint pos = [touch locationInNode:self];
//        thrust = [self normX:fabs(pos.x -initMove.x) YVal:fabs(pos.y - initMove.y)];
//        
//        CGVector thrustVector = CGVectorMake(0.5*(pos.x - _ship.position.x),
//                                             0.5*(pos.y - _ship.position.y));
//        [_ship.physicsBody applyForce:thrustVector];
//        
//    }
//
//}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
  
    
}
#pragma <#arguments#>
-(void)setScore{
    int aux  = score;
    int count = 1;
    while(aux>9){
        aux/=10;
        count++;
    }
    _LabelScore.position = CGPointMake(CGRectGetMaxX(self.frame)*0.9-count*9 +5,
                                       CGRectGetMaxY(self.frame)*0.95);
    _LabelScore.text = [NSString stringWithFormat:@"Score: %d",score];
}

-(CGFloat)normX:(CGFloat)x YVal:(CGFloat)Y
{
    return sqrt(x*x +Y*Y);
}
#pragma mark checkShip
-(void)checkShip{
    if(_ship.position.x >= CGRectGetMaxX(self.frame)-30){
        _ship.position = CGPointMake(CGRectGetMaxX(self.frame)-30 , _ship.position.y);
    }else if( _ship.position.x  <= CGRectGetMinX(self.frame)+30){
        _ship.position = CGPointMake(CGRectGetMinX(self.frame)+30 ,_ship.position.y);
    }
    if(_ship.position.y >= CGRectGetMaxY(self.frame)-distTOP){
        _ship.position = CGPointMake( _ship.position.x, CGRectGetMaxY(self.frame)-distTOP);
    }else if( _ship.position.y  <= CGRectGetMinY(self.frame)+10){
        _ship.position = CGPointMake(_ship.position.x ,CGRectGetMinY(self.frame)+10);
    }
    
    
}


-(void) doAsteroids{
    

    double curTime = CACurrentMediaTime();
    if (curTime>_nextItemSpawn) {
        float randSecs = [self randomValueBetween:15 andValue:45];
        _nextItemSpawn = randSecs + curTime;
        
        float randX = [self randomValueBetween:0.0 andValue:self.frame.size.width];
        SKSpriteNode *trilaserItem = [SKSpriteNode spriteNodeWithImageNamed:@"redShot"];
      
        trilaserItem.position = CGPointMake(randX,CGRectGetMaxY(self.frame));
        trilaserItem.hidden = NO;
        trilaserItem.xScale = 1.4;
        trilaserItem.yScale = 1.4;
        
        trilaserItem.physicsBody = [SKPhysicsBody bodyWithTexture:trilaserItem.texture size:trilaserItem.texture.size];
        trilaserItem.physicsBody.categoryBitMask = itemTrilaser;
        trilaserItem.physicsBody.contactTestBitMask = shipCategory;
        trilaserItem.physicsBody.collisionBitMask = 0x0;
        trilaserItem.physicsBody.allowsRotation =NO;
        SKAction* remove = [SKAction removeFromParent];
        SKAction* seq = [SKAction sequence:@[[SKAction waitForDuration:15],remove]];
        [self addChild:trilaserItem];
        // CGPoint location = CGPointMake(randX, -self.frame.size.height-asteroid.size.height);
        [trilaserItem runAction:seq];
        SKAction *blink = [SKAction sequence:@[[SKAction fadeOutWithDuration:0.2],
                                               [SKAction fadeInWithDuration:0.2]]];
        SKAction *blinkForTime = [SKAction repeatAction:blink count:30];
        [trilaserItem runAction:blinkForTime];
        
        [[self childNodeWithName:[NSString stringWithFormat:@"L%d",(_lives-1)]]removeFromParent];
        
        [trilaserItem.physicsBody applyImpulse:CGVectorMake(0, -5)];
    }
    
    if (curTime > _nextAsteroidSpawn) {
        //NSLog(@"spawning new asteroid");
        float randSecs = [self randomValueBetween:0.10 andValue:0.80];
        _nextAsteroidSpawn = randSecs + curTime;
        
        float randX = [self randomValueBetween:0.0 andValue:self.frame.size.width];
        float randDuration = [self randomValueBetween:4.0 andValue:10.0];
        
        SKSpriteNode *asteroid = [SKSpriteNode spriteNodeWithImageNamed:@"A1"];
        [asteroid setXScale:0.8];
        [asteroid setYScale:0.8];
        asteroid.position = CGPointMake(randX,CGRectGetMaxY(self.frame));
        asteroid.hidden = NO;
        
        asteroid.physicsBody = [SKPhysicsBody bodyWithTexture:asteroid.texture size:asteroid.texture.size];
        asteroid.physicsBody.categoryBitMask = asteroidCategory;
        asteroid.physicsBody.contactTestBitMask = shipCategory| laserCategory;
        asteroid.physicsBody.collisionBitMask = shipCategory;
        asteroid.physicsBody.allowsRotation =NO;
        SKAction* remove = [SKAction removeFromParent];
        SKAction* seq = [SKAction sequence:@[[SKAction waitForDuration:15],remove]];
        [self addChild:asteroid];
       // CGPoint location = CGPointMake(randX, -self.frame.size.height-asteroid.size.height);
        [asteroid runAction:seq];
        [asteroid runAction:_animaAst withKey:@"asteroidAnima"];
        [asteroid.physicsBody applyImpulse:CGVectorMake(0, -randDuration)];
        
        
        
           }
    
}
#pragma mark doLaser
-(void) doLasers{
    
    double curTime = CACurrentMediaTime();
    if(curTime> trilaserTime+15)OnTrilaser = NO;
    if (!OnTrilaser && curTime > _nextLaserSpawn) {
        _nextLaserSpawn = 0.2+curTime;
        
        SKSpriteNode *shipLaser  = [SKSpriteNode spriteNodeWithImageNamed:@"SBlueShot"];;
    //2
        shipLaser.position = CGPointMake(_ship.position.x, shipLaser.size.height/2+_ship.position.y);
        shipLaser.hidden = NO;
        [shipLaser removeAllActions];
    
        shipLaser.physicsBody = [SKPhysicsBody bodyWithTexture:shipLaser.texture size:shipLaser.texture.size];
        shipLaser.physicsBody.categoryBitMask = laserCategory;
        shipLaser.physicsBody.contactTestBitMask = asteroidCategory;
        shipLaser.physicsBody.collisionBitMask = 0x0;
        shipLaser.physicsBody.allowsRotation =NO;
        SKAction* remove = [SKAction removeFromParent];
        SKAction* seq = [SKAction sequence:@[[SKAction waitForDuration:15],remove]];
        [self addChild:shipLaser];
        // CGPoint location = CGPointMake(randX, -self.frame.size.height-asteroid.size.height);
        [shipLaser runAction:seq];
        [shipLaser.physicsBody applyImpulse:CGVectorMake(0, 10)];
    }else if(curTime> _nextLaserSpawn){
        _nextLaserSpawn = 0.15+curTime;
        
        NSArray *shots = @[[SKSpriteNode spriteNodeWithImageNamed:@"redShot"],
                          [SKSpriteNode spriteNodeWithImageNamed:@"redShot"],
                          [SKSpriteNode spriteNodeWithImageNamed:@"redShot"]];
        
        //SKSpriteNode *shipLaser  = [SKSpriteNode spriteNodeWithImageNamed:@"redShot"];
        //2
        for (SKSpriteNode* shipLaser in shots) {
        
            shipLaser.position = CGPointMake(_ship.position.x, shipLaser.size.height/2+_ship.position.y);
            shipLaser.hidden = NO;
            [shipLaser removeAllActions];
        
            shipLaser.physicsBody = [SKPhysicsBody bodyWithTexture:shipLaser.texture size:shipLaser.texture.size];
            shipLaser.physicsBody.categoryBitMask = laserCategory;
            shipLaser.physicsBody.contactTestBitMask = asteroidCategory;
            shipLaser.physicsBody.collisionBitMask = 0x0;
            shipLaser.physicsBody.allowsRotation =NO;
            SKAction* remove = [SKAction removeFromParent];
            SKAction* seq = [SKAction sequence:@[[SKAction waitForDuration:15],remove]];
            [self addChild:shipLaser];
            [shipLaser runAction:seq];
        }
        // CGPoint location = CGPointMake(randX, -self.frame.size.height-asteroid.size.height);
        
        [((SKSpriteNode * )[shots objectAtIndex:0]).physicsBody applyImpulse:CGVectorMake(1, 10)];
        [((SKSpriteNode * )[shots objectAtIndex:1]).physicsBody applyImpulse:CGVectorMake(0, 10)];
        [((SKSpriteNode * )[shots objectAtIndex:2]).physicsBody applyImpulse:CGVectorMake(-1, 10)];
    
    }

}

#pragma mark ENDSCNE
- (void)endTheScene:(EndReason)endReason {
    if (_gameOver) {
        return;
    }
    
    [self removeAllActions];
    //[self stopMonitoringAcceleration];
    //_ship.hidden = YES;
    _ship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)*0.2);
    _ship.physicsBody.velocity = CGVectorMake(0, 0);
    _gameOver = YES;
    //NSLog(@"DSSDFSDFSFSFDFSDFSD");
    NSString *message;
    if (endReason == kEndReasonWin) {
        message = @"You win!";
    } else if (endReason == kEndReasonLose) {
        message = @"You lost!";
    }
    
    SKLabelNode *label;
    label = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
    label.name = @"winLoseLabel";
    label.text = message;
    label.scale = 0.1;
    label.position = CGPointMake(self.frame.size.width/2, self.frame.size.height * 0.6);
    SKColor *color =[SKColor colorWithRed:0.807 green:0.717 blue:0.439 alpha:1];
    label.fontColor = color;
    [self addChild:label];
    
    
    restartLabel = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
    restartLabel.name = @"restartLabel";
    restartLabel.text = @"Play Again?";
    restartLabel.scale = 0.5;
    restartLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height * 0.4);
    restartLabel.fontColor = color;
    restartLabel.zPosition = 100;
    [self addChild:restartLabel];
    
    SKAction *labelScaleAction = [SKAction scaleTo:1.0 duration:0.5];
    
    [restartLabel runAction:labelScaleAction];
    [label runAction:labelScaleAction];
    
}
-(void)checkEndgame{
    double cur = CACurrentMediaTime();
    if(_lives<=0){
        NSLog(@"YOU LOSE!! HAHA");
        [self endTheScene:kEndReasonLose];
        
    }else if(cur>= _gameOverTime){
        NSLog(@"YOU WON, but that was easy");
        [self endTheScene:kEndReasonWin];
        
    
    }
}
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self checkShip];
    [_parallaxSpaceDust update:currentTime];
    [_parallaxNodeBackgrounds update:currentTime];
    if (!_gameOver) {
        [self doAsteroids];
        [self doLasers];
        //[self checkLaserAsteroidColision];
        [self checkEndgame];
    }
    
}

@end
