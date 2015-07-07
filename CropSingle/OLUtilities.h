//
//  Utilities.h
//  Cube
//
//  Created by kimura on 10/05/21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum {
    ImageEditTypeMono,
    ImageEditTypeSepia,
    ImageEditTypeGamma,
    ImageEditTypeContrast	
};
typedef NSUInteger ImageEditType;

@interface OLUtilities : NSObject

+(UIImage*)resizeImage:(UIImage*)inImage maxResolution:(int)inResolution;

@end

@interface UIButton (UIButtonExtention)
- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;
@end