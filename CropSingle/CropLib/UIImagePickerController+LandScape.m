//
//  UIImagePickerController+LandScape.m
//  SPL
//
//  Created by sunpeijia on 15-2-9.
//
//

#import "UIImagePickerController+LandScape.h"

@implementation UIImagePickerController (LandScape)

- (NSUInteger)supportedInterfaceOrientations
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    switch (deviceOrientation)
    {
        case UIInterfaceOrientationPortrait:
            return UIInterfaceOrientationMaskPortrait;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            return UIInterfaceOrientationMaskPortrait;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            return UIInterfaceOrientationMaskLandscape;
            break;
        case UIInterfaceOrientationLandscapeRight:
            return UIInterfaceOrientationMaskLandscape;
            break;
        default:
            break;
    }
    return UIInterfaceOrientationMaskPortrait;
}

@end
