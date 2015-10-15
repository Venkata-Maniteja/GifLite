	//
//  myDrawView.m
//  DrawAndSend
//
//  Created by Venkata Maniteja on 2015-10-08.
//  Copyright © 2015 Venkata Maniteja. All rights reserved.
//

#import "myDrawView.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>


@implementation myDrawView

{
    UIImage *incrementalImage;
    CGPoint pts[5]; // we now need to keep track of the four points of a Bezier segment and the first control point of the next segment
    uint ctr;
}


@synthesize img,path,lineColor;

- (id)initWithCoder:(NSCoder *)aDecoder // (1)
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:NO];
        [self setUserInteractionEnabled:YES];
        
        img=[[NSMutableArray alloc]init];
        [self setBackgroundColor:[UIColor whiteColor]];
        path = [UIBezierPath bezierPath];
        [path setLineWidth:self.lineWidth];
        
        self.contentScaleFactor=1.0;
    }
    return self;
}


- (void)drawRect:(CGRect)rect // (5)
{
        [incrementalImage drawInRect:rect];
        [lineColor setStroke];
        [path stroke];
  
}

-(void)shadow{
    
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(-15, 20);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
}

- (void)erase {
    
    incrementalImage=nil;
    path   = nil;  //Set current path nil
    path   = [UIBezierPath bezierPath]; //Create new path
    [path setLineWidth:self.lineWidth];
    
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self recordScreen];
    
    [self performSelector:@selector(stop) withObject:nil afterDelay:15.0];
    
        ctr = 0;
        UITouch *touch = [touches anyObject];
        pts[0] = [touch locationInView:self];
        
   
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
       UITouch *touch = [touches anyObject];
       CGPoint p = [touch locationInView:self];
       ctr++;
       pts[ctr] = p;
       if (ctr == 4)
       {
           pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0); // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
           
           [path moveToPoint:pts[0]];
           [path addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]]; // add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
           
           [self setNeedsDisplay];
           // replace points and get ready to handle the next segment
           pts[0] = pts[3];
           pts[1] = pts[4];
           ctr = 1;
       }

    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
    [self stop];
    [self save];
    
    [self drawBitmap];
    [self setNeedsDisplay];
    
    //this line removes the drawing
       ctr = 0;
    
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}


-(void)borderAnimations{
    
    //need to provide a way to animate the border fade in and fadeout, the border must be like sprayed border
    
    CABasicAnimation *color = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    // animate from red to blue border ...
    color.fromValue = (id)[UIColor redColor].CGColor;
    color.toValue   = (id)[UIColor blueColor].CGColor;
    // ... and change the model value
  //  self.layer.backgroundColor = [UIColor blueColor].CGColor;
    
    CABasicAnimation *width = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    // animate from 2pt to 4pt wide border ...
    width.fromValue = @2;
    width.toValue   = @8;
    // ... and change the model value
    self.layer.borderWidth = 4;
    
    CAAnimationGroup *both = [CAAnimationGroup animation];
    // animate both as a group with the duration of 0.5 seconds
    both.duration   = 9.5;
    both.animations = @[color, width];
    // optionally add other configuration (that applies to both animations)
    both.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.layer addAnimation:both forKey:@"color and width"];
}

-(void)save{
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //        [self makeAnimatedGif:viewImage];
        [self makeAnimatedGif];
        
    });
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


-(void)stop{
    
    NSLog(@"timer invalidate, and objects count is %lu",(unsigned long)img.count);
    
    
    
    [self.timer invalidate];
    
    
}

-(void)recordScreen{
    
        self.timer= [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(takeSnapShot) userInfo:nil repeats:YES];
    
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
    
    //enable the share button
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"saved"];
    
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
    
    [img addObject:[self normalResImageForAsset:viewImage]] ;//]viewImage];
    
}



- (UIImage *)normalResImageForAsset:(UIImage *)imageToReSize
{
    // Convert ALAsset to UIImage
    UIImage *image = imageToReSize;
    
    // Determine output size
    CGFloat maxSize = 512.0f;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat newWidth = width;
    CGFloat newHeight = height;
    
    // If any side exceeds the maximun size, reduce the greater side to 1200px and proportionately the other one
    // .   if (width > maxSize || height > maxSize) {
    if (width > height) {
        newWidth = maxSize;
        newHeight = (height*maxSize)/width;
    } else {
        newHeight = maxSize;
        newWidth = (width*maxSize)/height;
    }
    //    }
    
    // Resize the image
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Set maximun compression in order to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.0f);
    UIImage *processedImage = [UIImage imageWithData:imageData];
    
    NSLog(@"after image details %lu",(unsigned long)[imageData length]);
    
    return processedImage;
}


- (void)drawBitmap
{
       UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
       
       if (!incrementalImage) // first time; paint background white
       {
           UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
           [[UIColor whiteColor] setFill];
           [rectpath fill];
       }
       [incrementalImage drawAtPoint:CGPointZero];
       [lineColor setStroke];
       [path stroke];
       incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
       UIGraphicsEndImageContext();
}



@end
