//
//  GSProgressView.m
//
//  Created by Simon Whitaker on 14/11/2012.
//  Copyright (c) 2012 Goo Software Ltd. All rights reserved.
//

#import "GSProgressView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GSProgressView

- (void)commonInit
{
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    if (progress > 1.0) progress = 1.0;
    
    if (progress != _progress) {
        _progress = progress;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
   UIColor *color = [UIColor colorWithHue:self.progress saturation:self.progress brightness:self.progress alpha:1];
    
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGFloat radius = MIN(rect.size.width, rect.size.height)/2;
    
    // Start a path
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // Move to centre and draw an arc.
    [path moveToPoint:center];
    [path addArcWithCenter:center
                    radius:radius
                startAngle:0 - M_PI_2 // zero degrees is east, not north, so subtract pi/2
                  endAngle:2 * M_PI * self.progress - M_PI_2 // ditto
                 clockwise:YES];
    [path closePath];
    
    // If you want to show a tick mark use this if statement
    // If progress is 1.0, show a tick mark in the centre of the circle
    if (0/*self.progress == 1.0*/) //USE THIS IF STATEMENT FOR SHOWING A TICK MARK WHEN DONE.
    {
        /*
         First draw a tick that looks like this:
         
         A---F
         |   |
         |   E-------D
         |           |
         B-----------C
         
         (Remember: (0,0) is top left)
         */
        UIBezierPath *tickPath = [UIBezierPath bezierPath];
        CGFloat tickWidth = radius/3;
        [tickPath moveToPoint:CGPointMake(0, 0)];                            // A
        [tickPath addLineToPoint:CGPointMake(0, tickWidth * 2)];             // B
        [tickPath addLineToPoint:CGPointMake(tickWidth * 3, tickWidth * 2)]; // C
        [tickPath addLineToPoint:CGPointMake(tickWidth * 3, tickWidth)];     // D
        [tickPath addLineToPoint:CGPointMake(tickWidth, tickWidth)];         // E
        [tickPath addLineToPoint:CGPointMake(tickWidth, 0)];                 // F
        [tickPath closePath];
        
        // Now rotate it through -45 degrees...
        [tickPath applyTransform:CGAffineTransformMakeRotation(-M_PI_4)];
        
        // ...and move it into the right place.
        [tickPath applyTransform:CGAffineTransformMakeTranslation(radius * 0.43, radius)];
        
        // Account for non-square views
        CGFloat xOffset = rect.size.width/2 - radius;
        CGFloat yOffset = rect.size.height/2 - radius;
        [tickPath applyTransform:CGAffineTransformMakeTranslation(xOffset, yOffset)];
        
        // Add the tick path to the existing circle path
        [path appendPath:tickPath];
    };
    
    
    path.usesEvenOddFillRule = YES;
    
    [color setFill];
    [path fill];
}

@end
