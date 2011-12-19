//
//  Bezier.m
//  BigZuma
//
//  Created by Kirill Kuvaldin on 29.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

// code partially taken from zuxor-game project

#import "Bezier.h"

@implementation Bezier

@synthesize step;

-(float) s:(float)t {
    return sqrtf(a * t * t + b * t + c);
}

-(float) L:(float)t {
    float temp1 = sqrtf(c + t*(b+a*t));
    float temp2 = 2*a*t*temp1 + b*(temp1-sqrtf(c));
    float temp3 = logf(b + 2 * sqrtf(a) * sqrtf(c));
    float temp4 = logf(b + 2 * a * t + 2 * sqrt(a) * temp1);
    float temp5 = 2 * sqrtf(a) * temp2;
    float temp6 = (b * b - 4 * a * c) * (temp3 - temp4);
    return (temp5+temp6)/(8*powf(a, 1.5));
}

-(float) invertL:(float)t :(float)l {
    float t1 = t;
    float t2;
    for(;;)
    {
        t2 = t1 - ([self L:t1] - l)/[self s:t1];
        if (fabs(t1-t2) < 0.0001) break;
        t1 = t2;
    }
    return t2;
    
}

-(id)initWith:(CGPoint)_p0 :(CGPoint)_p1 :(CGPoint)_p2 :(float)speed {
    if (self = [super init]) {
        p0 = _p0;
        p1 = _p1;
        p2 = _p2;
        
        ax = p0.x - 2 * p1.x + p2.x;
        ay = p0.y - 2 * p1.y + p2.y;
        bx = 2 * p1.x - 2 * p0.x;
        by = 2 * p1.y - 2 * p0.y;
        a = 4*(ax * ax + ay * ay);
        b = 4*(ax * bx + ay * by);
        c = bx * bx + by * by;
        //NSLog(@"a=%f, b=%f, c=%f", a, b, c);
        total_length = [self L:1];
        step = floor(total_length / speed);
        if ((int)total_length % (int)speed > speed / 2)
            step++;
        
    }
    return self;
}

-(DirectionalPoint *)getAnchorPoint:(float)findex {
    if (findex >= 0 && findex <= step)
    {
        float t = findex/step;
        float l = t*total_length;
        t = [self invertL:t :l];
        
        float xx = (1 - t) * (1 - t) * p0.x + 2 * (1 - t) * t * p1.x + t * t * p2.x;
        float yy = (1 - t) * (1 - t) * p0.y + 2 * (1 - t) * t * p1.y + t * t * p2.y;
        
        CGPoint q0 = CGPointMake((1 - t) * p0.x + t * p1.x, (1 - t) * p0.y + t * p1.y);
        CGPoint q1 = CGPointMake((1 - t) * p1.x + t * p2.x, (1 - t) * p1.y + t * p2.y);
        
        float dx = q1.x - q0.x;
        float dy = q1.y - q0.y;
        float radians = atan2f(dy, dx);
        float degrees = radians * 180 / M_PI;
        
        return [[DirectionalPoint alloc] initWithPoint:CGPointMake(xx, yy) angle:degrees];
    } else
        return nil;
}

@end
