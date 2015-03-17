//
//  HomeViewController.h
//  GratitudeJournal
//
//  Created by ajchang on 3/4/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moment.h"

@interface HomeViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *dailyQuestion;
@property (strong, nonatomic) Moment *moment;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *infoViewButton;
@property (weak, nonatomic) IBOutlet UILabel *infoViewLabel;

- (IBAction)presentInfo:(UIButton *)sender;
- (IBAction)dismissInfo:(UIButton *)sender;
- (IBAction)loadImagePicker:(UIButton *)sender;

@end
