//
//  Ball.m
//  BigZuma
//
//  Created by Kirill Kuvaldin on 28.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Ball.h"
#import "Definitions.h"

CCSpriteBatchNode *blueBallNode;
CCSpriteBatchNode *greenBallNode;
CCSpriteBatchNode *purpleBallNode;
CCSpriteBatchNode *redBallNode;
CCSpriteBatchNode *whiteBallNode;
CCSpriteBatchNode *yellowBallNode;
NSMutableArray *__batchNodes;

@implementation Ball

@synthesize pos, speed, ballColor;

-(void)setPosition:(CGPoint)position {
    [super setPosition:CGPointMake(round(position.x), round(position.y))];
}

+(CCSpriteBatchNode *)nodeForColor:(BallColor)color {
    if (__batchNodes == nil) {
        __batchNodes = [[NSMutableArray alloc] init];
        [__batchNodes addObject:[CCSpriteBatchNode batchNodeWithFile:@"GreenBall.png"]];
        [__batchNodes addObject:[CCSpriteBatchNode batchNodeWithFile:@"RedBall.png"]];
        [__batchNodes addObject:[CCSpriteBatchNode batchNodeWithFile:@"YellowBall.png"]];
        [__batchNodes addObject:[CCSpriteBatchNode batchNodeWithFile:@"BlueBall.png"]];
        [__batchNodes addObject:[CCSpriteBatchNode batchNodeWithFile:@"PurpleBall.png"]];
        [__batchNodes addObject:[CCSpriteBatchNode batchNodeWithFile:@"WhiteBall.png"]];
/*        [__batchNodes addObject:[CCSpriteBatchNode batchNodeWithFile:@"green.png"]];
        [__batchNodes addObject:[CCSpriteBatchNode batchNodeWithFile:@"red.png"]];
        [__batchNodes addObject:[CCSpriteBatchNode batchNodeWithFile:@"yellow.png"]];
        [__batchNodes addObject:[CCSpriteBatchNode batchNodeWithFile:@"blue.png"]];
        [__batchNodes addObject:[CCSpriteBatchNode batchNodeWithFile:@"purple.png"]];
        [__batchNodes addObject:[CCSpriteBatchNode batchNodeWithFile:@"white.png"]];*/
    }
    return [__batchNodes objectAtIndex:color];
}

-(void)setSpeed:(BallSpeed)_speed {
    if (speed == _speed)
        return;
    speed = _speed;
    [self stopAllActions];
    if (speed == BALL_SPEED_ZERO) {
        return;
    } else if (speed == BALL_SPEED_SLOW || speed == BALL_SPEED_SLOW_BACK) {
        ballAnimation.delay = 0.05;
    } else if (speed == BALL_SPEED_NORMAL || speed == BALL_SPEED_NORMAL_BACK) {
        ballAnimation.delay = 0.025;
    } else if (speed == BALL_SPEED_FAST || speed == BALL_SPEED_FAST_BACK) {
        ballAnimation.delay = 0.0125;
    } else if (speed == BALL_SPEED_CRAZY) {
        ballAnimation.delay = 0.00625;
    }
    CCAnimate *ballMovement = [CCAnimate actionWithAnimation:ballAnimation];
    if (speed > 0)
        [self runAction:[CCRepeatForever actionWithAction:ballMovement]];
    else
        [self runAction:[CCRepeatForever actionWithAction:[ballMovement reverse]]];
}

-(id)initWithPoint:(CGPoint)point andColor:(BallColor)color
{
    CCSpriteBatchNode *spriteBatchNode = [Ball nodeForColor:color];
    
    if (self = [super initWithTexture:spriteBatchNode.texture rect:CGRectMake(0, 0, BS, BS)]) {
        self.position = point;
        self.ballColor = color;
        pos = 0;
        
        ballAnimation = [[CCAnimation alloc] init];
        ballAnimation.delay = 0.025;
        int frameCount = spriteBatchNode.texture.contentSize.height/BS * spriteBatchNode.texture.contentSize.width / BS;
        int framesPerRow = spriteBatchNode.texture.contentSize.width/BS;
        for (int i = frameCount-1; i >= 0; i--) {
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:spriteBatchNode.texture 
                                                              rect:CGRectMake((i%framesPerRow)*BS, BS*(i/framesPerRow), BS, BS)];
            [ballAnimation addFrame:frame];
        }
        /*CCAnimate *ballMovement = [CCAnimate actionWithAnimation:ballAnimation];
        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:ballMovement];
        [self runAction:repeat];*/
    }
    return self;
}

-(void)dealloc {
    [ballAnimation release];
    [super dealloc];
}

@end
