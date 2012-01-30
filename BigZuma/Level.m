//
//  Level.m
//  BigZuma
//
//  Created by Kirill Kuvaldin on 29.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Level.h"
#import "Bezier.h"
#import "Ball.h"
#import "Definitions.h"

@implementation Level

@synthesize pointsCount;
@synthesize totalBallsCount;
@synthesize startBallsCount;
@synthesize pathLength;
@synthesize colorCount;
@synthesize frogPosition;

+(Level *)level1 {
    NSArray *__pointsArray =
    [NSArray arrayWithObjects:

     [NSValue valueWithCGPoint:CGPointMake(53, 576)],
     [NSValue valueWithCGPoint:CGPointMake(84, 651)],
     [NSValue valueWithCGPoint:CGPointMake(109, 716)],
     [NSValue valueWithCGPoint:CGPointMake(164, 694)],
     [NSValue valueWithCGPoint:CGPointMake(185, 653)],
     [NSValue valueWithCGPoint:CGPointMake(226, 590)],
     [NSValue valueWithCGPoint:CGPointMake(258, 553)],
     [NSValue valueWithCGPoint:CGPointMake(309, 615)],
     [NSValue valueWithCGPoint:CGPointMake(361, 673)],
     [NSValue valueWithCGPoint:CGPointMake(406, 717)],
     [NSValue valueWithCGPoint:CGPointMake(448, 698)],
     [NSValue valueWithCGPoint:CGPointMake(483, 615)],
     [NSValue valueWithCGPoint:CGPointMake(513, 573)],
     [NSValue valueWithCGPoint:CGPointMake(557, 586)],
     [NSValue valueWithCGPoint:CGPointMake(618, 667)],
     [NSValue valueWithCGPoint:CGPointMake(662, 723)],
     [NSValue valueWithCGPoint:CGPointMake(709, 729)],
     [NSValue valueWithCGPoint:CGPointMake(738, 666)],
     [NSValue valueWithCGPoint:CGPointMake(756, 585)],
     [NSValue valueWithCGPoint:CGPointMake(788, 551)],
     [NSValue valueWithCGPoint:CGPointMake(853, 640)],
     [NSValue valueWithCGPoint:CGPointMake(909, 672)],
     [NSValue valueWithCGPoint:CGPointMake(937, 630)],
     [NSValue valueWithCGPoint:CGPointMake(946, 544)],
     [NSValue valueWithCGPoint:CGPointMake(916, 475)],
     [NSValue valueWithCGPoint:CGPointMake(819, 460)],
     [NSValue valueWithCGPoint:CGPointMake(678, 460)],
     [NSValue valueWithCGPoint:CGPointMake(550, 476)],
     [NSValue valueWithCGPoint:CGPointMake(440, 481)],
     [NSValue valueWithCGPoint:CGPointMake(343, 469)],
     [NSValue valueWithCGPoint:CGPointMake(252, 466)],
     [NSValue valueWithCGPoint:CGPointMake(150, 449)],
     [NSValue valueWithCGPoint:CGPointMake(105, 416)],
     [NSValue valueWithCGPoint:CGPointMake(97, 334)],
     [NSValue valueWithCGPoint:CGPointMake(141, 285)],
     [NSValue valueWithCGPoint:CGPointMake(236, 227)],
     [NSValue valueWithCGPoint:CGPointMake(358, 213)],
     [NSValue valueWithCGPoint:CGPointMake(478, 230)],
     [NSValue valueWithCGPoint:CGPointMake(571, 304)],
     [NSValue valueWithCGPoint:CGPointMake(640, 376)],
     [NSValue valueWithCGPoint:CGPointMake(766, 391)],
     [NSValue valueWithCGPoint:CGPointMake(887, 365)],
     [NSValue valueWithCGPoint:CGPointMake(921, 286)],
     [NSValue valueWithCGPoint:CGPointMake(899, 218)],
     [NSValue valueWithCGPoint:CGPointMake(851, 216)],
     [NSValue valueWithCGPoint:CGPointMake(775, 228)],
     [NSValue valueWithCGPoint:CGPointMake(673, 231)],
     [NSValue valueWithCGPoint:CGPointMake(596, 240)],
     [NSValue valueWithCGPoint:CGPointMake(560, 229)],
     [NSValue valueWithCGPoint:CGPointMake(513, 190)],
     [NSValue valueWithCGPoint:CGPointMake(411, 156)],
     [NSValue valueWithCGPoint:CGPointMake(263, 144)],
     [NSValue valueWithCGPoint:CGPointMake(182, 129)],    
     nil];
 
    Level *level = [[[Level alloc] initWithPointsArray:__pointsArray] autorelease];
    level.totalBallsCount = 70;
    level.startBallsCount = 35;
    level.frogPosition = CGPointMake(512, 100);
    level.colorCount = 5;//BALL_COLOR_COUNT;
    
    return level;
}

- (id)initWithPointsArray:(NSArray *)__pointsArray {
    if (self = [super init]) {
        pointsArray = __pointsArray;
        pointsCount = __pointsArray.count;
        path = [[NSMutableArray alloc] init];
        for (int j = 0; j < self.pointsCount - 2; j++) {
            CGPoint a0 = [self pointAtIndex:j];
            CGPoint a1 = [self pointAtIndex:j+1];
            CGPoint a2 = [self pointAtIndex:j+2];
            CGPoint p0 = (j == 0) ? a0 : CGPointMake((a0.x+a1.x)/2, (a0.y+a1.y)/2);
            CGPoint p1 = a1;
            CGPoint p2 = (j < self.pointsCount - 3) ? CGPointMake((a1.x+a2.x)/2, (a1.y+a2.y)/2) : a2;
            Bezier *bezier = [[[Bezier alloc] initWith:p0 :p1 :p2 :STEP] autorelease];
            for (int m = 1; m <= bezier.step; m++) {
                DirectionalPoint *dp = [bezier getAnchorPoint:m];
                if (dp)
                    [path addObject:dp];
            }
        }
        bgSprite = [[CCSprite alloc] initWithFile:@"blue-greed-ipad.png"];
        bgSprite.position = ccp(SW/2, SH/2);
        [self addChild:bgSprite];
        //self.position = ccp(SW/2, SH/2);
    }
    return self;
}

- (CGPoint)pointAtIndex:(int)index {
    return [(NSValue*)[pointsArray objectAtIndex:index] CGPointValue];
}

-(DirectionalPoint *)pathPoint:(int)index {
    if (index < 0)
        return [path objectAtIndex:0];
    else if (index >= path.count)
        return [path lastObject];
    else
        return [path objectAtIndex:index];
}

-(DirectionalPoint *)deathPoint {
    return [path lastObject];
}

-(int)pathLength {
    return path.count;
}

-(void)dealloc {
    [bgSprite release];
    bgSprite = nil;
    [path release];
    path = nil;
    [super dealloc];
}

@end
