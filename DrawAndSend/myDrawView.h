//
//  myDrawView.h
//  DrawAndSend
//
//  Created by Venkata Maniteja on 2015-10-08.
//  Copyright © 2015 Venkata Maniteja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myDrawView : UIView


@property (nonatomic,strong) UIBezierPath *path;
@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,strong) UIColor *backGroundCol;
@property (nonatomic,assign) NSUInteger lineWidth;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSMutableArray *img;
@property (nonatomic,strong) UIImage *incrementalImage;

@property (assign) BOOL themeSet;
@property (assign) BOOL multiColorPath;

-(void)erase;
-(void)stop;
-(void)recordScreen;

@end
