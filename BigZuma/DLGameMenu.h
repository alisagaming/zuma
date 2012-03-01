//
//  DLGameMenu.h
//  BigZuma
//
//  Created by Andrej Syskaev on 14.02.12.
//  Copyright 2012 ch0wru@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol DLGameMenuProtocol <NSObject>
    -(void) pauseAction;
    -(void) restartAction;
    -(void) goMainMenuAction;
@end

@interface DLGameMenu : CCLayerColor {
    
}

@property (nonatomic, retain) id<DLGameMenuProtocol> delegate;

@end
