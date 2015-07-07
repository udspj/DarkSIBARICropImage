//
//  utils.h
//  CropSingle
//
//  Created by sunpeijia on 15/7/7.
//  Copyright (c) 2015年 sunpeijia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DEVICE_PHONE			(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define DEVICE_PAD				(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define DEVICE_IPHONE5			([[UIScreen mainScreen] bounds].size.height == 568)
#define INTERFACE_LANDSCAPE		UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])
#define OS_OVER_5				([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0f)
#define OS_OVER_6				([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f)
#define OS_OVER_7				([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
#define OS_OVER_8               ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)
#define DEVICE_HAS_CAMERA		[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
#define DEVICE_LOWSPEC			([[[UIDevice currentDevice] machine] isEqualToString:@"iPad1,1"] ||\
[[[UIDevice currentDevice] machine] isEqualToString:@"iPad1,2"] ||\
[[[UIDevice currentDevice] machine] isEqualToString:@"iPod3,1"] ||\
[[[UIDevice currentDevice] machine] isEqualToString:@"iPhone2,1"])

#define kSign_Stamp_Select_Thumbnail_Filename       @"00-21_thumbnail_frame"
#define SIGN_STAMP_SCROLL_BTN_TAG       100

@interface utils : NSObject

+(UILabel*)titleLabelWithTitle:(NSString*)inTitle;

@end
