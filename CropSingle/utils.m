//
//  utils.m
//  CropSingle
//
//  Created by sunpeijia on 15/7/7.
//  Copyright (c) 2015年 sunpeijia. All rights reserved.
//

#import "utils.h"

@implementation utils

+(UILabel*)titleLabelWithTitle:(NSString*)inTitle
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                12,
                                                                DEVICE_PHONE ? 480 : 1024,
                                                                44)];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = inTitle;
    return label;
}

@end
