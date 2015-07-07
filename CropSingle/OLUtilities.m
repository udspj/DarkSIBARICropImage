//
//  Utilities.m
//  Cube
//
//  Created by kimura on 10/05/21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OLUtilities.h"
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>

#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAsset.h>

#import "CommonCrypto/CommonDigest.h"

@implementation OLUtilities

+(UIImage*)resizeImage:(UIImage*)inImage maxResolution:(int)inResolution
{
    return ResizeImage(inImage, inResolution);
}

UIImage* ResizeImage(UIImage *image , int maxResolution)
{
    
    CGImageRef imgRef = image.CGImage;
    
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imgRef);
    
    if(alphaInfo == kCGImageAlphaNone)
        alphaInfo = kCGImageAlphaNoneSkipLast;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    int newWidth = 0;
    int newHeight = 0;
    //	if (width > maxResolution || height > maxResolution)
    {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            newWidth = maxResolution;
            newHeight = newWidth / ratio;
        }
        else {
            newHeight = maxResolution;
            newWidth = newHeight * ratio;
        }
    }
    //	else
    //	{
    //		newWidth = width;
    //		newHeight = height;
    //	}
    
    CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef tempContext = CGBitmapContextCreate(NULL,
                                                     newWidth,
                                                     newHeight,
                                                     8,
                                                     (4 * newWidth),
                                                     genericColorSpace,
                                                     alphaInfo);
    CGColorSpaceRelease(genericColorSpace);
    
    CGContextSetInterpolationQuality(tempContext, kCGInterpolationDefault);
    
    CGContextDrawImage(tempContext, CGRectMake(0, 0, newWidth, newHeight), imgRef);
    
    CGImageRef tempImage = CGBitmapContextCreateImage(tempContext);
    CGContextRelease(tempContext);
    
    UIImage* resultImage = [UIImage imageWithCGImage:tempImage scale:1.0 orientation:image.imageOrientation];
    CGImageRelease(tempImage);
    
    return resultImage;
}

@end

@implementation UIButton (BGColor)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    CGFloat width = self.frame.size.width*[[UIScreen mainScreen] scale];
    CGFloat height = self.frame.size.height*[[UIScreen mainScreen] scale];
    CGRect buttonSize = CGRectMake(0, 0, width, height);
	
    UIView *bgView = [[UIView alloc] initWithFrame:buttonSize];
    bgView.layer.cornerRadius = 8 * [[UIScreen mainScreen] scale];
	bgView.layer.borderWidth = 2;
	bgView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    bgView.clipsToBounds = true;
    bgView.backgroundColor = color;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
	
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    [self setBackgroundImage:screenImage forState:state];
}

@end
