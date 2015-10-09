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

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) IBOutlet UIImageView *imgView;

@property (nonatomic,strong) NSMutableArray *img;

@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;

@property (nonatomic, strong) IBOutlet FBSDKLoginButton *loginButton;


@property (nonatomic,strong) IBOutlet UIButton *button;








@end

@implementation ViewController

@synthesize img,imgView;

- (void)viewDidLoad {
    
    NSLog(@"test");
    [super viewDidLoad];
    
    img=[[NSMutableArray alloc]init];
    
    [self setNeedsStatusBarAppearanceUpdate];
   
    self.loginButton.publishPermissions = @[@"publish_actions"];
    
    CGFloat buttonWidth = 50;
    UIButton *button = [FBSDKMessengerShareButton circularButtonWithStyle:FBSDKMessengerShareButtonStyleBlue
                                                                    width:buttonWidth];
    [button addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    [button setFrame:CGRectMake(0, 20, button.frame.size.width, button.frame.size.height)];
    [self.view addSubview:button];
   
    
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

-(void)removeFile{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"animated.gif"];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
//        UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
//        [removeSuccessFulAlert show];
        NSLog(@"succss in removing");
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.drawView.lineColor=[UIColor blackColor];
    self.drawView.lineWidth=6.0;
    [self.drawView setNeedsDisplay];
    
    [self.drawView erase];
    
    [img removeAllObjects];
    NSLog(@"objects removed from array");
    
    [self changeButtonTitle:@"Record"];

    
    imgView.hidden=YES;
    
    [self removeFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)stop{
    
    NSLog(@"timer invalidate");
    
    [self changeButtonTitle:@"Save"];
    
    [self.timer invalidate];

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
    
     [img removeAllObjects];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.drawView erase];
        
        [imgView stopAnimating];
    });
    
   
    
}


-(void)record{
    
    [self changeButtonTitle:@"Stop"];
    [self recordScreen];
   
}

-(void)changeButtonTitle:(NSString *)title{
    
    [self.button setTitle:title forState:UIControlStateNormal];
}

-(void)play{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        imgView.hidden=NO;
        
        imgView.animationImages = img;
        imgView.animationDuration = 2.0f;
        imgView.animationRepeatCount = 2;
        [imgView startAnimating];
        
        [self changeButtonTitle:@"Record"];
        
    });
    
    
}

-(void)takeSnapShot{
    
    //capture the screenshot of the uiimageview and save it in camera roll
    UIGraphicsBeginImageContext(self.drawView.frame.size);
    [self.drawView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [img addObject:viewImage];
    
}



-(void)save{
    
    
    [self removeFile];
    [self changeButtonTitle:@"Play"];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //        [self makeAnimatedGif:viewImage];
               [self makeAnimatedGif];
        
    });
}

-(IBAction)color:(id)sender{
    
    FCColorPickerViewController *colorPicker = [FCColorPickerViewController colorPicker];
    colorPicker.color = self.drawView.lineColor;
    colorPicker.delegate = self;
    
    [colorPicker setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:colorPicker animated:YES completion:nil];
    
}


-(IBAction)button:(id)sender{
    
    
    if ([[sender currentTitle] isEqualToString:@"Record"]) {
        
        [self record];
        
    }
    
    else if ([[sender currentTitle] isEqualToString:@"Stop"]) {
        
        [self stop];
        
    }
    
    else if ([[sender currentTitle] isEqualToString:@"Save"]) {
        
        [self save];
        
    }
    
    else if ([[sender currentTitle] isEqualToString:@"Play"]) {
        
        [self play];
        
    }
    
    
    
}



#pragma mark - FCColorPickerViewControllerDelegate Methods

-(void)colorPickerViewController:(FCColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color {
    self.drawView.lineColor = color;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)colorPickerViewControllerDidCancel:(FCColorPickerViewController *)colorPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)makeAnimatedGif {
     NSUInteger kFrameCount = img.count;
    
    NSDictionary *fileProperties = @{
                                     (__bridge id)kCGImagePropertyGIFDictionary: @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                             }
                                     };
    
    NSDictionary *frameProperties = @{
                                      (__bridge id)kCGImagePropertyGIFDictionary: @{
                                              (__bridge id)kCGImagePropertyGIFDelayTime: @0.08f, // a float (not double!) in seconds, rounded to centiseconds in the GIF data
                                              }
                                      };
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.gif"];
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
    
    for (NSUInteger i = 0; i < kFrameCount; i++) {
        @autoreleasepool {
            UIImage *image =[img objectAtIndex:i];
            CGImageDestinationAddImage(destination, image.CGImage, (__bridge CFDictionaryRef)frameProperties);
        }
    }
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    CFRelease(destination);
    
    NSLog(@"url=%@", fileURL);
}

-(void)recordScreen{
    
   self.timer= [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(takeSnapShot) userInfo:nil repeats:YES];

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
