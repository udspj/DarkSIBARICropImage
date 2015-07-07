//
//  rotateSlider.h
//  SPL
//
//  Created by sunpeijia on 15-2-10.
//
//

#import <UIKit/UIKit.h>

@protocol RotateSliderDelegate <NSObject>

-(void)RotateSliderValueChanged:(float)value;
-(void)sliderBegin:(UISlider *)slider;
-(void)sliderStop:(UISlider *)slider;

@end

@interface RotateSlider : UIView
{
    UISlider *Slider;
    UISlider *upSlider;
    UIImageView *imageViewBg;
    UIImageView *imageViewSLd;
    __weak id<RotateSliderDelegate> delegate;
    CGFloat slider_width;
    CGFloat slider_height;
}

@property(nonatomic,weak)__weak id<RotateSliderDelegate> delegate;

-(void)resetSliderValue:(CGFloat)value;

@end
