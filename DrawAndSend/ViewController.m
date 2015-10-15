//
//  ViewController.m
//  DrawAndSend
//
//  Created by Venkata Maniteja on 2015-10-08.
//  Copyright © 2015 Venkata Maniteja. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<FCColorPickerViewControllerDelegate,MFMailComposeViewControllerDelegate,UIDocumentInteractionControllerDelegate,FBSDKSharingDelegate>
@property (strong, nonatomic) UIButton *messengerButton;
@property (strong, nonatomic) IBOutlet UIView *shareButtonView;

@end

@implementation ViewController


@synthesize button,viewDidAppear,timerLabel;
- (void)viewDidLoad {
    
    NSLog(@"test");
    [super viewDidLoad];
//    [timerLabel setHidden:YES];
    viewDidAppear=NO;
    
    
    
    [self performSelector:@selector(runOnlyOneTime) withObject:nil afterDelay:2.0];
    
    
    //trying to add timer to enable the share button
 
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.loginButton.publishPermissions = @[@"publish_actions"];
    
    CGFloat buttonWidth = 40;
    
    
    _messengerButton = [FBSDKMessengerShareButton circularButtonWithStyle:FBSDKMessengerShareButtonStyleWhite
                                                                    width:buttonWidth];
    [_messengerButton addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.shareButtonView addSubview:_messengerButton];
    
    _messengerButton.enabled=NO;
}



-(BOOL)prefersStatusBarHidden{
    return YES;
}


-(void)shareButtonPressed{
    
    
    [self.drawView clearsContextBeforeDrawing];
    [self.drawView.img removeAllObjects];
    
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *csvFilePath = [documentsDirectory stringByAppendingFormat:@"/animated.gif"];
    NSData *myData = [NSData dataWithContentsOfFile:csvFilePath];
    
    
    [FBSDKMessengerSharer shareAnimatedGIF:myData withOptions:nil];
    
}

-(void)checkForShareEnableButton{
    
    BOOL saved=[[NSUserDefaults standardUserDefaults]boolForKey:@"saved"];
    
    if (saved) {
        
        //there is a file
        _messengerButton.enabled=YES;
        [_messengerButton setAlpha:1.0];
        
        
        
    }else{
        
        _messengerButton.enabled=NO;
        [_messengerButton setAlpha:0.3];
        
    }
    
}



-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (!viewDidAppear) {
        
        viewDidAppear=YES;

        timerLabel.center=self.drawView.center;
        
        timerLabel.text=@"3";
        
        timerLabel.alpha = 1;
        
        [self.drawView addSubview:timerLabel];
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             timerLabel.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             timerLabel.alpha = 1;
                             [UIView animateWithDuration:1.0 animations:^{
                                 timerLabel.alpha = 0;
                                 timerLabel.text = @"2";
                             } completion:^(BOOL finished) {
                                 
                                 timerLabel.alpha = 1;
                                 
                                 [UIView animateWithDuration:1.0 animations:^{
                                     timerLabel.alpha = 0;
                                     timerLabel.text = @"1";
                                 } completion:^(BOOL finished) {
                                     [timerLabel removeFromSuperview];
                                     
                                 }];
                                 
                             }];
                         }];
        
        
    }
    
       
//    [self performSelector:@selector(expireAlert) withObject:nil afterDelay:10.0];
   
    [self applyMaskForButtonHolder];
    
    NSLog(@"objects removed from array");
    
    
}

-(void)applyMaskForButtonHolder{
    
    self.buttonHolder.layer.cornerRadius=10.0;
    
}

-(void)runOnlyOneTime{
    
    //after i chose the color, this again called on viewdidappear,so im calling this in viewdidload after a delay,so it doesnt get called on viewdidappear
    
     self.timerShareButton=  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkForShareEnableButton) userInfo:nil repeats:YES];
    
    self.drawView.lineColor=[UIColor blackColor];
    self.drawView.lineWidth=6.0;
    [self.drawView setNeedsDisplay];
    
    [self.drawView erase];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
   
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
}

-(void)viewDidLayoutSubviews{
    
    NSLog(@"view did layout subviews");
}


-(void)expireAlert{
    
    [self.drawView stop];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Trail period ends"
                                  message:@"please purchase the app"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             [self performSelector:@selector(expireAlert) withObject:nil afterDelay:10.0];
                             
                         }];
    
    [alert addAction:ok];
    
//    [self presentViewController:alert animated:YES completion:nil];
    
    

}

-(void)alterImageViewWithBadges{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self.drawView stop];
    
    
}

-(IBAction)email:(id)sender{
    
    if ([MFMailComposeViewController canSendMail]) {
        
        NSString *recipient = @"tejanvm92@gmail.com";
        NSArray *recipients = [NSArray arrayWithObjects:recipient, nil];
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@"CSV Export"];
        [mailViewController setToRecipients:recipients];
        [mailViewController setMessageBody:@"" isHTML:NO];
        mailViewController.navigationBar.tintColor = [UIColor blackColor];
        
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *csvFilePath = [documentsDirectory stringByAppendingFormat:@"/animated.gif"];
        NSData *myData = [NSData dataWithContentsOfFile:csvFilePath];
        
        NSLog(@"my nsdata is %@",myData);
        
        [mailViewController addAttachmentData:myData
                                     mimeType:@"image/gif"
                                     fileName:@"animated.gif"];
        
        [self presentViewController:mailViewController animated:YES completion:nil];
    }
    

}


-(IBAction)clear:(id)sender{
    
    
    [self performSelector:@selector(expireAlert) withObject:nil afterDelay:10.0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.drawView erase];
        
        });
    
}

-(IBAction)color:(id)sender{
    
    FCColorPickerViewController *colorPicker = [FCColorPickerViewController colorPicker];
    colorPicker.color = self.drawView.lineColor;
    colorPicker.delegate = self;
    
    [colorPicker setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:colorPicker animated:YES completion:nil];
    
}

#pragma mark - FCColorPickerViewControllerDelegate Methods

-(void)colorPickerViewController:(FCColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color {
   
    
    self.drawView.path=nil;
    
    UIBezierPath *newPath=[UIBezierPath bezierPath];
    
    self.drawView.path=newPath;
    
     self.drawView.lineColor = color;
    
    [self.drawView.path setLineWidth:6.0];

    
    [self.drawView setNeedsDisplay];
    
    
    //[self.drawView erase]; do not erase after selecting color
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)colorPickerViewControllerDidCancel:(FCColorPickerViewController *)colorPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}





@end
