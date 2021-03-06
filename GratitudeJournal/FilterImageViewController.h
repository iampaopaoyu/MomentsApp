//
//  FilterImageViewController.h
//  GratitudeJournal
//
//  Created by Alice Chang on 3/13/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//

/* Allow user to apply filters to their photo. */

#import <UIKit/UIKit.h>
#import "Moment.h"

@interface FilterImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *filterScrollView;
@property UIImage *imageFullSize;
@property UIImage *imageThumbnail;
@property (strong, nonatomic) Moment *moment;

@end
