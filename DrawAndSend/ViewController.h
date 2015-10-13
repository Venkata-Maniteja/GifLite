//
//  ViewController.h
//  DrawAndSend
//
//  Created by Venkata Maniteja on 2015-10-08.
//  Copyright © 2015 Venkata Maniteja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myDrawView.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <FCColorPickerViewController.h>
#import <MessageUI/MessageUI.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <FBSDKShareKit/FBSDKShareKit.h>


@interface ViewController : UIViewController

@property (nonatomic,strong) IBOutlet myDrawView *drawView;
@property (nonatomic,strong) IBOutlet UIView *buttonHolder;
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;
@property (nonatomic, strong) IBOutlet FBSDKLoginButton *loginButton;
@property (nonatomic,strong) IBOutlet UILabel *timerLabel;

@property (strong,nonatomic) UIButton *button;

@property (nonatomic,assign) BOOL viewDidAppear;



@end

