//
//  ViewController.m
//  MultiPhoto
//
//  Created by Dhanush Balachandran on 6/22/12.
//  Copyright (c) 2012 My Things App Inc. All rights reserved.
//

#import "MultiPhotoVC.h"

#define MAX_PHOTOS 8

@interface MultiPhotoVC ()
{
    NSMutableArray * buttonArray; //Assumption: ButtonArray always holds a valid list of buttons with current positions
    
    BOOL organizeFlag;
    BOOL deleteFlag;
    
    UIBarButtonItem * deleteButton;
    UIBarButtonItem * orgButton;
    
    photoButton * currPhotoButton;
    
    UIImagePickerController * imagePicker;
    int totalNoOfPhotos;
    
    NSMutableArray * selectArray; //Contains the temporary list of pictures to be deleted
    NSMutableDictionary * positionDict; //Contains the temporary rearrange configurations
}

@end

@implementation MultiPhotoVC
@synthesize drawingView;
@synthesize delegate;

//Call this function to return final picture array back to your App through Delegate
- (void) returnFinalPicArray
{
    NSMutableArray * tempArray;
    if (!totalNoOfPhotos)
    {
        tempArray = nil;
    }
    else
    {   tempArray = [NSMutableArray array];
        for (int i = 0; i < totalNoOfPhotos ; i++)
        {
            photoButton * tempbutton = [buttonArray objectAtIndex:i];
            [tempArray addObject:tempbutton.imageView.image];
        }
    }
    
    [self.delegate finishedWithPicArray:tempArray from:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    
    //Set up Bar Buttons
    deleteButton = 
    //[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deletePressed:)];
    [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonSystemItemTrash target:self action:@selector(deletePressed:)];
    
    orgButton = 
    //[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(orgPressed:)];
    [[UIBarButtonItem alloc] initWithTitle:@"Rearrange" style:UIBarButtonItemStylePlain target:self action:@selector(orgPressed:)];
    
    orgButton.tintColor = [UIColor blackColor];
    deleteButton.tintColor = [UIColor blackColor];
    
    NSMutableArray * myarray = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
    [myarray addObject:orgButton];
    self.navigationItem.leftBarButtonItems = myarray;
    
    myarray = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
    [myarray addObject:deleteButton];
    self.navigationItem.rightBarButtonItems = myarray;
    
    selectArray = [NSMutableArray array];
    positionDict = [NSMutableDictionary dictionary];
}


#define NO_OF_PHOTOS 0 //Change this to [1-8] for populating dummy photos

-(void)viewDidAppear:(BOOL)animated 
{
    
    //If there is no button array one will be created
    if (!buttonArray)
    {
        buttonArray = [NSMutableArray array];
        
        for (int i = 0; i< MAX_PHOTOS; i++)
        {
            photoButton * tempButton = [[photoButton alloc] init];
            
            NSValue * temp = [drawingView.buttonRects objectAtIndex:i];
            //tempButton.position = (i == 0) ? [NSNumber numberWithInt: FIRST_EMPTY] : [NSNumber numberWithInt:OTHER_EMPTY];
            
            if (i < NO_OF_PHOTOS) 
            {
                NSString * mystr = [NSString stringWithFormat:@"Pic%d",(i+1)];
                [tempButton updatePhoto:[UIImage imageNamed:mystr] withPosition:i];
            }
            else 
            {
                tempButton.position = (i == NO_OF_PHOTOS) ? [NSNumber numberWithInt: FIRST_EMPTY] : [NSNumber numberWithInt:OTHER_EMPTY];
            }
            
            tempButton.imageView.clipsToBounds = YES;
            tempButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            tempButton.adjustsImageWhenDisabled = NO;
            //tempButton.adjustsImageWhenHighlighted = NO;
            
            [tempButton addTarget:self action:@selector(photoMoved:forEvent:) forControlEvents:UIControlEventAllTouchEvents];
            [tempButton addTarget:self action:@selector(photoClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            tempButton.frame = temp.CGRectValue;
            [drawingView addSubview:tempButton];
            [buttonArray addObject:tempButton];
        }
        
        //update total no of photos
        NSMutableArray * tempArray = [NSMutableArray arrayWithArray:buttonArray];
        [tempArray filterUsingPredicate:[NSPredicate predicateWithFormat:@"position < %@",[NSNumber numberWithInt:MAX_PHOTOS]]];
        totalNoOfPhotos = [tempArray count];
        
        //update bar buttons
        [self updateBarButtons];
        
        //Set the orgDict
        [self resetOrgDictionary];
    }
}

- (void)viewDidUnload
{
    [self setDrawingView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    for (int i = 0; i< MAX_PHOTOS; i++)
    {
        photoButton * tempButton = [buttonArray objectAtIndex:i];
         NSValue * temp = [drawingView.buttonRects objectAtIndex:i];
        tempButton.frame = temp.CGRectValue;
    }
    [self.view setNeedsDisplay];
        
}

//Resets all the buttons from buttonArray
- (void) resetOrgDictionary
{
    [positionDict removeAllObjects];
    for (int i = 0; i< MAX_PHOTOS ;i ++)
    {
        [positionDict setObject:[buttonArray objectAtIndex:i] forKey:[NSString stringWithFormat:@"%d",i]];
    }
}

#pragma mark - Button Actions                            
- (IBAction)deletePressed:(id)sender
{
    if (!deleteFlag) 
    {
        deleteFlag = YES;
        deleteButton.tintColor = [UIColor redColor];
        [deleteButton setTitle:@"Done"];
        [self disableFirstEmpty];
        [selectArray removeAllObjects];
    }
    else 
    {
        deleteFlag = NO;
        deleteButton.tintColor = [UIColor blackColor];
        [deleteButton setTitle:@"Delete"];
        
        //The delete loop
        for (photoButton * tempButton in selectArray)
        {
            tempButton.position = [NSNumber numberWithInt:OTHER_EMPTY];
            [tempButton removeX];
        }
        [self updateButtonArray];
        [self enableFirstEmpty];
    }
    [self updateBarButtons];
    
}

-(IBAction)orgPressed:(id)sender
{
    if (!organizeFlag) 
    {
        organizeFlag = YES;
        orgButton.tintColor = [UIColor redColor];
        [orgButton setTitle:@"Done"];
        [self disableFirstEmpty];
        [self animateView:[buttonArray objectAtIndex:0]];
        
    }
    else 
    {
        organizeFlag = NO;
        [orgButton setTitle:@"Rearrange"];
        orgButton.tintColor = [UIColor blackColor];
        
        //Org Loop
        for (int i = 0; i < totalNoOfPhotos; i++)
        {
            photoButton * tempButton = [positionDict objectForKey:[NSString stringWithFormat:@"%d",i]];
            tempButton.position = [NSNumber numberWithInt:i];
        }
        
        [self updateButtonArray];
        [self enableFirstEmpty];
    }
    
    [self updateBarButtons];

}

- (IBAction)canxPressed:(id)sender 
{
    orgButton.tintColor = [UIColor blackColor];
    deleteButton.tintColor = [UIColor blackColor];
    [deleteButton setTitle:@"Delete"];
    [orgButton setTitle:@"Rearrange"];
    deleteFlag = NO;
    organizeFlag = NO;
    [self resetButtonArray];
    [self updateBarButtons];
}

- (IBAction)photoClicked:(photoButton*)sender
{
    if (!organizeFlag && ! deleteFlag) 
    {
        currPhotoButton = sender;
        if (!imagePicker) {
            imagePicker = [[UIImagePickerController alloc] init];
        }
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentModalViewController:imagePicker animated:YES];
        
    }
    else if (deleteFlag)
    {
        if ([selectArray containsObject:sender]) 
        {
            //Already flagged for delete so removing
            sender.alpha = 1.0;
            [sender removeX];
            [selectArray removeObject:sender];
        }
        else 
        {   
            //Newly flagged for delete
            sender.alpha = 0.1;
            [sender showXinView:self.view];
            [selectArray addObject:sender];
        }
    }

}

- (void) updateBarButtons
{
    if (organizeFlag)
    {
        deleteButton.enabled = NO;
    }
    else if (deleteFlag) 
    {
        orgButton.enabled = NO;
    }
    else 
    {
        orgButton.enabled = (totalNoOfPhotos > 1) ? YES : NO;
        deleteButton.enabled = (totalNoOfPhotos > 0) ? YES : NO;
    }

}

#pragma mark - Update Button Array
- (void) updateButtonArray
{
    NSMutableArray * tempArray = [NSMutableArray arrayWithArray:buttonArray];
    NSArray * myarray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES selector:nil]];
    [tempArray sortUsingDescriptors:myarray];
    
    int lastposition = -200;
    //traverse through the array
    for (int i = 0; i < MAX_PHOTOS; i++)
    {
        //Update the photos' positions
        photoButton * tempButton = [tempArray objectAtIndex:i];
        
        //Reset the position number
        tempButton.position = ([tempButton.position intValue]>MAX_PHOTOS) ? [NSNumber numberWithInt:OTHER_EMPTY] : [NSNumber numberWithInt:i];
        
        if ([tempButton.position intValue] > MAX_PHOTOS && (lastposition >=0 && lastposition < MAX_PHOTOS))
        {
            tempButton.position = [NSNumber numberWithInt:FIRST_EMPTY];
        }
        
        
        lastposition = [tempButton.position intValue];
        
    }
    
    UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;
    [UIView animateWithDuration:0.1 delay:0 options:options animations:^{
    
    for (int i = 0; i < MAX_PHOTOS; i++)
    {
        //Update the photos' positions
        photoButton * tempButton = [tempArray objectAtIndex:i];
        NSValue * temp = [drawingView.buttonRects objectAtIndex:i];
        tempButton.frame = temp.CGRectValue;
    }
    }completion:^(BOOL finished){}];
    
    
    buttonArray = [NSMutableArray arrayWithArray:tempArray];
    // NSLog(@"%@",buttonArray);
    
    //Updating totalNoOfPhotos
    
    [tempArray filterUsingPredicate:[NSPredicate predicateWithFormat:@"position < %@",[NSNumber numberWithInt:MAX_PHOTOS]]];
    totalNoOfPhotos = [tempArray count];
    
    //Update buttons
    if (!totalNoOfPhotos) 
    {
        photoButton * tempButton = [buttonArray objectAtIndex:0];
        tempButton.position = [NSNumber numberWithInt:FIRST_EMPTY];
    }
    
    [self resetOrgDictionary];
}

#pragma mark - Reset Button Array
- (void) resetButtonArray
{
    int lastposition = -200;
    
    //traverse through the array
    for (int i = 0; i < MAX_PHOTOS; i++)
    {
        photoButton * tempButton = [buttonArray objectAtIndex:i];
        
        //Reset the position number
        tempButton.position = ([tempButton.position intValue]>MAX_PHOTOS) ? [NSNumber numberWithInt:OTHER_EMPTY] : [NSNumber numberWithInt:i];
        
        NSValue * temp = [drawingView.buttonRects objectAtIndex:i];
        tempButton.frame = temp.CGRectValue;
        
        if ([tempButton.position intValue] > MAX_PHOTOS && (lastposition >=0 && lastposition < MAX_PHOTOS))
        {
            tempButton.position = [NSNumber numberWithInt:FIRST_EMPTY];
        }
        
        lastposition = [tempButton.position intValue];
    }
    
    [buttonArray makeObjectsPerformSelector:@selector(removeX)];
    [self resetOrgDictionary];
    
}

#pragma mark - Update First Empty Button
- (void) disableFirstEmpty
{
    NSMutableArray * tempArray = [NSMutableArray arrayWithArray:buttonArray];
    [tempArray filterUsingPredicate:[NSPredicate predicateWithFormat:@"position = %@",[NSNumber numberWithInt:FIRST_EMPTY]]];
    if([tempArray count]) 
    {
        photoButton * tempButton = [tempArray objectAtIndex:0];
        tempButton.position = [NSNumber numberWithInt:OTHER_EMPTY];
    }
    for (int i = 0; i <MAX_PHOTOS; i++)
    {
        photoButton * tempButton = [buttonArray objectAtIndex:i];
        tempButton.adjustsImageWhenHighlighted = NO;
    }
    
}

- (void) enableFirstEmpty
{
    int lastposition = -200;
    
    //traverse through the array
    for (int i = 0; i < MAX_PHOTOS; i++)
    {
        photoButton * tempButton = [buttonArray objectAtIndex:i];
        if ([tempButton.position intValue] > MAX_PHOTOS && (lastposition >=0 && lastposition < MAX_PHOTOS))
        {
            tempButton.position = [NSNumber numberWithInt:FIRST_EMPTY];
        }
        
        lastposition = [tempButton.position intValue];
        
        tempButton.adjustsImageWhenHighlighted = YES;
        if ([tempButton.position intValue] < MAX_PHOTOS) 
        {
            tempButton.alpha = 1.0;
        }
    }
    
}

#pragma mark - Image Picker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    int photoIndex = [buttonArray indexOfObject:currPhotoButton];
    [currPhotoButton updatePhoto:[self shrinkImage:image] withPosition:photoIndex];
    [self updateButtonArray];
    [self updateBarButtons];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Photo Mover
- (IBAction)photoMoved:(photoButton *)sender forEvent:(UIEvent *)event 
{
    if (organizeFlag && [sender.position intValue] < MAX_PHOTOS) 
    {
        UITouch * touchOnButton = [[event allTouches] anyObject];
        CGPoint point = [touchOnButton locationInView:drawingView];
        photoButton *control = sender;
        control.center = CGPointMake(point.x, point.y);
        [drawingView bringSubviewToFront:control];
        
        int currLocation = [self currButtonLocation:point];
        NSString * origloc = [[positionDict allKeysForObject:sender] objectAtIndex:0];
        int origLocation = [origloc intValue];
        
        NSMutableDictionary * tempDict = [NSMutableDictionary dictionaryWithDictionary:positionDict];
        
        //Checking if the button is enabled
        photoButton * currLocButton = [buttonArray objectAtIndex:currLocation];
        if ([currLocButton.position intValue] < MAX_PHOTOS) 
        {
            NSArray * configArray = [self configurationForOriginalLocation:origLocation toNewLocation:currLocation];
            
            for (int i = 0; i < totalNoOfPhotos;i++)
            {
                //Still Moving case
                if (touchOnButton.phase != UITouchPhaseEnded) 
                {
                    //Move other buttons
                    if (i != currLocation)
                    {
                        NSValue * temp = [drawingView.buttonRects objectAtIndex:i];
                        int buttonNumber = [(NSNumber*)[configArray objectAtIndex:i] intValue];
                        photoButton * buttonForPosition = [positionDict objectForKey:[NSString stringWithFormat:@"%d",buttonNumber]];
                        buttonForPosition.frame = temp.CGRectValue;
                    }
                }
                else 
                {
                    //Finger lifted case
                    NSValue * temp = [drawingView.buttonRects objectAtIndex:i];
                    int buttonNumber = [(NSNumber*)[configArray objectAtIndex:i] intValue];
                    
                    photoButton * buttonForPosition = [positionDict objectForKey:[NSString stringWithFormat:@"%d",buttonNumber]];
                    buttonForPosition.frame = temp.CGRectValue;
                    [tempDict setObject:buttonForPosition forKey:[NSString stringWithFormat:@"%d",i]];
                    //buttonForPosition.position = [NSNumber numberWithInt:i];
                }
            }
            
        }
        else if (touchOnButton.phase == UITouchPhaseEnded)//Needs revisiting
        {
            for (int i = 0; i < totalNoOfPhotos; i++)
            {
                NSValue * temp = [drawingView.buttonRects objectAtIndex:i];
                photoButton * buttonForPosition = [positionDict objectForKey:[NSString stringWithFormat:@"%d",i]];
                buttonForPosition.frame = temp.CGRectValue;

            }
        }
        
        positionDict = [NSMutableDictionary dictionaryWithDictionary:tempDict];
    }
    
}

- (NSArray *) configurationForOriginalLocation: (int) origLoc toNewLocation: (int) newLoc
{
    NSMutableArray * configArray = [NSMutableArray arrayWithObjects:
                                    [NSNumber numberWithInt:0],
                                    [NSNumber numberWithInt:1],
                                    [NSNumber numberWithInt:2],
                                    [NSNumber numberWithInt:3],
                                    [NSNumber numberWithInt:4],
                                    [NSNumber numberWithInt:5],
                                    [NSNumber numberWithInt:6],
                                    [NSNumber numberWithInt:7],
                                    nil];
    
    
    if (origLoc != newLoc)
    {
        NSNumber * myObj = (NSNumber*) [configArray objectAtIndex:origLoc];
        [configArray removeObjectAtIndex:origLoc];
        
        [configArray insertObject:myObj atIndex:newLoc];
    }
    
    return configArray;
}

#define OFFSET 5.0
- (int) currButtonLocation: (CGPoint) currPoint
{
    for (int i = 0; i < MAX_PHOTOS ; i++)
    {
        NSValue * temp = [drawingView.buttonRects objectAtIndex:i];
        CGRect tempCGRect = temp.CGRectValue;
        if (CGRectContainsPoint(CGRectMake(tempCGRect.origin.x - OFFSET, tempCGRect.origin.y - OFFSET, tempCGRect.size.width + (2 * OFFSET), tempCGRect.size.height + (2 * OFFSET)), currPoint)) 
        {
            return i;
        } 
    }
    return 0;
}

#define SHRINK_X 320.0
#define SHRINK_Y 480.0

//Will shrink to 320x480 or 480x320 depending on size
- (UIImage *) shrinkImage: (UIImage*) origImage
{
    CGSize origsize = [origImage size];
    CGSize mysize;
    
    if(origsize.width > origsize.height) mysize = CGSizeMake(SHRINK_Y,SHRINK_X);
    else mysize = CGSizeMake(SHRINK_X,SHRINK_Y);
    
    UIGraphicsBeginImageContext(mysize);
    [origImage drawInRect:CGRectMake(0, 0, mysize.width, mysize.height)];
    UIImage* newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
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

#pragma mark - AnimateView Method
#define DURATION 0.4
#define HANDX 100
#define HANDY 200
- (void) animateView: (UIView*) smallView
{
    UIImage * handImage = [UIImage imageNamed:@"hand"];
    UIButton *imgview = ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) ? [[UIButton alloc] initWithFrame:CGRectMake(smallView.center.x-10,smallView.center.y, HANDX/2, HANDY/2)] : [[UIButton alloc] initWithFrame:CGRectMake(smallView.center.x-20,smallView.center.y, HANDX, HANDY)];
    
    
    [imgview setImage:handImage forState:UIControlStateNormal];
    [imgview setImage:handImage forState:UIControlStateHighlighted];
    [self.view addSubview:imgview];
    
    UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;
    [UIView animateWithDuration:DURATION delay:0 options:options animations:^{
        smallView.frame = CGRectMake(smallView.frame.origin.x+40, smallView.frame.origin.y, smallView.frame.size.width, smallView.frame.size.height);
        imgview.frame = CGRectMake(imgview.frame.origin.x+40, imgview.frame.origin.y, imgview.frame.size.width, imgview.frame.size.height);
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:DURATION delay:0 options:options animations:^{
            smallView.frame = CGRectMake(smallView.frame.origin.x-40, smallView.frame.origin.y, smallView.frame.size.width, smallView.frame.size.height);
            imgview.frame = CGRectMake(imgview.frame.origin.x-40, imgview.frame.origin.y, imgview.frame.size.width, imgview.frame.size.height);
            
        } completion:^(BOOL finished){
            [imgview removeFromSuperview];
        }];
        
    }];
}

@end
