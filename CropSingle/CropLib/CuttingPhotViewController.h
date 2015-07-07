//
//  CuttingPhotViewController.h
//  SPL
//
//  Created by sunpeijia on 14/12/14.
//
//

#import <UIKit/UIKit.h>

#import "SIBARICropImageView.h"
#import "RotateSlider.h"
#import "CutScrollerView.h"

@protocol CuttingPhotoDelegate <NSObject>

-(void)CuttingPhotoDidFinish:(NSDictionary *)info;
-(void)dismissBtn:(UIButton *)btn;

@end

@interface CuttingPhotViewController : UIViewController<RotateSliderDelegate,CutScrollerViewDelegate>
{
    __weak id<CuttingPhotoDelegate>_delegate;
    
    CutScrollerView *cutScrollerView;//略缩图scroller
    RotateSlider *Slider;
    CGFloat sliderValue;
    UIImage *_cropImage; // 给小图button用的
    UIView  *backgroundView;
    UIImage *getImage; // 从相册获取的原始图片
    
    CGFloat transRoat;//总共裁剪角度
    NSInteger Orient;//旋转角度来判断图片方向
    NSInteger memoryTag; // 当前选中哪个裁切比例的按钮
}

@property(nonatomic,retain)UIImage *cropImage;//裁剪图片
@property (nonatomic,assign) SIBARICropImageView *cropView;//裁剪框
@property(nonatomic,weak)__weak id<CuttingPhotoDelegate>delegate;
@property(nonatomic,copy)NSDictionary   *cropInfo;//图片信息

@property(nonatomic,retain)UIImage *trueImage;//真实图片尺寸


@end
