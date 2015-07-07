//
//  CropThumButton.h
//  SPL
//
//  Created by sunpeijia on 14/11/12.
//
//

#import <UIKit/UIKit.h>

@interface CropThumButton : UIButton
{
    UIImageView      *_cropImage;
    UILabel         *_cropLabel;
}


@property(nonatomic,retain)UIImageView  *cropImage;
@property(nonatomic,retain)UILabel  *cropLabel;

@end
