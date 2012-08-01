//
//  photoButton.h
//  MultiPhoto
//
//  Created by Dhanush Balachandran on 6/23/12.
//  Copyright (c) 2012 My Things App Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FIRST_EMPTY 50
#define OTHER_EMPTY 100

@interface photoButton : UIButton

@property (nonatomic, strong) NSNumber * position;

- (void) updateScreenPosition: (CGRect) coors;

- (void) updatePhoto: (UIImage*) photo
        withPosition: (int) position;

- (void) updatePosition: (int) position;

- (void) showXinView: (UIView *) newView;

-(void) removeX;

-(NSString *)description;

@end
