//
//  SettingsViewController.h
//  DrawAndSend
//
//  Created by Venkata Maniteja on 2015-10-15.
//  Copyright © 2015 Venkata Maniteja. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SliderProtocolDelegate <NSObject>
@required

-(void)sliderValue:(NSUInteger) value;
-(void)themeSelected:(NSUInteger) value;

@end

@interface SettingsViewController : UIViewController

{
    // Delegate to respond back
    
}

@property (assign) IBOutlet id<SliderProtocolDelegate> delegate;



@end
