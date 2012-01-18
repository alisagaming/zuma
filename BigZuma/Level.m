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

     [NSValue valueWithCGPoint:CGPointMake(6, 337)],
     [NSValue valueWithCGPoint:CGPointMake(75, 475)],
     [NSValue valueWithCGPoint:CGPointMake(183, 584)],
     [NSValue valueWithCGPoint:CGPointMake(311, 658)],
     [NSValue valueWithCGPoint:CGPointMake(469, 683)],
     [NSValue valueWithCGPoint:CGPointMake(623, 669)],
     [NSValue valueWithCGPoint:CGPointMake(748, 616)],
     [NSValue valueWithCGPoint:CGPointMake(841, 533)],
     [NSValue valueWithCGPoint:CGPointMake(883, 410)],
     [NSValue valueWithCGPoint:CGPointMake(881, 294)],
     [NSValue valueWithCGPoint:CGPointMake(824, 170)],
     [NSValue valueWithCGPoint:CGPointMake(724, 67)],
     [NSValue valueWithCGPoint:CGPointMake(586, 36)],
     [NSValue valueWithCGPoint:CGPointMake(450, 47)],
     [NSValue valueWithCGPoint:CGPointMake(328, 94)],
     [NSValue valueWithCGPoint:CGPointMake(245, 185)],
     [NSValue valueWithCGPoint:CGPointMake(221, 297)],
     [NSValue valueWithCGPoint:CGPointMake(250, 415)],
     [NSValue valueWithCGPoint:CGPointMake(333, 494)],
     [NSValue valueWithCGPoint:CGPointMake(464, 538)],
     [NSValue valueWithCGPoint:CGPointMake(593, 523)],
     [NSValue valueWithCGPoint:CGPointMake(668, 480)],
     [NSValue valueWithCGPoint:CGPointMake(720, 398)],
     [NSValue valueWithCGPoint:CGPointMake(700, 301)],
     [NSValue valueWithCGPoint:CGPointMake(650, 232)],
     [NSValue valueWithCGPoint:CGPointMake(619, 166)],
     [NSValue valueWithCGPoint:CGPointMake(673, 139)],
     [NSValue valueWithCGPoint:CGPointMake(745, 187)],
     [NSValue valueWithCGPoint:CGPointMake(798, 278)],
     [NSValue valueWithCGPoint:CGPointMake(809, 371)],
     [NSValue valueWithCGPoint:CGPointMake(780, 471)],
     [NSValue valueWithCGPoint:CGPointMake(715, 543)],
     [NSValue valueWithCGPoint:CGPointMake(608, 592)],
     [NSValue valueWithCGPoint:CGPointMake(464, 602)],
     [NSValue valueWithCGPoint:CGPointMake(360, 591)],
     [NSValue valueWithCGPoint:CGPointMake(226, 517)],
     [NSValue valueWithCGPoint:CGPointMake(162, 405)],
     [NSValue valueWithCGPoint:CGPointMake(141, 294)],
     [NSValue valueWithCGPoint:CGPointMake(186, 118)],    
     nil];
 
    Level *level = [[[Level alloc] initWithPointsArray:__pointsArray] autorelease];
    level.totalBallsCount = 70;
    level.startBallsCount = 35;
    level.frogPosition = CGPointMake(440, 30);
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
        bgSprite = [[CCSprite alloc] initWithFile:@"level1.png"];
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
