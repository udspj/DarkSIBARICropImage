//
//  SIBARICropView.h
//  PhotoCropEditor
//
//  Created by sunpeijia
//  
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "PECropRectView.h"

@interface SIBARICropImageView : UIView<UIScrollViewDelegate,PECropRectViewDelegate>
{
    CGFloat originalRectRatio;
    CGRect originalRect;
    CGFloat sliderValue; // slider的旋转角度
    CGFloat transRotate; // 导航条按钮的旋转角度
    BOOL isImageEdited; // 如果图片手动缩放过，就不再对小尺寸的裁切框进行贴边缩小了
    CGFloat scaleValue; // 横竖屏、切换裁切尺寸时设置的新zoom值
    CGFloat minScaleValue; // 每个旋转角度下最小缩放比例
    CGPoint perScrollviewContentoffset; // 照片不移出边界 判断
    CGFloat perScrollviewZoomScale; // 照片不移出边界 缩放 判断
    CGRect perCropRectBeforeEdit; // 操作cropview前的尺寸 判断
    CGRect perCropRect; // 拖动裁切框也不能出边界 判断
    BOOL isDefaultProtrait; // 是否竖屏进入，或original重置时是否竖屏
}

@property (nonatomic,strong) UIView *topOverlayView;
@property (nonatomic,strong) UIView *leftOverlayView;
@property (nonatomic,strong) UIView *rightOverlayView;
@property (nonatomic,strong) UIView *bottomOverlayView;

@property (nonatomic,strong) UIImage *imageNormal;//真实图片
@property (nonatomic) CGRect insetRect;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *zoomView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) PECropRectView *cropRectView;
//@property (nonatomic,strong) UIImage *croppedImage;

@property(assign)BOOL isVertical; // 图像是否是竖直状态
@property(assign)BOOL isClickBottom;

@property (nonatomic) CGRect selfProtraitFrame; // 竖屏下cropview的尺寸
@property (nonatomic) CGRect selfLandscapeFrame; // 横屏下cropview的尺寸

- (void)layoutPECropViewSubviews;
- (void)setInitCropImage:(UIImage *)image;
-(void)changeCropRectViewRatio:(CGFloat)ratio isFromBtn:(BOOL)isfrombtn;
-(void)slideRotateImageScrollView:(CGFloat)slidervalue;
-(void)directionRotateImageScrollView:(CGFloat)transRoat;
- (UIImage *)getCroppedUIImage;


@end
