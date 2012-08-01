//
//  ViewController.h
//  MultiPhoto
//
//  Created by Dhanush Balachandran on 6/22/12.
//  Copyright (c) 2012 My Things App Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PhotosView.h"
#import "photoButton.h"

@protocol MultiPhotoVCDelegate <NSObject>

- (void) finishedWithPicArray: (NSArray*) image
                         from:(id) sender;

@end

@interface MultiPhotoVC : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet PhotosView *drawingView;

@property (weak, nonatomic) id<MultiPhotoVCDelegate> delegate;  //Delegate to return the final picture array

@end
