//
//  photoButton.m
//  MultiPhoto
//
//  Created by Dhanush Balachandran on 6/23/12.
//  Copyright (c) 2012 My Things App Inc. All rights reserved.
//

#import "photoButton.h"

@interface photoButton ()
{
    UIView * tempView;
}

@end

@implementation photoButton

@synthesize position = _position;

- (void)setPosition: (NSNumber*) position
{
    _position = position;
    
    switch ([position intValue])
    {
        case FIRST_EMPTY:
            [self setImage:[UIImage imageNamed:@"addphoto"] forState:UIControlStateNormal];
            self.enabled = YES;
            self.alpha = 1.0;
            break;
            
        case OTHER_EMPTY:
            [self setImage:[UIImage imageNamed:@"addphoto"] forState:UIControlStateNormal];
            self.enabled = NO;
            self.alpha = 0.1;
            break;
            
        default:
            self.enabled = YES;
            self.alpha = 1.0;
            break;
            
    }
}


- (void) updateScreenPosition: (CGRect) coors
{
    self.frame = coors;
}

- (void) updatePhoto: (UIImage*) photo
        withPosition: (int) position
{
    self.position = [NSNumber numberWithInt: position];
    [self setImage:photo forState:UIControlStateNormal];
}

- (void) updatePosition:(int)position
{
    _position = [NSNumber numberWithInt:position];
}

- (NSString *)description
{
    if ([_position isEqualToNumber:[NSNumber numberWithInt:FIRST_EMPTY]] || [_position isEqualToNumber:[NSNumber numberWithInt:OTHER_EMPTY]]) {
        return @"Empty Button";
    }
    else {
        return [NSString stringWithFormat:@"Button at %@",_position];
    }
}

- (void) showXinView: (UIView *) newView
{
    tempView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"deletephoto"]];
    tempView.frame = self.frame;
    tempView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.25, 0.25);
    tempView.alpha = 1.0;
    tempView.contentMode = UIViewContentModeScaleAspectFill;
    [newView addSubview:tempView];
}

- (void) removeX
{
    [tempView removeFromSuperview];
    tempView = nil;
}
@end
