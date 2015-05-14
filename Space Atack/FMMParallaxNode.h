

#import <SpriteKit/SpriteKit.h>

@interface FMMParallaxNode : SKNode

- (instancetype)initWithBackground:(NSString *)file size:(CGSize)size pointsPerSecondSpeed:(float)pointsPerSecondSpeed frameSize:(CGSize) csz;;
- (instancetype)initWithBackgrounds:(NSArray *)files size:(CGSize)size pointsPerSecondSpeed:(float)pointsPerSecondSpeed frameSize:(CGSize) csz;
- (void)randomizeNodesPositions;
- (void)update:(NSTimeInterval)currentTime;
-(CGSize)getSize;


@end
