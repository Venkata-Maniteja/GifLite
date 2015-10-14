//
//  ViewController.m
//  DrawAndSend
//
//  Created by Venkata Maniteja on 2015-10-08.
//  Copyright © 2015 Venkata Maniteja. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<FCColorPickerViewControllerDelegate,MFMailComposeViewControllerDelegate,UIDocumentInteractionControllerDelegate,FBSDKSharingDelegate>

@end

@implementation ViewController

@synthesize button,viewDidAppear,timerLabel;
- (void)viewDidLoad {
    
    NSLog(@"test");
    [super viewDidLoad];
    
    viewDidAppear=NO;
    
    [self performSelector:@selector(runOnlyOneTime) withObject:nil afterDelay:2.0];
    
    
    //trying to add timer to enable the share button
 
    [self setNeedsStatusBarAppearanceUpdate];
   
    self.loginButton.publishPermissions = @[@"publish_actions"];
    
    CGFloat buttonWidth = 40;
    button = [FBSDKMessengerShareButton circularButtonWithStyle:FBSDKMessengerShareButtonStyleWhite
                                                                    width:buttonWidth];
    [button addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    [button setFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
    
    [self.view addSubview:button];
    
    button.enabled=NO;
                              
    
    [self applyConstraintsForShareButton];
    
    
   
    
}

-(void)applyConstraintsForShareButton{
    
    NSDictionary * buttonDic = NSDictionaryOfVariableBindings(button);
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    NSArray * hConstraints ;
    
    if (screenRect.size.width == 568)
    {
        // this is an iPhone 5
        
        hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-160-[button(40)]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:buttonDic];
    }
    
    if (screenRect.size.width == 667)
    {
        // this is an iPhone 6
        
        hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-220-[button(40)]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:buttonDic];
    }
    
    if (screenRect.size.width == 736)
    {
        // this is an iPhone 6 +
        
        hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-260-[button(40)]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:buttonDic];
    }
    if (screenRect.size.width == 480)
    {
        // this is an iPhone 4
        
        hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[button(40)]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:buttonDic];
    }
    
    [self.view addConstraints:hConstraints];
    
    NSArray * vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[button(40)]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:buttonDic];
    
    
    
    [self.view addConstraints:vConstraints];
    
    
}

-(BOOL)prefersStatusBarHidden{
    return NO;
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
        button.enabled=YES;
        [button setAlpha:1.0];
        
        
        
    }else{
        
        button.enabled=NO;
        [button setAlpha:0.3];
        
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
    
       
    [self performSelector:@selector(expireAlert) withObject:nil afterDelay:10.0];
   
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
    self.drawView.lineColor = color;
    [self.drawView erase];
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
