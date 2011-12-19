//
//  Bezier.h
//  BigZuma
//
//  Created by Kirill Kuvaldin on 29.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DirectionalPoint.h"

@interface Bezier : NSObject {
    CGPoint p0;
    CGPoint p1;
    CGPoint p2;
    int step;
    int ax;
    int ay;
    int bx;
    int by;
    float a;
    float b;
    float c;
    float total_length;
}

-(id)initWith:(CGPoint)_p0 :(CGPoint)_p1 :(CGPoint)_p2 :(float)speed;
-(DirectionalPoint *)getAnchorPoint:(float)findex;
@property (nonatomic, assign) int step;

@end
