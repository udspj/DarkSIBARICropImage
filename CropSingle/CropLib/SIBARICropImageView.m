//
//  SIBARICropView.m
//  PhotoCropEditor
//
//  Created by sunpeijia
//
//

#import "SIBARICropImageView.h"
#import "utils.h"

//#define kangle 10.0 / 180.0 * M_PI // 30.0可修改为0-45度中任意值看效果
#define viewWidth self.frame.size.width
#define viewHeight self.frame.size.height

#define zoomviewMAX 1000000

static const CGFloat MarginTop = 15.0f;
static const CGFloat MarginBottom = MarginTop;
static const CGFloat MarginLeft = 15.0f;
static const CGFloat MarginRight = MarginLeft;

@implementation SIBARICropImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //self.backgroundColor = [UIColor redColor];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.delegate = self;
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        //self.scrollView.backgroundColor = [UIColor blueColor];
        self.scrollView.minimumZoomScale = 0.0f;//1.0f;
        self.scrollView.maximumZoomScale = 5.0f;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.alwaysBounceHorizontal=YES;
        self.scrollView.alwaysBounceVertical=YES;
        self.scrollView.bounces = NO;
        self.scrollView.bouncesZoom = NO;
        self.scrollView.clipsToBounds = NO;
        [self addSubview:self.scrollView];
        
        self.zoomView = [[UIView alloc] init];
        //self.zoomView.backgroundColor = [UIColor yellowColor];
        //self.zoomView.alpha = 0.7;
        [self.scrollView addSubview:self.zoomView];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.zoomView addSubview:self.imageView];
        //[self.scrollView addSubview:self.imageView];
        
        self.topOverlayView = [[UIView alloc] init];
        self.topOverlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
        [self addSubview:self.topOverlayView];
        
        self.leftOverlayView = [[UIView alloc] init];
        self.leftOverlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
        [self addSubview:self.leftOverlayView];
        
        self.rightOverlayView = [[UIView alloc] init];
        self.rightOverlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
        [self addSubview:self.rightOverlayView];
        
        self.bottomOverlayView = [[UIView alloc] init];
        self.bottomOverlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
        [self addSubview:self.bottomOverlayView];
        
        self.cropRectView = [[PECropRectView alloc] init];
        self.cropRectView.delegate = self;
        self.cropRectView.keepingAspectRatio = NO;
        [self addSubview:self.cropRectView];
        
        self.isVertical = NO;
        isImageEdited = NO;
        sliderValue = 0.0f;
        scaleValue = 0.0f;
        minScaleValue = 1.0f;
    }
    return self;
}

#pragma mark - layouts setting

//layoutSubviews在以下情况下会被调用：
//1、init初始化不会触发layoutSubviews
//2、addSubview会触发layoutSubviews
//3、设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化
//4、滚动一个UIScrollView会触发layoutSubviews
//5、旋转Screen会触发父UIView上的layoutSubviews事件
//6、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件
- (void)layoutPECropViewSubviews // - (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self changeCropRectViewRectSize:self.cropRectView.frame.size];
    [self slideRotateImageScrollView:sliderValue];
    [self updateImageAnchorPoint];
    
    CGRect imgrect = self.imageView.bounds;
    CGRect zoomimgrect = [self convertRect:self.cropRectView.frame toView:self.imageView];
    if (!CGRectContainsRect(imgrect, zoomimgrect) && isImageEdited)
    {
        [self checkAfterDragIsMoveImage];
    }
}

// 计算裁切框的新尺寸
-(CGRect)changeCropRectViewRectSize:(CGSize)cropsize
{
    if (INTERFACE_LANDSCAPE) {
        self.insetRect = CGRectInset(self.frame, MarginLeft, MarginTop);
    } else {
        self.insetRect = CGRectInset(self.frame, MarginLeft, MarginLeft);
    }
    CGRect cropRect = AVMakeRectWithAspectRatioInsideRect(cropsize, self.insetRect);
    //originalRect = AVMakeRectWithAspectRatioInsideRect(self.imageNormal.size, self.insetRect);
    if (self.scrollView.zoomScale >= self.scrollView.maximumZoomScale)
    {
        cropRect = AVMakeRectWithAspectRatioInsideRect(cropsize, CGRectInset(self.frame, self.frame.size.width/2 - self.cropRectView.frame.size.width/2, self.frame.size.height/2 - self.cropRectView.frame.size.height/2));
        
        CGRect cropRectFix = AVMakeRectWithAspectRatioInsideRect(cropRect.size, self.insetRect);
        if (cropRect.size.width > cropRectFix.size.width || cropRect.size.height > cropRectFix.size.height)
        {
            cropRect = cropRectFix;
        }
    }
    [self layoutCropRectViewWithCropRect:cropRect];
    
    return cropRect;
}
// 设置裁切框的尺寸
- (void)layoutCropRectViewWithCropRect:(CGRect)cropRect
{
    self.cropRectView.frame = cropRect;
    [self layoutOverlayViewsWithCropRect:cropRect];
}
// 设置裁切框周围半透明黑色遮罩的frame
- (void)layoutOverlayViewsWithCropRect:(CGRect)cropRect
{
    self.topOverlayView.frame = CGRectMake(0.0f,0.0f,CGRectGetWidth(self.bounds),CGRectGetMinY(cropRect));
    self.leftOverlayView.frame = CGRectMake(0.0f,CGRectGetMinY(cropRect),CGRectGetMinX(cropRect),CGRectGetHeight(cropRect));
    self.rightOverlayView.frame = CGRectMake(CGRectGetMaxX(cropRect),CGRectGetMinY(cropRect),CGRectGetWidth(self.bounds) - CGRectGetMaxX(cropRect),CGRectGetHeight(cropRect));
    self.bottomOverlayView.frame = CGRectMake(0.0f,CGRectGetMaxY(cropRect),CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds) - CGRectGetMaxY(cropRect));
}

// 旋转imageview
-(void)slideRotateImageScrollView:(CGFloat)slidervalue
{
    sliderValue = slidervalue;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.imageView.transform = CGAffineTransformMakeRotation((transRotate + slidervalue) * ( M_PI / 180.0f));
    
    CGFloat angel = fabs(slidervalue) * ( M_PI / 180.0f);
    CGFloat width = cos(angel)*self.cropRectView.frame.size.width+cos(M_PI/2-angel)*self.cropRectView.frame.size.height;
    CGFloat height = cos(angel)*self.cropRectView.frame.size.height+cos(M_PI/2-angel)*self.cropRectView.frame.size.width;
    
    CGRect referenceRect = originalRect;
    scaleValue = (width/referenceRect.size.width>height/referenceRect.size.height)?(width/referenceRect.size.width):(height/referenceRect.size.height);
    if (self.isVertical)
    {
        scaleValue = (height/referenceRect.size.width>width/referenceRect.size.height)?(height/referenceRect.size.width):(width/referenceRect.size.height);
    }
    minScaleValue = scaleValue;
    //self.scrollView.minimumZoomScale = scaleValue;
// 此处，如果scaleValue < 1，图像会出界，暂时不知道解决办法
    if ((self.scrollView.zoomScale < scaleValue || !isImageEdited) && scaleValue >= 1)
    {
        self.scrollView.zoomScale = scaleValue; //* self.scrollView.minimumZoomScale;
    }
    [self setZoomviewToScrollviewCenter];
    if (isImageEdited)
    {
        [self checkAfterRotatedIsScaleImage];
    }
    
    CGFloat insetdis = 1000;//self.scrollView.frame.size.height/2-1;
    self.scrollView.contentInset = UIEdgeInsetsMake(insetdis, insetdis, insetdis, insetdis);
    //[self fixAnchorPointAfterRotaion];
}
// 修正imageview偏移zoomview的中心
-(void)fixAnchorPointAfterRotaion
{
    //self.imageView.center = CGPointMake(self.zoomView.frame.size.width/2, self.zoomView.frame.size.height/2);
    CGPoint imgcenterpoint = [self convertPoint:CGPointMake(self.imageView.frame.origin.x+self.imageView.frame.size.width/2, self.imageView.frame.origin.y+self.imageView.frame.size.height/2) fromView:self.zoomView];
    CGPoint zoomcenterpoint = [self convertPoint:CGPointMake(self.zoomView.frame.origin.x+self.zoomView.frame.size.width/2, self.zoomView.frame.origin.y+self.zoomView.frame.size.height/2) fromView:self.scrollView];
    CGFloat fixcenterx = (zoomcenterpoint.x - imgcenterpoint.x)/scaleValue;
    CGFloat fixcentery = (zoomcenterpoint.y - imgcenterpoint.y)/scaleValue;
//    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x+fixcenterx, self.imageView.frame.origin.y+fixcentery, self.imageView.frame.size.width, self.imageView.frame.size.height);
    self.imageView.layer.position = CGPointMake(self.imageView.center.x+fixcenterx, self.imageView.center.y+fixcentery);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x-fixcenterx, self.scrollView.contentOffset.y-fixcentery);
    
    NSLog(@"self.imageView.center %f %f",fixcenterx,fixcentery);
}
// 旋转imageview后检查裁切框是否超出imageview的边界，超出的话贴边对scrollview进行放大
-(void)checkAfterRotatedIsScaleImage
{
    // 无论原始图片比例如何，originalRect都是宽>=高，所以新建一个normalRect来指示原图是横还是竖
    CGRect normalRect = originalRect;
    if (self.imageNormal.size.height / self.imageNormal.size.width > 1)
    {
        normalRect = CGRectMake(originalRect.origin.x, originalRect.origin.y, originalRect.size.height, originalRect.size.width);
    }
    CGRect imgrect = self.imageView.bounds;
    CGRect zoomimgrect = [self convertRect:self.cropRectView.frame toView:self.imageView];
    if (CGRectContainsRect(imgrect, zoomimgrect))
    {
        return;
    }
    
    CGPoint anchorP = [self convertPoint:self.center toView:self.imageView];
    CGFloat minwidth = MIN(anchorP.x, abs(normalRect.size.width - anchorP.x)) * 2 * self.scrollView.zoomScale;
    CGFloat minheight = MIN(anchorP.y, abs(normalRect.size.height - anchorP.y)) * 2 * self.scrollView.zoomScale;
    if (transRotate == 90 || transRotate == 270)//(self.isVertical)
    {
        minwidth = MIN(anchorP.y, abs(normalRect.size.height - anchorP.y)) * 2 * self.scrollView.zoomScale;
        minheight = MIN(anchorP.x, abs(normalRect.size.width - anchorP.x)) * 2 * self.scrollView.zoomScale;
    }
    
    CGFloat angel = fabs(sliderValue) * ( M_PI / 180.0f);
    CGFloat width= cos(angel)*self.cropRectView.frame.size.width+cos(M_PI/2-angel)*self.cropRectView.frame.size.height;
    CGFloat height= cos(angel)*self.cropRectView.frame.size.height+cos(M_PI/2-angel)*self.cropRectView.frame.size.width;
    
    CGFloat fixscale = 0.0f;
    if (minwidth < minheight)
    {
        fixscale = (normalRect.size.width * self.scrollView.zoomScale + abs(width - minwidth)) / (normalRect.size.width);
        if (transRotate == 90 || transRotate == 270)//(self.isVertical)
        {
            fixscale = (normalRect.size.height * self.scrollView.zoomScale + abs(width - minwidth)) / (normalRect.size.height);
        }
    }
    else
    {
        fixscale = (normalRect.size.height * self.scrollView.zoomScale + abs(height - minheight)) / (normalRect.size.height);
        if (transRotate == 90 || transRotate == 270)//(self.isVertical)
        {
            fixscale = (normalRect.size.width * self.scrollView.zoomScale + abs(height - minheight)) / (normalRect.size.width);
        }
    }
    self.scrollView.zoomScale = fixscale;
    scaleValue = fixscale;
    
    if (fixscale > self.scrollView.maximumZoomScale)
    {
        [self checkAfterDragIsMoveImage];
    }
}
-(void)checkAfterDragIsMoveImage
{
    // 无论原始图片比例如何，originalRect都是宽>=高，所以新建一个normalRect来指示原图是横还是竖
    CGRect normalRect = originalRect;
    if (self.imageNormal.size.height / self.imageNormal.size.width > 1)
    {
        normalRect = CGRectMake(originalRect.origin.x, originalRect.origin.y, originalRect.size.height, originalRect.size.width);
    }
    CGFloat longwidth = normalRect.size.width * self.scrollView.zoomScale;
    CGFloat longheight = normalRect.size.height * self.scrollView.zoomScale;
    if (transRotate == 90 || transRotate == 270)//(self.isVertical)
    {
        longwidth = normalRect.size.height * self.scrollView.zoomScale;
        longheight = normalRect.size.width * self.scrollView.zoomScale;
    }
    CGFloat angleA = 0.0f;
    if (sliderValue < 0)
    {
        angleA = sliderValue * ( M_PI / 180.0f);
    }
    else
    {
        angleA = (90 - sliderValue) * ( M_PI / 180.0f);
    }
    // 旋转后image的4个点坐标，A右上 B左上 C左下 D右下
//    CGPoint imgpointA = CGPointMake(longwidth * cos(angleA), 0);
//    CGPoint imgpointB = CGPointMake(0, longwidth * sin(angleA));
//    CGPoint imgpointC = CGPointMake(longheight * sin(angleA), longwidth * sin(angleA) + longheight * cos(angleA));
//    CGPoint imgpointD = CGPointMake(longheight * sin(angleA) + longwidth * cos(angleA), longheight * cos(angleA));
    // cropview的4个点坐标，A右上 B左上 C左下 D右下
    CGRect croprectinimage = self.cropRectView.frame;//[self convertRect:self.cropRectView.frame toView:self.imageView];
    CGPoint croppointA = [self convertPoint:CGPointMake(croprectinimage.origin.x + croprectinimage.size.width, croprectinimage.origin.y) toView:self.imageView];
    CGPoint croppointB = [self convertPoint:croprectinimage.origin toView:self.imageView];
    CGPoint croppointC = [self convertPoint:CGPointMake(croprectinimage.origin.x, croprectinimage.origin.y + croprectinimage.size.height) toView:self.imageView];
    CGPoint croppointD = [self convertPoint:CGPointMake(croprectinimage.origin.x + croprectinimage.size.width, croprectinimage.origin.y + croprectinimage.size.height) toView:self.imageView];
    BOOL iscontainCroppointA = CGRectContainsPoint(self.imageView.bounds, croppointA);
    BOOL iscontainCroppointB = CGRectContainsPoint(self.imageView.bounds, croppointB);
    BOOL iscontainCroppointC = CGRectContainsPoint(self.imageView.bounds, croppointC);
    BOOL iscontainCroppointD = CGRectContainsPoint(self.imageView.bounds, croppointD);
//    CGRect rrrrf = self.imageView.frame;
//    CGRect rrrrb = self.imageView.bounds; // 始终是 0,0,290,290
    
    // cropview外接的旋转后的矩形，到图像边界的距离
//    croprectinimage = [self convertRect:self.cropRectView.frame toView:self.imageView];
//    CGFloat topdis = croprectinimage.size.width * cos(angleA) * sin(angleA);
//    CGFloat leftdis = croprectinimage.size.height * cos(angleA) * sin(angleA);
    CGPoint anchorP = [self convertPoint:self.center toView:self.imageView];
    CGFloat minwidth = MIN(anchorP.x, abs(normalRect.size.width - anchorP.x)) * 2 * self.scrollView.zoomScale;
    CGFloat minheight = MIN(anchorP.y, abs(normalRect.size.height - anchorP.y)) * 2 * self.scrollView.zoomScale;
    if (transRotate == 90 || transRotate == 270)//(self.isVertical)
    {
        minwidth = MIN(anchorP.y, abs(normalRect.size.height - anchorP.y)) * 2 * self.scrollView.zoomScale;
        minheight = MIN(anchorP.x, abs(normalRect.size.width - anchorP.x)) * 2 * self.scrollView.zoomScale;
    }
    CGFloat angel = fabs(sliderValue) * ( M_PI / 180.0f);
    CGFloat width= cos(angel)*self.cropRectView.frame.size.width+cos(M_PI/2-angel)*self.cropRectView.frame.size.height;
    CGFloat height= cos(angel)*self.cropRectView.frame.size.height+cos(M_PI/2-angel)*self.cropRectView.frame.size.width;
    // 外接矩形－图像边界距离
    CGFloat leftdis = abs(width - minwidth)/2;
    CGFloat topdis = abs(height - minheight)/2;
    if (sliderValue < 0)
    {
        topdis = abs(width - minwidth)/2;
        leftdis = abs(height - minheight)/2;
    }
    NSLog(@"topdis/sin(angleA) %f %f",topdis*cos(angleA),topdis*sin(angleA));
    if (!iscontainCroppointA)
    {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x - abs(topdis*cos(angleA)), self.scrollView.contentOffset.y + abs(topdis*sin(angleA)));
    }
    if (!iscontainCroppointB)
    {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + abs(leftdis*sin(angleA)), self.scrollView.contentOffset.y + abs(leftdis*cos(angleA)));
    }
    if (!iscontainCroppointC)
    {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + abs(topdis*cos(angleA)), self.scrollView.contentOffset.y - abs(topdis*sin(angleA)));
    }
    if (!iscontainCroppointD)
    {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x - abs(leftdis*sin(angleA)), self.scrollView.contentOffset.y - abs(leftdis*cos(angleA)));
    }
    [self updateImageAnchorPoint];
    
//    CGRect imgrect = self.imageView.bounds;
//    CGRect zoomimgrect = [self convertRect:self.cropRectView.frame toView:self.imageView];
//    if (!CGRectContainsRect(imgrect, zoomimgrect))
//    {
//        [self checkAfterDragIsMoveImage];
//    }
}

// 还原所有控件到初始original状态
-(void)resetAllSubviewLayouts
{
    self.imageView.transform = CGAffineTransformMakeRotation(0 * ( M_PI / 180.0f));
    self.scrollView.zoomScale = 1;
    isImageEdited = NO;
    sliderValue = 0.0f;
    transRotate = 0.0f;
    scaleValue = 0.0f;
    minScaleValue = 1.0f;
    //self.scrollView.minimumZoomScale = 1.0f;
    self.isVertical = NO;
    if (self.imageNormal.size.width < self.imageNormal.size.height)
    {
        self.isVertical = YES;
    }
    [self initCropImageSubviews];
    [self updateImageAnchorPoint];
}

#pragma mark - 伪 getter setter

// 设置imageview的图像
- (void)setInitCropImage:(UIImage *)image
{
    self.imageNormal = image;
    self.imageView.image = self.imageNormal;
    [self initCropImageSubviews];
}
// 重置scrollview，zoomview，imageview
-(void)initCropImageSubviews
{
    CGRect cropRect = [self changeCropRectViewRectSize:self.imageNormal.size];
    originalRect = cropRect;
    originalRectRatio = cropRect.size.height / cropRect.size.width;
    if (originalRectRatio > 1)
    {
        originalRect = CGRectMake(cropRect.origin.x, cropRect.origin.y, cropRect.size.height, cropRect.size.width);
        originalRectRatio = 1 / originalRectRatio;
    }
    
    // 以下的squareRect是正方形的
    CGRect squareRect = AVMakeRectWithAspectRatioInsideRect(CGSizeMake(1000, 1000), self.insetRect);
    if (squareRect.size.width < cropRect.size.width || squareRect.size.height < cropRect.size.height)
    {
        CGFloat fixdis = MAX(cropRect.size.width - squareRect.size.width, cropRect.size.height - squareRect.size.height);
        squareRect = CGRectInset(squareRect, -fixdis/2, -fixdis/2);
    }
    self.scrollView.frame = squareRect;
    self.scrollView.contentSize = squareRect.size;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.zoomView.frame = CGRectMake(-zoomviewMAX,-zoomviewMAX, squareRect.size.width+2*zoomviewMAX, squareRect.size.height+2*zoomviewMAX);
    if (cropRect.size.width > cropRect.size.height)
    {
        self.imageView.frame = CGRectMake(zoomviewMAX, cropRect.size.width/2-cropRect.size.height/2+zoomviewMAX, cropRect.size.width, cropRect.size.height);
    }
    else
    {
        self.imageView.frame = CGRectMake(cropRect.size.height/2-cropRect.size.width/2+zoomviewMAX, zoomviewMAX, cropRect.size.width, cropRect.size.height);
    }
    NSLog(@"self.zoomView.center init %@",NSStringFromCGPoint(self.zoomView.center));
    [self setZoomviewToScrollviewCenter];
    CGFloat insetdis = 1000;//self.scrollView.frame.size.height/2-1;
    self.scrollView.contentInset = UIEdgeInsetsMake(insetdis, insetdis, insetdis, insetdis);
    
    isDefaultProtrait = YES;
    if (INTERFACE_LANDSCAPE)
    {
        isDefaultProtrait = NO;
    }
}

// 变更裁剪框的宽高比例
-(void)changeCropRectViewRatio:(CGFloat)ratio isFromBtn:(BOOL)isfrombtn
{
    CGRect cropRect = self.scrollView.frame;
    if (ratio <= 0)
    {
        self.cropRectView.keepingAspectRatio = NO;
        ratio = self.cropRectView.frame.size.width / self.cropRectView.frame.size.height; // originalRectRatio;
        if (self.isVertical)
        {
            ratio = self.cropRectView.frame.size.height / self.cropRectView.frame.size.width;
        }
        if (isfrombtn) // 从裁切比例按钮点击的才还原
        {
            ratio = originalRectRatio;
            [self resetAllSubviewLayouts];
            // 修正因设置了scrollview的minscalevalue导致图像偏移出界，所以再执行一次初始化
            ratio = originalRectRatio;
            [self resetAllSubviewLayouts];
            return;
        }
    }
    else
    {
        self.cropRectView.keepingAspectRatio = YES;
    }
    if (self.isVertical)
    {
        ratio = 1 / ratio;
    }
    self.cropRectView.fixedAspectRatio = ratio;
    CGFloat width = CGRectGetWidth(cropRect);
    CGFloat height = CGRectGetHeight(cropRect);
    height = width * ratio;
    cropRect.size = CGSizeMake(width, height);
    
    [self layoutCropRectViewWithCropRect:cropRect];
    [self layoutPECropViewSubviews];
}

// 右上角按钮旋转图片90度
-(void)directionRotateImageScrollView:(CGFloat)transRoat
{
    self.isVertical = NO;
    if ((self.imageNormal.size.width >= self.imageNormal.size.height && (transRoat == 90 || transRoat == 270)) ||
        (self.imageNormal.size.width < self.imageNormal.size.height && (transRoat == 0 || transRoat == 180)))
    {
        self.isVertical = YES;
    }
    CGAffineTransform transform = CGAffineTransformMakeRotation((transRoat + sliderValue) * ( M_PI / 180.0f));
    self.imageView.transform = transform;
    transRotate = transRoat;
}

#pragma mark - PECropRectView delegate

- (void)cropRectViewDidBeginEditing:(PECropRectView *)cropRectView
{
    perCropRect = cropRectView.frame;
    perCropRectBeforeEdit = cropRectView.frame;
}

- (void)cropRectViewEditingChanged:(PECropRectView *)cropRectView
{
    CGRect imgrect = self.imageView.bounds;
    CGRect zoomimgrect = [self convertRect:self.cropRectView.frame toView:self.imageView];
    
    CGPoint topleftpoint = [self convertPoint:cropRectView.frame.origin toView:self.imageView];
    CGPoint toprightpoint = [self convertPoint:CGPointMake(cropRectView.frame.origin.x + cropRectView.frame.size.width, cropRectView.frame.origin.y) toView:self.imageView];
    CGPoint bottomleftpoint = [self convertPoint:CGPointMake(cropRectView.frame.origin.x, cropRectView.frame.origin.y + cropRectView.frame.size.height) toView:self.imageView];
    CGPoint bottomrightpoint = [self convertPoint:CGPointMake(cropRectView.frame.origin.x + cropRectView.frame.size.width, cropRectView.frame.origin.y + cropRectView.frame.size.height) toView:self.imageView];
    
    if (!CGRectContainsRect(imgrect, zoomimgrect) &&
        ((self.cropRectView.resizeControlTBLR == topleft && !CGRectContainsPoint(imgrect, topleftpoint)) ||
         (self.cropRectView.resizeControlTBLR == topright && !CGRectContainsPoint(imgrect, toprightpoint)) ||
          (self.cropRectView.resizeControlTBLR == bottomleft && !CGRectContainsPoint(imgrect, bottomleftpoint)) ||
           (self.cropRectView.resizeControlTBLR == bottomright && !CGRectContainsPoint(imgrect, bottomrightpoint))))
    {
        //cropRectView.frame = perCropRect;
// 修正裁剪框拖不动
        if (cropRectView.frame.origin.x < perCropRect.origin.x && !CGRectContainsRect(imgrect,[self convertRect:CGRectMake(cropRectView.frame.origin.x, perCropRect.origin.y, perCropRect.size.width, perCropRect.size.height) toView:self.imageView])
            && (self.cropRectView.resizeControlTBLR == topleft || self.cropRectView.resizeControlTBLR == bottomleft))
        {
            cropRectView.frame = CGRectMake(perCropRect.origin.x, cropRectView.frame.origin.y, perCropRect.size.width, cropRectView.frame.size.height);
        }
        if (cropRectView.frame.origin.y < perCropRect.origin.y && !CGRectContainsRect(imgrect,[self convertRect:CGRectMake(perCropRect.origin.x, cropRectView.frame.origin.y, perCropRect.size.width, perCropRect.size.height) toView:self.imageView])
            && (self.cropRectView.resizeControlTBLR == topleft || self.cropRectView.resizeControlTBLR == topright))
        {
            cropRectView.frame = CGRectMake(cropRectView.frame.origin.x, perCropRect.origin.y, cropRectView.frame.size.width, perCropRect.size.height);
        }
        if (cropRectView.frame.size.width > perCropRect.size.width && !CGRectContainsRect(imgrect,[self convertRect:CGRectMake(perCropRect.origin.x, perCropRect.origin.y, cropRectView.frame.size.width, perCropRect.size.height) toView:self.imageView])
            && (self.cropRectView.resizeControlTBLR == topright || self.cropRectView.resizeControlTBLR == bottomright))
        {
            cropRectView.frame = CGRectMake(cropRectView.frame.origin.x, cropRectView.frame.origin.y, perCropRect.size.width, cropRectView.frame.size.height);
        }
        if (cropRectView.frame.size.height > perCropRect.size.height && !CGRectContainsRect(imgrect,[self convertRect:CGRectMake(perCropRect.origin.x, perCropRect.origin.y, perCropRect.size.width, cropRectView.frame.size.height) toView:self.imageView])
            && (self.cropRectView.resizeControlTBLR == bottomleft || self.cropRectView.resizeControlTBLR == bottomright))
        {
            cropRectView.frame = CGRectMake(cropRectView.frame.origin.x, cropRectView.frame.origin.y, cropRectView.frame.size.width, perCropRect.size.height);
        }
        if (self.cropRectView.resizeControlTBLR < 4)
        {
            cropRectView.frame = perCropRect;
            return;
        }
// 修正裁剪框拖不动 end
        //return;
    }
    perCropRect = cropRectView.frame;
    [self layoutOverlayViewsWithCropRect:cropRectView.frame];
    //NSLog(@"cropRectView.frame %@",NSStringFromCGRect(cropRectView.frame));
}

- (void)cropRectViewDidEndEditing:(PECropRectView *)cropRectView
{
    [self zoomToCropRect:self.cropRectView.frame];
}
- (void)zoomToCropRect:(CGRect)toRect
{
    if (CGRectEqualToRect(toRect,perCropRectBeforeEdit))
    {
        return;
    }
    
    CGRect editingRect;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        editingRect = CGRectInset(self.bounds, MarginLeft, MarginTop);
    } else {
        editingRect = CGRectInset(self.bounds, MarginLeft, MarginLeft);
    }
    
    CGFloat width = CGRectGetWidth(toRect);
    CGFloat height = CGRectGetHeight(toRect);
    
//    CGFloat scale = MIN(CGRectGetWidth(editingRect) / width, CGRectGetHeight(editingRect) / height);
//    
//    CGFloat scaledWidth = width * scale;
//    CGFloat scaledHeight = height * scale;
    CGRect resizeCropRect = [self changeCropRectViewRectSize:toRect.size];//CGRectMake((CGRectGetWidth(self.bounds) - scaledWidth) / 2,(CGRectGetHeight(self.bounds) - scaledHeight) / 2,scaledWidth,scaledHeight);
    
    CGRect zoomRect = [self convertRect:toRect toView:self.zoomView];
//    zoomRect.size.width = CGRectGetWidth(resizeCropRect) / (self.scrollView.zoomScale * scale);
//    zoomRect.size.height = CGRectGetHeight(resizeCropRect) / (self.scrollView.zoomScale * scale);
    
    __weak typeof(self)wself = self;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (self.scrollView.zoomScale < self.scrollView.maximumZoomScale)
        {
            wself.scrollView.bounds = resizeCropRect;
        }
        else
        {
            wself.scrollView.bounds = wself.bounds;
        }
        [wself.scrollView zoomToRect:zoomRect animated:NO];
        [wself.scrollView zoomToRect:zoomRect animated:NO];
    } completion:^(BOOL finished)
    {
        CGRect imgrect = wself.imageView.bounds;
        CGRect zoomimgrect = [wself convertRect:wself.cropRectView.frame toView:wself.imageView];
        if (!CGRectContainsRect(imgrect, zoomimgrect))
        {
            [wself checkAfterDragIsMoveImage];
            zoomimgrect = [wself convertRect:wself.cropRectView.frame toView:wself.imageView];
            if (!CGRectContainsRect(imgrect, zoomimgrect))
            {
                [wself slideRotateImageScrollView:sliderValue];
            }
        }
    }];
    
//stackoverflow.com/questions/2116349/zoomtorect-does-nothing-if-your-uiscrollview-is-already-at-that-zoomlevel
}

-(void)resizeControllerPinchView:(PECropRectView *)resizeConrolView
{
    
}

#pragma mark - ScrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.zoomView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
//    CGRect rRect = [self changeCropRectViewRectSize:self.imageNormal.size];
    //self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    if (self.scrollView.zoomScale < minScaleValue)
//    {
//        self.scrollView.zoomScale = minScaleValue;
//    }

    if (!isImageEdited && self.scrollView.zoomScale > scaleValue && !self.isClickBottom)
    {
        isImageEdited = YES;
    }
    [self setZoomviewToScrollviewCenter];
}

-(void)setZoomviewToScrollviewCenter
{
    if (isImageEdited)//self.scrollView.frame.size.width < self.zoomView.frame.size.width &&
    //if (self.imageView.frame.size.width > self.cropRectView.frame.size.width && self.imageView.frame.size.height > self.cropRectView.frame.size.height && isImageEdited)
    {
        return;
    }

    CGFloat offsetX = (self.zoomView.frame.size.width-self.scrollView.frame.size.width)/2;//(self.scrollView.frame.size.width > self.zoomView.frame.size.width)?(self.scrollView.frame.size.width - self.zoomView.frame.size.width) * 0.5 : 0.0;
    CGFloat offsetY = (self.zoomView.frame.size.height-self.scrollView.frame.size.height)/2;//(self.scrollView.frame.size.height > self.zoomView.frame.size.height)?(self.scrollView.frame.size.height - self.zoomView.frame.size.height) * 0.5 : 0.0;
    
    if (scaleValue < 1 && scaleValue != 0)
    {
//        self.zoomView.center = CGPointMake(self.scrollView.frame.size.width * 0.5,self.scrollView.frame.size.height * 0.5);
        return;
    }
    self.zoomView.center = CGPointMake(self.scrollView.frame.size.width * 0.5 + offsetX-zoomviewMAX,self.scrollView.frame.size.height * 0.5 + offsetY-zoomviewMAX);//CGPointMake(self.zoomView.frame.size.width * 0.5 + offsetX,self.zoomView.frame.size.height * 0.5 + offsetY);
    NSLog(@"self.zoomView.center %@ scalevalue %f",NSStringFromCGPoint(self.zoomView.center),scaleValue);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    //self.scrollView.contentInset = UIEdgeInsetsMake(1000, 1000, 1000, 1000);
    [self updateImageAnchorPoint];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isClickBottom || (!self.scrollView.isDragging && !self.scrollView.zooming))
    {
        perScrollviewContentoffset = self.scrollView.contentOffset;
        perScrollviewZoomScale = self.scrollView.zoomScale;
        return;
    }
    CGRect imgrect = self.imageView.bounds;
    CGRect zoomimgrect = [self convertRect:self.cropRectView.frame toView:self.imageView];
    if (!CGRectContainsRect(imgrect, zoomimgrect))
    {
//        [self checkAfterDragIsMoveImage];
        self.scrollView.contentOffset = perScrollviewContentoffset;
        self.scrollView.zoomScale = perScrollviewZoomScale;
        return;
    }
    perScrollviewContentoffset = self.scrollView.contentOffset;
    perScrollviewZoomScale = self.scrollView.zoomScale;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

-(void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{
    [self updateImageAnchorPoint];
}

//stackoverflow.com/questions/1968017/changing-my-calayers-anchorpoint-moves-the-view#
// 更新imageview的锚点
-(void)updateImageAnchorPoint
{
    CGPoint anchorP = [self convertPoint:self.center toView:self.imageView];
    if (self.imageNormal.size.width < self.imageNormal.size.height)
    {
        [self setAnchorPoint:CGPointMake(anchorP.x/originalRect.size.height, anchorP.y/originalRect.size.width) forView:self.imageView];
    }
    else
    {
        [self setAnchorPoint:CGPointMake(anchorP.x/originalRect.size.width, anchorP.y/originalRect.size.height) forView:self.imageView];
    }
}
// 修正更新锚点后imageview位置position出现偏移的问题
-(void)setAnchorPoint:(CGPoint)anchorP forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorP.x,
                                   view.bounds.size.height * anchorP.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                                   view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorP;
}

#pragma mark - crop finished get cropped uiimage

// 获取最终裁切图像
- (UIImage *)getCroppedUIImage
{
    self.imageView.transform = CGAffineTransformMakeRotation(0 * ( M_PI / 180.0f));
    CGRect cropRect = [self convertRect:self.cropRectView.frame toView:self.imageView];
    CGSize size = self.imageNormal.size;
    CGFloat ratio = 1.0f;
    self.imageView.transform = CGAffineTransformMakeRotation((transRotate + sliderValue) * ( M_PI / 180.0f));
    [self setAnchorPoint:CGPointMake(0.5, 0.5) forView:self.imageView];
    
    self.imageView.transform = CGAffineTransformMakeRotation(0 * ( M_PI / 180.0f));
    cropRect = [self convertRect:self.cropRectView.frame toView:self.imageView];
    self.imageView.transform = CGAffineTransformMakeRotation((transRotate + sliderValue) * ( M_PI / 180.0f));
    NSLog(@"NSStringFromCGRect(self.frame) %@",NSStringFromCGRect(self.frame));
    CGRect lrect = AVMakeRectWithAspectRatioInsideRect(self.imageNormal.size, CGRectInset(self.selfLandscapeFrame, MarginLeft, MarginTop));
    CGRect prect = AVMakeRectWithAspectRatioInsideRect(self.imageNormal.size, CGRectInset(self.selfProtraitFrame, MarginLeft, MarginTop));
    CGFloat fixratio = lrect.size.height / prect.size.height;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || UIInterfaceOrientationIsPortrait(orientation))
    {// 竖屏
        ratio = CGRectGetWidth(AVMakeRectWithAspectRatioInsideRect(self.imageNormal.size, self.insetRect)) / size.width;
        if (!isDefaultProtrait)
        {
            ratio = ratio * fixratio;
        }
    }
    else
    {// 横屏
        ratio = CGRectGetHeight(AVMakeRectWithAspectRatioInsideRect(self.imageNormal.size, self.insetRect)) / size.height;
        if (isDefaultProtrait)
        {
            ratio = ratio / fixratio;
        }
    }
    
    CGRect zoomedCropRect = CGRectMake(cropRect.origin.x / ratio,
                                       cropRect.origin.y / ratio,
                                       cropRect.size.width / ratio,
                                       cropRect.size.height / ratio);
    UIImage *rotatedImage = [self rotatedImageWithImage:self.imageNormal transform:self.imageView.transform];
    
    CGImageRef croppedImage = CGImageCreateWithImageInRect(rotatedImage.CGImage, zoomedCropRect);
    UIImage *image = [UIImage imageWithCGImage:croppedImage scale:1.0f orientation:rotatedImage.imageOrientation];
    CGImageRelease(croppedImage);
    
    return image;
}
- (UIImage *)rotatedImageWithImage:(UIImage *)image transform:(CGAffineTransform)transform
{
    CGSize size = image.size;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, size.width / 2, size.height / 2);
    CGContextConcatCTM(context, transform);
    CGContextTranslateCTM(context, size.width / -2, size.height / -2);
    [image drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return rotatedImage;
}

@end
