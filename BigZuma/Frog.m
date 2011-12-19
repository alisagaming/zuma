//
//  Frog.m
//  BigZuma
//
//  Created by Kirill Kuvaldin on 28.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Frog.h"
#import "Definitions.h"

CCSpriteBatchNode *__dotNode;

@implementation Frog

@synthesize canShoot;
@synthesize ballsRolling;

+(Frog *)frog {
    
    Frog *frog = [[[Frog alloc] initWithPosition:ccp(SW/2, SH/2)] autorelease];
    return frog;
}

-(id)initWithPosition:(CGPoint)pos {
    if (__dotNode == nil)
        __dotNode = [[CCSpriteBatchNode batchNodeWithFile:@"dots.png"] retain];
    
    if (self = [super initWithFile:@"Frog.png"]) {
        self.position = pos;
        mask = [[CCSprite alloc] initWithFile:@"Frog2.png"];
        [self addChild:mask z:2];
        self.canShoot = NO;
        mask.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
    }
    return self;
}

-(BOOL)isColorPresent:(BallColor)color {
    for (Ball *b in self.ballsRolling)
        if (b.ballColor == color)
            return YES;
    return NO;
}

-(Ball *)newBall {
    BallColor color;
    if (self.ballsRolling.count == 0)
        return nil;
    for(;;) {
        if ([self isColorPresent:(color = BALL_RAND_COLOR)])
            break;
    }
    Ball *b = [[Ball alloc] initWithPoint:ccp(self.contentSize.width / 2, self.contentSize.height / 4) andColor:color];
    b.speed = BALL_SPEED_ZERO;
    return b;
}

-(void)getBall {
    ball = nextBall ? nextBall : [self newBall];
    if (ball)
        [self addChild:ball z:1];
    nextBall = [self newBall];
    if (nextBallDot) {
        [self removeChild:nextBallDot cleanup:YES];
    }
    if (nextBall == nil)
        return;
    nextBallDot = [CCSprite spriteWithTexture:__dotNode.texture rect:CGRectMake(0, DS*nextBall.ballColor, DS, DS)];
    nextBallDot.position = ccp(self.contentSize.width / 2, self.contentSize.height * 3/4);
    [self addChild:nextBallDot z:1];
}

-(void)swapBalls {
    if (canShoot && ball && nextBall) {
        Ball *tmpBall = ball;
        [self removeChild:tmpBall cleanup:YES];
        ball = nextBall;
        [self addChild:ball];
        nextBall = tmpBall;
        [self removeChild:nextBallDot cleanup:YES];
        nextBallDot = [CCSprite spriteWithTexture:__dotNode.texture rect:CGRectMake(0, DS*nextBall.ballColor, DS, DS)];
        nextBallDot.position = ccp(self.contentSize.width / 2, self.contentSize.height * 3/4);
        [self addChild:nextBallDot z:1];
    }
}

-(void)setCanShoot:(BOOL)_canShoot {
    canShoot = _canShoot;
    
    if (canShoot) {
        [self getBall];
    } else {
        if (ball) {
            if (nextBallDot) {
                [self removeChild:nextBallDot cleanup:YES];
                nextBallDot = nil;
            }
            [nextBall release];
            nextBall = nil;
            [self removeChild:ball cleanup:YES];
            [ball release];
            ball = nil;
        }
    }
}

-(Ball *)shoot {
    if (self.canShoot) {
        Ball *ballToShoot = ball;
        [self removeChild:ball cleanup:NO];

        [self getBall];

        return [ballToShoot autorelease];
    } else
        return nil;
}

-(void)update {
    if (![self isColorPresent:ball.ballColor] || ![self isColorPresent:nextBall.ballColor]) {
        [self removeChild:ball cleanup:YES];
        [ball release];
        [self getBall];
    }
}

-(void)dealloc {
    self.ballsRolling = nil;
    [super dealloc];
}

@end
