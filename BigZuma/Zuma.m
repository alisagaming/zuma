//
//  Zuma.m
//  BigZuma
//
//  Created by Kirill Kuvaldin on 28.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Zuma.h"
#import "Ball.h"
#import "Level.h"
#import "Bezier.h"
#import "BallCollision.h"
#import "SimpleAudioEngine.h"
#import "DLGameMenu.h"
#import "DLGameOverMenu.h"
#import "DLMainMenu.h"
#import "AdWhirlView.h"
#import "CCUIViewWrapper.h"

const CGFloat kMinMove = 30;

@interface Zuma (Private)
-(void)pushBallsFrom:(int)startIndex step:(int)step;
-(void)rollNewBall:(BallSpeed)speed;
-(void)insertBall:(Ball *)ball atIndex:(int)index placement:(int)placement;
-(void)checkForMatchingBalls:(int)index;
-(void)stopBallsFrom:(int)startIndex;
-(void)gameOver;
@end

// #define LEVEL_CREATION_MODE

@implementation Zuma

@synthesize frog;
@synthesize level;
@synthesize skull, menuLayer, overMenuLayer, scoreLabel;

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
    //ball.rotation = -90-CC_RADIANS_TO_DEGREES(alpha);
    ball.rotation = 180;
    //ball.position = ccp(frog.position.x + 60*cos(alpha), frog.position.y+60*sin(alpha));
    ball.position = ccp(frog.position.x, frog.position.y+60);
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
	beganPoint = location;
    prevMovePoint = beganPoint;
    
    //[self tapDownAt:location];
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    if (paused)
        return;
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	
    CGFloat dx = fabsf(beganPoint.x - location.x);
    CGFloat dy = fabsf(beganPoint.y - location.y);
    
    if(sqrtf(dx*dx+dy*dy) > kMinMove ) {
        [frog stopAllActions];
        location.y = 100;
        NSInteger t=location.x;
        location.x = frog.position.x+(location.x-prevMovePoint.x);
        prevMovePoint.x = t;
        if(location.x <= 81)
            location.x = 81;
        if(location.x >= 1024-81)
            location.x = 1024-81;
        frog.position = location;
    }
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (paused)
        return;
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];

    CGFloat dx = fabsf(beganPoint.x - location.x);
    CGFloat dy = fabsf(beganPoint.y - location.y);
    
    if( sqrtf(dx*dx+dy*dy) < kMinMove ) {
        [self tapUpAt:location];  
    }
	
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];

}




////////////////////////////////////////////////////////////////////////////////////////////////




- (id) initForLevel:(int)levelNumber {
 

    if (self = [super init]) {
        
        self.isTouchEnabled = YES;
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        self.frog = [Frog frog];
        
        if(levelNumber == 1)
            self.level = [Level level1];
        else if(levelNumber == 2)
            self.level = [Level level2];
        else if(levelNumber == 3)
            self.level = [Level level3];
        
        [self addChild:self.level];
        
        self.frog.position = self.level.frogPosition;
        self.frog.rotation = 0;
        
        DirectionalPoint *dp = [self.level deathPoint];
        self.skull = [Skull skullWithPosition:dp.point andRotation:90-dp.angle];
        [self addChild:self.skull];
        
        ballsRolling = [[NSMutableArray alloc] init];
        self.frog.ballsRolling = ballsRolling;
        
        ballsShot = [[NSMutableArray alloc] init];
        ballsCollisions = [[NSMutableArray alloc] init];
        ballsRollingBackwards = [[NSMutableArray alloc] init];

        [self addChild:self.frog];

        canMove = YES;
        
#ifndef LEVEL_CREATION_MODE
        [self schedule:@selector(startRolling) interval:0.02];
#endif  
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *bar = [CCSprite spriteWithFile: @"bar.png"];
        bar.position = ccp(winSize.width /2.0, 32);
        [self addChild:bar];

        CCSprite *scoreField = [CCSprite spriteWithFile: @"score_field.png"];
        scoreField.position = ccp(870, 32);
        [self addChild:scoreField];
        
        scoreLabel = [[CCLabelTTF alloc] initWithString:@"" fontName:@"kablam!_" fontSize:30.0];
        scoreLabel.position = ccp(870, 32);
        scoreLabel.color = ccc3(0, 0, 0);
        [self addChild:scoreLabel];
        
        [scoreLabel setString:[NSString stringWithFormat:@"%d", score]];
        
        CCMenuItemSprite *restartItem = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"replay-btn.png"]
                                                                selectedSprite:[CCSprite spriteWithFile:@"replay-btn.png"]
                                                                        target:self selector:@selector(restartAction)];
        CCMenuItemSprite *pauseItem = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"paused-btn.png"]
                                                                selectedSprite:[CCSprite spriteWithFile:@"paused-btn.png"]
                                                                        target:self selector:@selector(pauseAction)];
        
        CCMenu *restartMenu = [CCMenu menuWithItems:restartItem, pauseItem, nil];
        [restartMenu alignItemsHorizontallyWithPadding:winSize.width /2.0];
        
        restartMenu.position = CGPointMake(370, 32);
        [self addChild:restartMenu];
        
        bannerView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
        //[[[CCDirector sharedDirector] openGLView] addSubview:bannerView];
        CCUIViewWrapper *wrapper = [CCUIViewWrapper wrapperForUIView:bannerView];
        wrapper.position = CGPointMake(0, winSize.height);
        [self addChild:wrapper z:100];
        
    }
    return  self;
}

- (void)adWhirlDidReceiveAd:(AdWhirlView *)adView {
	
    // adjust frame
	CGRect frame = bannerView.frame;
	frame.origin.x = 210;
	frame.origin.y = 710;
	bannerView.frame = frame;
	
    NSLog(@"\n!!!\n\n");
    
	// fade in
	bannerView.alpha = 0.0f;
	[UIView beginAnimations:@"adWhirlDidReceiveAd" context:nil];
	bannerView.alpha = 1.0f;
	[UIView commitAnimations];
}


- (NSString *)adWhirlApplicationKey {
	return @"9e7eeb4e4b8842feb0402688635de4c8";
}

- (UIViewController *)viewControllerForPresentingModalView {
    return [[[UIApplication sharedApplication] keyWindow] rootViewController];
}


+(CCScene *)sceneForLevel:(int)levelNumber {
	CCScene *scene = [CCScene node];
	
	Zuma *zuma = [[[Zuma alloc] initForLevel:levelNumber] autorelease];
	
	[scene addChild: zuma];
	
    [[CCDirector sharedDirector] resume];
    
	return scene;
    
}

-(void)restartAction {
    [self removeAllChildrenWithCleanup:YES];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[Zuma sceneForLevel:[level levelNumber]]];
}


-(void)pauseAction {
    
    paused = !paused;
    if (paused) {
        [[CCDirector sharedDirector] pause];
        
        self.menuLayer = [[[DLGameMenu alloc] init] autorelease];
        self.menuLayer.delegate =self;
        
        [self addChild:menuLayer z:20];
    }
    else {
        if (self.menuLayer)
            [self removeChild:self.menuLayer cleanup:YES];
        [[CCDirector sharedDirector] resume];
    }
}

-(void)goMainMenuAction {
    
    [[CCDirector sharedDirector] replaceScene:[DLMainMenu scene]];
    
}


///////////////////////////////////////////////////////////////////////////////////////////////





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
            
            CGPoint bp = ccp(ball.position.x, ball.position.y);
            CCLabelTTF *flyScore = [[CCLabelTTF alloc] initWithString:@"100" fontName:@"kablam!_" fontSize:20.0];
            flyScore.position = ccp(bp.x, bp.y);
            flyScore.color = ccc3(0, 0, 0);
            [self addChild:flyScore];
            [flyScore runAction: [CCMoveTo actionWithDuration:2 position:ccp(1500, -200)]];
            
            [ballsRolling removeObject:ball];
            [self removeChild:ball cleanup:NO];
            score+=100;
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
    
    [scoreLabel setString:[NSString stringWithFormat:@" %d ", score]];
    
    [self handleBallCollisions];
    
    [self handleBackwardBalls];
    
    Ball *lastBall = [ballsRolling lastObject];

    if (lastBall && lastBall.pos >= level.pathLength-1) {
        [self unschedule:@selector(gameCycle)];
        ball0.speed = BALL_SPEED_VERY_CRAZY;
        frog.canShoot = NO;
        [ballsRolling removeObject:lastBall];
        [self removeChild:lastBall cleanup:YES];
        [self gameOver];
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
    
    [[CCDirector sharedDirector] pause];
    
    self.overMenuLayer = [[[DLGameOverMenu alloc] initWithScore:score] autorelease];
    self.overMenuLayer.delegate = self;
    
    [self addChild:overMenuLayer z:20];
    
}

- (void)dealloc {
    self.level = nil;
    self.frog = nil;
    [super dealloc];
}

@end
