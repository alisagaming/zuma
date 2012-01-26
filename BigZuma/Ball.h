//
//  Ball.h
//  BigZuma
//
//  Created by Kirill Kuvaldin on 28.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    BALL_COLOR_GREEN,
    BALL_COLOR_RED,
    BALL_COLOR_YELLOW,
    BALL_COLOR_BLUE,
    BALL_COLOR_PURPLE,
    BALL_COLOR_WHITE,
    BALL_COLOR_COUNT
} BallColor;

#define BALL_RAND_COLOR  (arc4random() % BALL_COLOR_COUNT)

typedef enum {
    BALL_SPEED_FAST_BACK = -4,
    BALL_SPEED_NORMAL_BACK = -2,
    BALL_SPEED_SLOW_BACK = -1,
    BALL_SPEED_ZERO = 0,
    BALL_SPEED_SLOW = 1,
    BALL_SPEED_NORMAL = 2,
    BALL_SPEED_FAST = 4,
    BALL_SPEED_CRAZY = 16,
    BALL_SPEED_VERY_CRAZY = 128
} BallSpeed;

@interface Ball : CCSprite {
    int pos;
    BallSpeed speed;
    BallColor ballColor;
    CCAnimation *ballAnimation;
}

@property (nonatomic, assign) int pos;
@property (nonatomic, assign) BallSpeed speed;
@property (nonatomic, assign) BallColor ballColor;
-(id)initWithPoint:(CGPoint)point andColor:(BallColor)color;

@end
