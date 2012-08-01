//
//  PhotosView.m
//  MultiPhoto
//
//  Created by Dhanush Balachandran on 6/22/12.
//  Copyright (c) 2012 My Things App Inc. All rights reserved.
//

#import "PhotosView.h"

@implementation PhotosView

@synthesize buttonRects;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.contentMode = UIViewContentModeRedraw;
        buttonRects = [NSMutableArray array];
    }
    return self;
}

- (void)awakeFromNib
{
    self.contentMode = UIViewContentModeRedraw;
    buttonRects = [NSMutableArray array];
}


# define OFFSET 5.0
- (void)drawRect:(CGRect)rect
{
    CGRect mybounds = [self bounds];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    [[UIColor lightGrayColor] setStroke];
    
    CGContextBeginPath (context);
    
    if (mybounds.size.width > mybounds.size.height) 
    {
        //Vertical Line 1
        CGContextMoveToPoint(context, mybounds.size.width/4, 0.0);
        CGContextAddLineToPoint(context,mybounds.size.width/4,mybounds.size.height);
        
        //Vertical Line 2
        CGContextMoveToPoint(context, mybounds.size.width/4*2, 0.0);
        CGContextAddLineToPoint(context,mybounds.size.width/4*2,mybounds.size.height);
        
        //Vertical Line 3
        CGContextMoveToPoint(context, mybounds.size.width/4*3, 0.0);
        CGContextAddLineToPoint(context,mybounds.size.width/4*3,mybounds.size.height);
        
        //Horizontal Line 
        CGContextMoveToPoint(context,0.0, mybounds.size.height/2);
        CGContextAddLineToPoint(context,mybounds.size.width, mybounds.size.height/2);
        
        [buttonRects removeAllObjects];
        
        //Top Row
        [buttonRects addObject:[NSValue valueWithCGRect:CGRectMake(0 + OFFSET, 0 + OFFSET, mybounds.size.width/4 - (2*OFFSET), mybounds.size.height/2 - (2*OFFSET))]];
        [buttonRects addObject:[NSValue valueWithCGRect:CGRectMake(mybounds.size.width/4 + OFFSET, 0 + OFFSET, mybounds.size.width/4 - (2*OFFSET), mybounds.size.height/2- (2*OFFSET))]]; 
        [buttonRects addObject:[NSValue valueWithCGRect:CGRectMake(mybounds.size.width/4*2 + OFFSET, 0 + OFFSET, mybounds.size.width/4 - (2*OFFSET), mybounds.size.height/2 - (2*OFFSET))]];
        [buttonRects addObject:[NSValue valueWithCGRect:CGRectMake(mybounds.size.width/4*3 + OFFSET, 0 + OFFSET, mybounds.size.width/4- (2*OFFSET), mybounds.size.height/2- (2*OFFSET))]];
        
        //Bottom Row
        [buttonRects addObject:[NSValue valueWithCGRect:CGRectMake(0 + OFFSET, mybounds.size.height/2 + OFFSET, mybounds.size.width/4 - (2*OFFSET), mybounds.size.height/2 - (2*OFFSET))]];
        [buttonRects addObject:[NSValue valueWithCGRect:CGRectMake(mybounds.size.width/4 + OFFSET, mybounds.size.height/2 + OFFSET, mybounds.size.width/4 - (2*OFFSET), mybounds.size.height/2- (2*OFFSET))]]; 
        [buttonRects addObject:[NSValue valueWithCGRect:CGRectMake(mybounds.size.width/4*2 + OFFSET, mybounds.size.height/2 + OFFSET, mybounds.size.width/4 - (2*OFFSET), mybounds.size.height/2 - (2*OFFSET))]];
        [buttonRects addObject:[NSValue valueWithCGRect:CGRectMake(mybounds.size.width/4*3 + OFFSET, mybounds.size.height/2 + OFFSET, mybounds.size.width/4- (2*OFFSET), mybounds.size.height/2- (2*OFFSET))]];
        
        

        
    }
    else 
    {
        //Vertical Line
        CGContextMoveToPoint(context, mybounds.size.width/2, 0.0);
        CGContextAddLineToPoint(context,mybounds.size.width/2,mybounds.size.height);
        
        //Horizontal Line 1
        CGContextMoveToPoint(context,0.0, mybounds.size.height/4);
        CGContextAddLineToPoint(context,mybounds.size.width, mybounds.size.height/4);
        
        //Horizontal Line 2
        CGContextMoveToPoint(context,0.0, mybounds.size.height/4 * 2);
        CGContextAddLineToPoint(context,mybounds.size.width, mybounds.size.height/4 * 2);
        
        //Horizontal Line 3
        CGContextMoveToPoint(context,0.0, mybounds.size.height/4 * 3);
        CGContextAddLineToPoint(context,mybounds.size.width, mybounds.size.height/4 * 3);
        
        [buttonRects removeAllObjects];
        
        //Column 1
        [buttonRects addObject:[NSValue valueWithCGRect:CGRectMake(0 + OFFSET, 0 + OFFSET, mybounds.size.width/2 - (2*OFFSET), mybounds.size.height/4 - (2*OFFSET))]];
        [buttonRects addObject:[NSValue valueWithCGRect:CGRectMake(mybounds.size.width/2 + OFFSET, 0 + OFFSET,  mybounds.size.width/2 - (2*OFFSET), mybounds.size.height/4 - (2*OFFSET))]]; 
        
        //Column 2
        [buttonRects addObject:[NSValue valueWithCGRect:CGRectMake(0 + OFFSET, mybounds.size.height/4 + OFFSET, mybounds.size.width/2 - (2*OFFSET), mybounds.size.height/4 - (2*OFFSET))]];
        [buttonRects addObject:[NSValue valueWithCGRect:CGRectMake(mybounds.size.width/2 + OFFSET, mybounds.size.height/4 + OFFSET,  mybounds.size.width/2 - (2*OFFSET), mybounds.size.height/4 - (2*OFFSET))]];
        
        //Column 3
        [buttonRects addObject:[NSValue valueWithCGRect:CGRectMake(0 + OFFSET, mybounds.size.height/4 * 2 + OFFSET, mybounds.size.width/2 - (2*OFFSET), mybounds.size.height/4 - (2*OFFSET))]];
        [buttonRects addObject:[NSValue valueWithCGRect:CGRectMake(mybounds.size.width/2 + OFFSET, mybounds.size.height/4*2 + OFFSET,  mybounds.size.width/2 - (2*OFFSET), mybounds.size.height/4 - (2*OFFSET))]];
        
        //Column 4
        [buttonRects addObject:[NSValue valueWithCGRect:CGRectMake(0 + OFFSET, mybounds.size.height/4 * 3 + OFFSET, mybounds.size.width/2 - (2*OFFSET), mybounds.size.height/4 - (2*OFFSET))]];
        [buttonRects addObject:[NSValue valueWithCGRect:CGRectMake(mybounds.size.width/2 + OFFSET, mybounds.size.height/4*3 + OFFSET,  mybounds.size.width/2 - (2*OFFSET), mybounds.size.height/4 - (2*OFFSET))]];
        
    }
    CGContextStrokePath(context);
    
}

#pragma mark - Print methods
- (void) printBounds: (CGRect) bound 
          fromMethod: (NSString *) methodname
{
    NSLog(@"%@: (Origin X: %f Origin Y: %f)  (Width:%f  Height:%f)", methodname, bound.origin.x,bound.origin.y,bound.size.width, bound.size.height);
}

- (void) printPoint: (CGPoint) point
         fromMethod: (NSString *) methodname
{
    NSLog(@"%@: (x1: %f y1: %f)",methodname, point.x, point.y);
}

- (void) printSize: (CGSize) mysize
        fromMethod: (NSString *) methodname
{
    NSLog(@"%@: (Width: %f Height: %f)",methodname, mysize.width, mysize.height);
}


@end
