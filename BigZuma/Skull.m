//
//  Skull.m
//  BigZuma
//
//  Created by Kirill Kuvaldin on 03.11.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Skull.h"


@implementation Skull

+(id)skullWithPosition:(CGPoint)position andRotation:(float)rotation {
    Skull *skull = [[Skull alloc] initWithFile:@"Skull.png"];
    skull.position = position;
    skull.rotation = rotation;
    return [skull autorelease];
}

@end
