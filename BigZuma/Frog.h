//
//  Frog.h
//  BigZuma
//
//  Created by Kirill Kuvaldin on 28.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Ball.h"

@interface Frog : CCSprite {
    CCSprite *mask;
    Ball *ball;
    Ball *nextBall;
    BOOL canShoot;
    CCSprite *nextBallDot;
}

+(Frog*)frog ;
-(Ball *)shoot;

@property (nonatomic, assign) BOOL canShoot;
@property (nonatomic, retain) NSArray *ballsRolling;

-(id)initWithPosition:(CGPoint)pos;
-(void)update;
-(void)swapBalls;

@end
