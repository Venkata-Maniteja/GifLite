//
//  myDrawView.h
//  DrawAndSend
//
//  Created by Venkata Maniteja on 2015-10-08.
//  Copyright © 2015 Venkata Maniteja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myDrawView : UIView


@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,assign) NSUInteger lineWidth;
-(void)erase;

@end
