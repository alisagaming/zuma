//
//  Zuma.m
//  BigZuma
//
//  Created by Kirill Kuvaldin on 28.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Zuma.h"
#import "Ball.h"
#import "Definitions.h"
#import "Level.h"
#import "Bezier.h"
#import "BallCollision.h"
#import "SimpleAudioEngine.h"

@interface Zuma (Private)
-(void)pushBallsFrom:(int)startIndex step:(int)step;
-(void)rollNewBall:(BallSpeed)speed;
-(void)insertBall:(Ball *)ball atIndex:(int)index placement:(int)placement;
-(void)checkForMatchingBalls:(int)index;
-(void)stopBallsFrom:(int)startIndex;
-(void)gameOver;
@end

//#define LEVEL_CREATION_MODE

@implementation Zuma

@synthesize frog;
@synthesize level;
@synthesize skull;

- (void)tapDownAt:(CGPoint)location {
#ifdef LEVEL_CREATION_MODE
        Ball *ball = [[Ball alloc] initWithPoint:location andColor:BALL_RAND_COLOR];
        [self addChild:ball];
        CCLOG(@"[NSValue valueWithCGPoint:CGPointMake(%d, %d)],", (int)location.x, (int)location.y);
#endif
    /* check if we tapped on the frog */
    if (CGRectContainsPoint(self.frog.boundingBox, location))
        return;

    float alpha = asinf((location.y - frog.position.y) / (ccpDistance(location, frog.position)));
    if (location.x < frog.position.x)
        alpha = M_PI - alpha;
    self.frog.rotation = -90-CC_RADIANS_TO_DEGREES(alpha);
}

- (void)tapMoveAt:(CGPoint)location {
    /* check if we tapped on the frog */
    if (CGRectContainsPoint(self.frog.boundingBox, location))
        return;

    float alpha = asinf((location.y - frog.position.y) / (ccpDistance(location, frog.position)));
    if (location.x < frog.position.x)
        alpha = M_PI - alpha;
    self.frog.rotation = -90-CC_RADIANS_TO_DEGREES(alpha);
}

- (void)tapUpAt:(CGPoint)location {
    /* check if we tapped on the frog */
    if (CGRectContainsPoint(self.frog.boundingBox, location)) {
        [self.frog swapBalls];
        return;
    }
    
    Ball *ball = [frog shoot];
    if (ball == nil)
        return;
    float alpha = asinf((location.y - frog.position.y) / (ccpDistance(location, frog.position)));
    if (location.x < frog.position.x)
        alpha = M_PI - alpha;
    ball.rotation = -90-CC_RADIANS_TO_DEGREES(alpha);
    ball.position = ccp(frog.position.x + 60*cos(alpha), frog.position.y+60*sin(alpha));
    [self addChild:ball];
    @synchronized (ballsShot) {
        [ballsShot addObject:ball];
    }


}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (paused)
        return NO;
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	[self tapDownAt:location];
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    if (paused)
        return;
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	[self tapMoveAt:location];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (paused)
        return;
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	[self tapUpAt:location];
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];

}


+(CCScene *)scene {
	CCScene *scene = [CCScene node];
	
	Zuma *zuma = [[[Zuma alloc] init] autorelease];
	
	[scene addChild: zuma];
	
	return scene;
    
}

- (id) init {
 

    if (self = [super init]) {
        self.isTouchEnabled = YES;
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        self.frog = [Frog frog];
        
        self.level = [Level level1];
        [self addChild:self.level];
        
        self.frog.position = self.level.frogPosition;
        
        DirectionalPoint *dp = [self.level deathPoint];
        self.skull = [Skull skullWithPosition:dp.point andRotation:90-dp.angle];
        [self addChild:self.skull];
        
        ballsRolling = [[NSMutableArray alloc] init];
        self.frog.ballsRolling = ballsRolling;
        
        ballsShot = [[NSMutableArray alloc] init];
        ballsCollisions = [[NSMutableArray alloc] init];
        ballsRollingBackwards = [[NSMutableArray alloc] init];

        [self addChild:self.frog];

#ifndef LEVEL_CREATION_MODE
        [self schedule:@selector(startRolling) interval:0.02];
#endif        
        CCMenuItemSprite *restartItem = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"RestartButton.png"]
                                                                selectedSprite:[CCSprite spriteWithFile:@"RestartButton.png"]
                                                                        target:self selector:@selector(restartAction)];
        CCMenuItemSprite *pauseItem = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"PauseButton.png"]
                                                                selectedSprite:[CCSprite spriteWithFile:@"PauseButton.png"]
                                                                        target:self selector:@selector(pauseAction)];
        
        CCMenu *restartMenu = [CCMenu menuWithItems:restartItem, pauseItem, nil];
        [restartMenu alignItemsVertically];
//        restartMenu.anchorPoint = ccp(1.0, 1.0);
        restartMenu.position = CGPointMake(SW-pauseItem.contentSize.width/2, SH-pauseItem.contentSize.height);
//        restartMenu.position = CGPointMake(SW/2,SH/2);
        [self addChild:restartMenu];
        
    }
    return  self;
}


-(void)restartAction {
    [[CCDirector sharedDirector] replaceScene:[Zuma scene]];
}


-(void)pauseAction {
    paused = !paused;
    if (paused)
        [[CCDirector sharedDirector] pause];
    else
        [[CCDirector sharedDirector] resume];
}

-(void)startRolling {
    
    if (ballsCount == level.startBallsCount) {
        [self unschedule:@selector(startRolling)];
        frog.canShoot = YES;
        Ball *ball0 = [ballsRolling objectAtIndex:0];
        ball0.speed = BALL_SPEED_NORMAL;
        [self schedule:@selector(gameCycle) interval:0.02];
        return;
    }
    
    Ball *ball0 = (ballsRolling.count > 0) ? [ballsRolling objectAtIndex:0] : nil;
    if ((ball0 && ball0.pos >= BS/STEP) || ball0==nil) {
        [self rollNewBall:BALL_SPEED_CRAZY];
    }
    
    [self pushBallsFrom:0 step:BALL_SPEED_CRAZY];
}

-(void)checkForCollisions {
    NSMutableArray *ballsToInsert = [NSMutableArray array];
    for (Ball *ballShot in ballsShot) {
        for (int i = 0; i < ballsRolling.count; i++) {
            Ball *ball = [ballsRolling objectAtIndex:i];
            if (ccpDistance(ballShot.position, ball.position) <= BS) {
                DirectionalPoint *nextPoint = [level pathPoint:ball.pos+BS/STEP];
                DirectionalPoint *prevPoint = [level pathPoint:ball.pos-BS/STEP];
                float distanceToNext = ccpDistance(ballShot.position, nextPoint.point);
                float distanceToPrev = ccpDistance(ballShot.position, prevPoint.point);
                if (distanceToNext > distanceToPrev) {
                    [self insertBall:ballShot atIndex:i placement:INSERT_BEFORE];
                } else {
                    [self insertBall:ballShot atIndex:i placement:INSERT_AFTER];
                }
                [ballsToInsert addObject:ballShot];

                break; 
            }
        }
    }
    for (Ball *ball in ballsToInsert) {
        [ballsShot removeObject:ball];
    }
}

-(void)insertBall:(Ball *)ball atIndex:(int)index placement:(int)placement {
    if (placement == INSERT_BEFORE) {
        Ball *prev = (index == 0) ? nil : [ballsRolling objectAtIndex:index-1];
        Ball *curr = [ballsRolling objectAtIndex:index];
        if (prev && curr.pos - prev.pos < 2 * BS / STEP) {
            ball.pos = prev.pos + BS/STEP;
            [ballsCollisions addObject:[BallCollision collisionWithBallShot:ball ballRoll:curr placement:INSERT_BEFORE]];
        } else {
            ball.pos = curr.pos - BS/STEP;
        }
    } else {
        Ball *curr = [ballsRolling objectAtIndex:index];
        Ball *next = (index == ballsRolling.count-1) ? nil : [ballsRolling objectAtIndex:index+1];
        if (next && next.pos - curr.pos < 2 * BS / STEP) {
            [ballsCollisions addObject:[BallCollision collisionWithBallShot:ball ballRoll:next placement:INSERT_AFTER]];
        }
        ball.pos = curr.pos + BS/STEP;
    }
    
    DirectionalPoint *p = [level pathPoint:ball.pos];
    CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.1 position:p.point];
    CCCallFuncN *ballInsertAction = [CCCallFuncN actionWithTarget:self selector:@selector(ballInserted:)];
    CCSequence *seq = [CCSequence actionOne:moveTo two:ballInsertAction];
    [ball runAction:seq];
    [[SimpleAudioEngine sharedEngine] playEffect:@"ballclick1.mp3"];
}

-(void)handleBallCollisions {
    for (int i = 0; i < ballsCollisions.count; i++) {
        BallCollision *collision = [ballsCollisions objectAtIndex:i];
        Ball *ball0 = collision.ballShot;
        Ball *ball1 = collision.ballRoll;
        float distance = ccpDistance(ball0.position, ball1.position);
        BOOL isCollision = distance < BS;
        int moveStep = 0;
        while (isCollision) {
            ++moveStep;
            if (ball1.pos+moveStep>=level.pathLength-1)
                break;
            DirectionalPoint *p = [level pathPoint:ball1.pos+moveStep];
            distance = ccpDistance(ball0.position, p.point);
            isCollision = distance < BS;
        }
        int index = [ballsRolling indexOfObject:ball1];
        if (index != NSNotFound) {
            ball1.speed = BALL_SPEED_ZERO;
            [self pushBallsFrom:index step:moveStep];
        }
    }
}

-(void)ballInserted:(Ball*)ball {
    int index = 0;
    for (; index < ballsRolling.count; index++) {
        if (((Ball*)[ballsRolling objectAtIndex:index]).pos > ball.pos) {
            break;
        }
    }
    
    [ballsRolling insertObject:ball atIndex:index];
    ball.speed = BALL_SPEED_ZERO;
    DirectionalPoint *p = [level pathPoint:ball.pos];
    ball.rotation = -p.angle+90;
    
    BallCollision *collision = nil;
    for (int i = 0; i < ballsCollisions.count; i++) {
        collision = [ballsCollisions objectAtIndex:i];
        if (ball == collision.ballShot) {
            [ballsCollisions removeObject:collision];
            break;
        }
    }
    
    Ball *prev = (index > 0) ? [ballsRolling objectAtIndex:index-1] : nil;
    Ball *next = (index < ballsRolling.count-1) ? [ballsRolling objectAtIndex:index+1] : nil;
    if (prev.ballColor == ball.ballColor && ball.pos - prev.pos > BS/STEP)
        [ballsRollingBackwards addObject:ball];
    if (next.ballColor == ball.ballColor && next.pos - ball.pos > BS/STEP)
        [ballsRollingBackwards addObject:next];

    [self checkForMatchingBalls:index];
}

-(void)checkForMatchingBalls:(int)index {
    if (index < 0 || index >= ballsRolling.count)
        return;
    
    Ball *ball = [ballsRolling objectAtIndex:index];
    NSMutableArray *sameColorBalls = [NSMutableArray arrayWithObject:ball];
    int smallestNotMatchedIndex = -1;
    for (int i = index-1; i >= 0; i--) {
        Ball *prev = [ballsRolling objectAtIndex:i];
        Ball *curr = [ballsRolling objectAtIndex:i+1];
        if (prev.ballColor == curr.ballColor && curr.pos - prev.pos <= BS/STEP)
            [sameColorBalls insertObject:prev atIndex:0];
        else {
            smallestNotMatchedIndex = i;
            break;
        }
    }
    
    for (int i = index+1; i < ballsRolling.count; i++) {
        Ball *next = [ballsRolling objectAtIndex:i];
        Ball *curr = [ballsRolling objectAtIndex:i-1];
        if (next.ballColor == curr.ballColor && next.pos - curr.pos <= BS/STEP)
            [sameColorBalls addObject:next];
        else
            break;
    }
    if (sameColorBalls.count >= 3) {
        for (Ball *ball in sameColorBalls) {
            [ballsRolling removeObject:ball];
            [self removeChild:ball cleanup:NO];
        }
        if (smallestNotMatchedIndex != -1 && smallestNotMatchedIndex < ballsRolling.count-1) {
            Ball *ball0 = [ballsRolling objectAtIndex:smallestNotMatchedIndex];
            Ball *ball1 = [ballsRolling objectAtIndex:smallestNotMatchedIndex+1];
            [self stopBallsFrom:smallestNotMatchedIndex+1];
            if (ball0.ballColor == ball1.ballColor) {
                [ballsRollingBackwards addObject:ball1];
            }
        }
        [[SimpleAudioEngine sharedEngine] playEffect:@"ballclick2.mp3"];

    }
}

-(void)handleBackwardBalls {
    NSMutableArray *ballsToRemove = [NSMutableArray array];
    for (int i = 0; i < ballsRollingBackwards.count; i++) {
        Ball *ball = [ballsRollingBackwards objectAtIndex:0];
        int index = [ballsRolling indexOfObject:ball];
        if (index == NSNotFound || index == 0) {
            [ballsToRemove addObject:ball];
            //CCLOG(@"SOMETHING STRANGE HAPPENED: index=%d", index);
            continue;
        }
        Ball *prev = [ballsRolling objectAtIndex:index-1];
        if (ball.ballColor == prev.ballColor) {
            ball.speed = BALL_SPEED_FAST_BACK;
            [self pushBallsFrom:index step:ball.speed];
            if (ball.pos - prev.pos <= BS/STEP) {
                [self checkForMatchingBalls:index];
                [ballsToRemove addObject:ball];
                [self stopBallsFrom:index];
            }
        } else {
            //ball.speed = prev.speed;
            //ball.speed = BALL_SPEED_ZERO;
            [self stopBallsFrom:index];
            [ballsToRemove addObject:ball];
        }
    }
    for (Ball *ball in ballsToRemove) {
        [ballsRollingBackwards removeObject:ball];
    }
}

-(void)handleShotBalls {
    NSMutableArray *ballsOffScreen = [NSMutableArray array];
    for (Ball *ball in ballsShot) {
        float alpha = CC_DEGREES_TO_RADIANS(180+ball.rotation);
        ball.position = ccp(ball.position.x + 20*sin(alpha), ball.position.y + 20*cos(alpha));
        if (ball.position.x < -BS/2 || ball.position.y < -BS/2
            || ball.position.x > SW+BS/2 || ball.position.y > SH+BS/2)
            [ballsOffScreen addObject:ball];
    }
    for (Ball *ball in ballsOffScreen) {
        [ballsShot removeObject:ball];
        [self removeChild:ball cleanup:YES];
    }
}

-(void)gameCycle {
    Ball *ball0 = (ballsRolling.count > 0) ? [ballsRolling objectAtIndex:0] : nil;
    if (ballsCount < level.totalBallsCount && ball0 && ball0.pos >= BS/STEP) {
        [self rollNewBall:ball0.speed];
    }

    if (ball0) {
        if (ball0.speed < BALL_SPEED_NORMAL)
            ball0.speed = BALL_SPEED_NORMAL;
        [self pushBallsFrom:0 step:ball0.speed];
    }
    
    @synchronized(ballsShot) {
        [self handleShotBalls];
        [self checkForCollisions];
    }
    
    [self handleBallCollisions];
    
    [self handleBackwardBalls];
    
    Ball *lastBall = [ballsRolling lastObject];

    if (lastBall && lastBall.pos >= level.pathLength-1) {
        //[self unschedule:@selector(gameCycle)];
        ball0.speed = BALL_SPEED_CRAZY;
        frog.canShoot = NO;
        [ballsRolling removeObject:lastBall];
        [self removeChild:lastBall cleanup:YES];
        //[self schedule:@selector(gameOver)];
    }
    
    [self.frog update];
}

-(void)rollNewBall:(BallSpeed)speed {
    DirectionalPoint *p0 = [level pathPoint:0];
    Ball *ball = [[[Ball alloc] initWithPoint:p0.point andColor:(arc4random() % level.colorCount)] autorelease];
    ball.rotation = -p0.angle+90;
    ball.speed = speed;
    [ballsRolling insertObject:ball atIndex:0];
    [self addChild:ball];
    ballsCount++;
}

-(void)pushBallsFrom:(int)startIndex step:(int)step {
    int i;
    for (i = startIndex; i < ballsRolling.count; i++) {
        Ball *ball = [ballsRolling objectAtIndex:i];
        ball.pos += step;
        DirectionalPoint *p = [level pathPoint:ball.pos];
        ball.position = p.point;
        ball.rotation = -p.angle+90;
        ball.speed = ((Ball*)[ballsRolling objectAtIndex:startIndex]).speed;
        if (i < ballsRolling.count-1) {
            Ball *next = [ballsRolling objectAtIndex:i+1];
            if (next.pos - (ball.pos-step) < BS/STEP)
                next.pos = ball.pos + BS/STEP - step;
            else if (next.pos - (ball.pos-step) > BS/STEP)
                break;
        }
    }
}

-(void)stopBallsFrom:(int)startIndex {
    for (int i = startIndex; i < ballsRolling.count; i++) {
        Ball *ball = [ballsRolling objectAtIndex:i];
        ball.speed = BALL_SPEED_ZERO;
    }
}

-(void)gameOver {
}

- (void)dealloc {
    self.level = nil;
    self.frog = nil;
    [super dealloc];
}

@end
