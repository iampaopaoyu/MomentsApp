//
//  TextEffectsViewController.m
//  GratitudeJournal
//
//  Created by ajchang on 3/14/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import "TextEffectsViewController.h"
#import "MomentsTableViewController.h"

@interface TextEffectsViewController ()

@property NSArray *fonts;
@property NSArray *colors;

@end

@implementation TextEffectsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //auto-resize UILabel
    [self.momentTextLabel sizeToFit];
    
    //[self.imageView setImage:self.moment.image];
    [self.imageView setImage:[UIImage imageNamed:@"sample"]];
    self.imageView.backgroundColor = [UIColor whiteColor];
    [self addGestureRecognizersToPiece:self.momentTextLabel];
    
    self.fonts = [NSArray arrayWithObjects:@"American Typewriter", @"Futura", @"Gill Sans", @"Marker Felt", @"SnellRoundhand", nil];
    
    //TODO: if time, more color options
    UIColor *pinkColor = [UIColor colorWithRed:1 green:0.6 blue:0.6 alpha:1];
    UIColor *orangeColor = [UIColor colorWithRed:1 green:0.722 blue:0.439 alpha:1];
    UIColor *yellowColor = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:1];
    UIColor *greenColor = [UIColor colorWithRed:0.8 green:1 blue:0.698 alpha:1];
    UIColor *blueColor = [UIColor colorWithRed:0.58 green:0.722 blue:1 alpha:1];
    UIColor *purpleColor = [UIColor colorWithRed:0.8 green:0.6 blue:1 alpha:1];
    self.colors = [NSArray arrayWithObjects:[UIColor whiteColor], [UIColor blackColor], pinkColor, orangeColor, yellowColor, greenColor, blueColor, purpleColor, nil];

    
    self.fontsScrollView.contentSize = CGSizeMake(250, 50);
    self.colorsScrollView.contentSize = CGSizeMake(500, 50);
    
    //Create font buttons
    for (int i = 0; i < [self.fonts count]; i++) {
        UIButton *fontButton = [[UIButton alloc] initWithFrame:CGRectMake(i*50 + i*4, 0, 50, 50)];
        fontButton.tag = i + 100;
        [fontButton setTitle:@"Aa" forState:UIControlStateNormal];
        fontButton.layer.cornerRadius = 10;
        fontButton.clipsToBounds = YES;
        fontButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        fontButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [[fontButton layer] setBorderWidth:1.0f];
        [[fontButton layer] setBorderColor:[UIColor whiteColor].CGColor];
        [fontButton.titleLabel setFont:[UIFont fontWithName:[self.fonts objectAtIndex:i] size:25.0]];
        [fontButton addTarget:self action:@selector(chooseFont:) forControlEvents:UIControlEventTouchUpInside];
        [self.fontsScrollView addSubview:fontButton];
        NSLog(@"Created and added %@ font button", [self.fonts objectAtIndex:i]);
    }
    
    //Create color buttons
    for (int i = 0; i < [self.colors count]; i++) {
        UIButton *colorButton = [[UIButton alloc] initWithFrame:CGRectMake(i*50 + i*4, 0, 50, 50)];
        colorButton.tag = i + 200;
        colorButton.layer.cornerRadius = 10;
        colorButton.clipsToBounds = YES;
        colorButton.backgroundColor = [self.colors objectAtIndex:i];
        [colorButton addTarget:self action:@selector(chooseColor:) forControlEvents:UIControlEventTouchUpInside];
        [self.colorsScrollView addSubview:colorButton];
        NSLog(@"Created and added color button");
    }
    
}

- (IBAction)chooseFont:(UIButton *)sender {
    int chosenFontIndex = (int)sender.tag-100;
    NSLog(@"Chose font #%d", chosenFontIndex);
    [self.momentTextLabel setFont:[UIFont fontWithName:[self.fonts objectAtIndex:chosenFontIndex] size:25.0]];
    //after changing font, auto-resize UILabel
    [self.momentTextLabel sizeToFit];
}

- (IBAction)chooseColor:(UIButton *)sender {
    int chosenColorIndex = (int)sender.tag-200;
    NSLog(@"Chose color #%d", chosenColorIndex);
    self.momentTextLabel.textColor = [self.colors objectAtIndex:chosenColorIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"submitMoment"])
    {
        NSLog(@"Performing submitMoment segue");
        
        //replace image in Moment object
        //self.moment.image = self.imageView.image; //TODO: burn label to image first
        
        //pass updated Moment object with text overlay to MomentsTableViewController
        MomentsTableViewController *mvc = (MomentsTableViewController*) [segue destinationViewController];
        mvc.moment = self.moment;
        
        NSLog(@"IMAGE PRE SEGUE: %@, height: %f", self.moment.image, self.moment.image.size.height);
        NSLog(@"IMAGE PRE SEGUE: %@, height: %f", mvc.moment.image, mvc.moment.image.size.height);
    }
}

#pragma mark - Gesture Recognizers

- (void)addGestureRecognizersToPiece:(UIView *)piece
{
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc]
                                                    initWithTarget:self action:@selector(rotatePiece:)];
    [piece addGestureRecognizer:rotationGesture];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(scalePiece:)];
    //[pinchGesture setDelegate:self];
    [piece addGestureRecognizer:pinchGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:2];
    //[panGesture setDelegate:self];
    [piece addGestureRecognizer:panGesture];
}

// shift the piece's center by the pan amount
// reset the gesture recognizer's translation to {0, 0} after applying so the next
// callback is a delta from the current position
- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *piece = [gestureRecognizer view];
    [[piece superview] bringSubviewToFront:piece];
    
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
        [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        [piece setCenter:CGPointMake([piece center].x + translation.x,
                                     [piece center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    } 
}

// rotate the piece by the current rotation
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current rotation
- (void)rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer
{
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
        [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform =
        CGAffineTransformRotate([[gestureRecognizer view] transform],
                                [gestureRecognizer rotation]);
        [gestureRecognizer setRotation:0]; 
    } 
}

// scale the piece by the current scale
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current scale
- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer
{
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
        [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform =
        CGAffineTransformScale([[gestureRecognizer view] transform],
                               [gestureRecognizer scale], [gestureRecognizer scale]);
        [gestureRecognizer setScale:1]; 
    } 
}

// scale and rotation transforms are applied relative to the layer's anchor point
// this method moves a gesture recognizer's view's anchor point between the user's fingers
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer
                                       locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x /
                                              piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        
        piece.center = locationInSuperview; 
    } 
}

@end