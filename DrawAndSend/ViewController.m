//
//  ViewController.m
//  DrawAndSend
//
//  Created by Venkata Maniteja on 2015-10-08.
//  Copyright © 2015 Venkata Maniteja. All rights reserved.
//

#import "ViewController.h"
#import "myDrawView.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <FCColorPickerViewController.h>
#import <MessageUI/MessageUI.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <FBSDKShareKit/FBSDKShareKit.h>


@interface ViewController ()<FCColorPickerViewControllerDelegate,MFMailComposeViewControllerDelegate,UIDocumentInteractionControllerDelegate,FBSDKSharingDelegate>

@property (nonatomic,strong) IBOutlet myDrawView *drawView;
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;
@property (nonatomic, strong) IBOutlet FBSDKLoginButton *loginButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    NSLog(@"test");
    [super viewDidLoad];
    
    
    [self setNeedsStatusBarAppearanceUpdate];
   
    self.loginButton.publishPermissions = @[@"publish_actions"];
    
    CGFloat buttonWidth = 50;
    UIButton *button = [FBSDKMessengerShareButton circularButtonWithStyle:FBSDKMessengerShareButtonStyleBlue
                                                                    width:buttonWidth];
    [button addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    [button setFrame:CGRectMake(0, 20, button.frame.size.width, button.frame.size.height)];
    
   
    [self.view addSubview:button];
                              
                              
    NSDictionary * buttonDic = NSDictionaryOfVariableBindings(button);
                              button.translatesAutoresizingMaskIntoConstraints = NO;
                              
        NSArray * hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-80-[button(40)]|"
                                                                                               options:0
                                                                                               metrics:nil
                                                                                                 views:buttonDic];
     [self.view addConstraints:hConstraints];
                              
      NSArray * vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[button(40)]|"
                                                                                               options:0
                                                                                               metrics:nil
                                                                                                 views:buttonDic];
 [self.view addConstraints:vConstraints];
   
    
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

-(void)shareButtonPressed{
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *csvFilePath = [documentsDirectory stringByAppendingFormat:@"/animated.gif"];
    NSData *myData = [NSData dataWithContentsOfFile:csvFilePath];
    
    
    [FBSDKMessengerSharer shareAnimatedGIF:myData withOptions:nil];
    
}



-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.drawView.lineColor=[UIColor blackColor];
    self.drawView.lineWidth=6.0;
    [self.drawView setNeedsDisplay];
    
    [self.drawView erase];
    
    NSLog(@"objects removed from array");
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
