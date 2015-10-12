	//
//  myDrawView.m
//  DrawAndSend
//
//  Created by Venkata Maniteja on 2015-10-08.
//  Copyright © 2015 Venkata Maniteja. All rights reserved.
//

#import "myDrawView.h"

@implementation myDrawView

@synthesize img;

- (id)initWithCoder:(NSCoder *)aDecoder // (1)
{
    if (self = [super initWithCoder:aDecoder])
    {
        //[self setMultipleTouchEnabled:NO]; // (2)
        [self setUserInteractionEnabled:YES];
        
        img=[[NSMutableArray alloc]init];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.path = [UIBezierPath bezierPath];
        [self.path setLineWidth:self.lineWidth];
    }
    return self;
}

- (void)drawRect:(CGRect)rect // (5)
{
    [self.lineColor setStroke];
    [self.path stroke];
}

- (void)erase {
    self.path   = nil;  //Set current path nil
    self.path   = [UIBezierPath bezierPath]; //Create new path
    [self.path setLineWidth:self.lineWidth];
    
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [self.path moveToPoint:p];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self recordScreen];
    
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [self.path addLineToPoint:p]; // (4)
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

-(void)recordScreen{
    
        self.timer= [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(takeSnapShot) userInfo:nil repeats:YES];
    
}

-(void)takeSnapShot{
    
    //capture the screenshot of the uiimageview and save it in camera roll
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(viewImage, 0.0f);
    NSLog(@"before image details %lu",(unsigned long)[imageData length]);
    
    //[self normalResImageForAsset:viewImage];
    
    [img addObject:viewImage];
    
}

@end
