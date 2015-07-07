//
//  ViewController.h
//  CropSingle
//
//  Created by sunpeijia on 15-3-27.
//  Copyright (c) 2015年 sunpeijia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CuttingPhotViewController.h"

@interface ViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,CuttingPhotoDelegate>

@property (nonatomic, retain) UIImagePickerController *picker;

@end

