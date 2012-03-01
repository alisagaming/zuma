//
//  DLGameMenu.m
//  BigZuma
//
//  Created by Andrej Syskaev on 14.02.12.
//  Copyright 2012 ch0wru@gmail.com. All rights reserved.
//

#import "DLMainMenu.h"
#import "MainMenuViewController.h"
#import "CCUIViewWrapper.h"

@implementation DLMainMenu

+(CCScene *)scene {
	CCScene *scene = [CCScene node];
	
    DLMainMenu *menu = [[[DLMainMenu alloc] init] autorelease];
	
    [scene addChild: menu];
	
    return scene;
    
}

- (id) init {
    
    if ((self = [super init] )) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        MainMenuViewController *vc = [[[MainMenuViewController alloc] init] retain];
        CCUIViewWrapper *wrapper = [CCUIViewWrapper wrapperForUIView:vc.view];
        wrapper.position = CGPointMake(0, winSize.height);
        
        [self addChild: wrapper];
    
    }
    return  self;
}

- (void)dealloc {
    [super dealloc];
}

@end