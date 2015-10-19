//
//  AppDelegate.m
//  DrawAndSend
//
//  Created by Venkata Maniteja on 2015-10-08.
//  Copyright © 2015 Venkata Maniteja. All rights reserved.
//

#import "AppDelegate.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <FBSDKShareKit/FBSDKShareKit.h>

#import "myDrawView.h"
#import "ViewController.h"


@interface AppDelegate ()

@property (nonatomic,strong) UIView *tempView;

@end

@implementation AppDelegate

@synthesize tempView;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    
    [FBSDKLikeControl class];
    [FBSDKLoginButton class];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    UIInterfaceOrientation orintation = [[UIApplication sharedApplication]    statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(orintation))
    {
        tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        tempView.backgroundColor = [UIColor yellowColor];
    }
    else
    {
        tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
        tempView.backgroundColor = [UIColor redColor];
    }
    
    [UIApplication.sharedApplication.keyWindow.subviews.lastObject      addSubview:tempView];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [tempView removeFromSuperview];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    BOOL messenger=[[NSUserDefaults standardUserDefaults]boolForKey:@"messenger"];
    
    if (messenger) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        ViewController* mainController = (ViewController *)  self.window.rootViewController;
            
            [mainController.drawView erase];
            
        });
        
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
