//
//  CutScrollerView.m
//  SPL
//
//  Created by sunpeijia on 15-2-10.
//
//

#import "CutScrollerView.h"
#import "CropThumButton.h"
#import "utils.h"

@implementation CutScrollerView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame CropImage:(UIImage *)cropImage
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _cropImage = cropImage;
        
        cutScrollerView = [[UIScrollView alloc] init] ;
        cutScrollerView.delegate = self;
        cutScrollerView.frame = self.frame;
//        cutScrollerView.frame = CGRectMake(0, 0,self.bounds.size.width, 100);
        cutScrollerView.scrollEnabled = YES;
        cutScrollerView.directionalLockEnabled = YES;
        cutScrollerView.showsVerticalScrollIndicator = NO;
        cutScrollerView.showsHorizontalScrollIndicator = YES;
        cutScrollerView.alwaysBounceHorizontal = YES;
        cutScrollerView.backgroundColor=[UIColor  blackColor];
        cutScrollerView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
        [self addSubview:cutScrollerView];
        
        int thumbCount = 5;	//アートフィルタファンクション数＋オリジナルの１個足す
        for(int thumbnailIndex=0;thumbnailIndex<thumbCount;thumbnailIndex++)
        {
            CropThumButton  * tempBtn = [[CropThumButton alloc]init];
            [tempBtn  addTarget:self action:@selector(CropThumButton:) forControlEvents:UIControlEventTouchUpInside];
            tempBtn.tag=thumbnailIndex;
            tempBtn.frame=CGRectMake(thumbnailIndex*(65+10)+10, 10, 65, 65);
            cutScrollerView.contentSize=CGSizeMake(thumbCount*(65+10)+10, 0);
            [cutScrollerView addSubview:tempBtn];
            
            if(thumbnailIndex==0)
            {
                UIImageView* btnSelectFrame = [[UIImageView alloc]initWithFrame:CGRectMake(-7, -7, tempBtn.bounds.size.width+14, tempBtn.bounds.size.height+14)];
                if(DEVICE_PHONE)
                {
                    btnSelectFrame.frame = CGRectMake(-4, -4, tempBtn.bounds.size.width+8, tempBtn.bounds.size.height+8);
                }
                btnSelectFrame.image = [UIImage imageNamed:kSign_Stamp_Select_Thumbnail_Filename];
                btnSelectFrame.contentMode = UIViewContentModeScaleAspectFill;
                btnSelectFrame.tag = SIGN_STAMP_SCROLL_BTN_TAG;
                [tempBtn addSubview:btnSelectFrame];
                tempBtn.cropLabel.text=@"original";//[[OLLocalize getLocalizeObject] getLocalizedString:@"ID_TRIMMING_ORIGINAL"];
                CGFloat ratio ;
                if(_cropImage.size.width>_cropImage.size.height)
                    ratio = _cropImage.size.height / _cropImage.size.width;
                else
                    ratio = _cropImage.size.height / _cropImage.size.width;//原图特殊
                
                CGRect  crect=[self  fitToRect:ratio];
                tempBtn.cropImage.image= [self  getImageFromImage:crect];
            }
            else if (thumbnailIndex==1)
            {
                tempBtn.cropLabel.text=@"3:4";//[[OLLocalize getLocalizeObject] getLocalizedString:@"ID_TRIMMING_4_3"];
                
                CGFloat ratio = 3.0f / 4.0f;
                
                CGRect  crect=[self  fitToRect:ratio];
                
                tempBtn.cropImage.image= [self  getImageFromImage:crect];
            }
            else if (thumbnailIndex==2)
            {
                tempBtn.cropLabel.text=@"1:1";//[[OLLocalize getLocalizeObject] getLocalizedString:@"ID_TRIMMING_1_1"];
                CGFloat ratio = 1.0f / 1.0f;
                CGRect  crect=[self  fitToRect:ratio];
                tempBtn.cropImage.image= [self  getImageFromImage:crect];
            }
            else if (thumbnailIndex==3)
            {
                tempBtn.cropLabel.text=@"9:16";//[[OLLocalize getLocalizeObject] getLocalizedString:@"ID_TRIMMING_16_9"];
                CGRect  crect=[self  fitToRect:9.0f /16.0f];
                tempBtn.cropImage.image= [self  getImageFromImage:crect];
            }
            else
            {
                tempBtn.cropLabel.text=@"2:3";//[[OLLocalize getLocalizeObject] getLocalizedString:@"ID_TRIMMING_3_2"];
//                self.cropView.aspectRatio = 3.0f / 2.0f;
                CGRect  crect=[self  fitToRect:2.0f /3.0f];
                tempBtn.cropImage.image= [self  getImageFromImage:crect];
            }
        }
    }
    return self;
}

//计算截取的坐标
-(CGRect)fitToRect:(CGFloat)roat
{
    
    CGRect  crect;
    
    if(_cropImage.size.width>_cropImage.size.height)
    {
        
        CGFloat  big=_cropImage.size.width;
        CGSize   fitSize=  [self   SizeWidthFitHeightBig:big AndRoat:roat];
        crect=CGRectMake(_cropImage.size.width/2.0f-(fitSize.width)/2.0f, _cropImage.size.width/2.0f-(fitSize.height)/2.0f, fitSize.width, fitSize.height);
        
    }
    else
    {
        
        CGFloat  big=_cropImage.size.height;
        CGSize   fitSize=  [self   SizeWidthFitWidthtBig:big AndRoat:1/roat];
        crect=CGRectMake(_cropImage.size.width/2.0f-(fitSize.width)/2.0f, _cropImage.size.width/2.0f-(fitSize.height)/2.0f, fitSize.width, fitSize.height);
    }
    
    return crect;
    
}
//计算合适的高度
-(CGSize)SizeWidthFitHeightBig:(CGFloat )big   AndRoat:(CGFloat)roat
{
    
    while(big*roat>=_cropImage.size.height)
    {
        big--;
    }
    
    CGSize  fitSize=CGSizeMake(big, big*roat);
    return  fitSize;
    
    
}
//计算合适的宽度
-(CGSize)SizeWidthFitWidthtBig:(CGFloat )big   AndRoat:(CGFloat)roat
{
    
    
    while(big*roat>=_cropImage.size.width)
    {
        big--;
    }
    CGSize  fitSize=CGSizeMake(big*roat, big);
    return  fitSize;
    
}
//略缩图
-(UIImage *)getImageFromImage:(CGRect)myImageRect
{
    //大图bigImage
    //定义myImageRect，截图的区域
    NSLog(@"NSStringFromCGRect%@", NSStringFromCGSize(_cropImage.size));
    NSLog(@"myImageRect%@", NSStringFromCGRect(myImageRect));
    CGImageRef imageRef = _cropImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = 65;
    size.height = 65;
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage *image = [UIImage imageWithCGImage:subImageRef scale:1.0f orientation:_cropImage.imageOrientation];
    UIGraphicsEndImageContext();
    return image;
    
}

-(void)CropThumButton:(CropThumButton *)sender
{
    
    for( UIView* view in cutScrollerView.subviews )
    {
        if([view isKindOfClass:[UIButton class]])
        {
            CropThumButton* tempBtn = (CropThumButton*)view;
            for( UIImageView* btnFrame in tempBtn.subviews )
            {
                if( btnFrame.tag == SIGN_STAMP_SCROLL_BTN_TAG )
                {
                    [btnFrame removeFromSuperview];
                    [btnFrame setNeedsDisplay];
                }
            }
            tempBtn.selected = NO;
        }
    }
    
    UIImageView* btnSelectFrame = [[UIImageView alloc]initWithFrame:CGRectMake(-7, -7, sender.bounds.size.width+14, sender.bounds.size.height+14)];
    if(DEVICE_PHONE)
    {
        btnSelectFrame.frame = CGRectMake(-4, -4, sender.bounds.size.width+8, sender.bounds.size.height+8);
    }
    
    btnSelectFrame.image = [UIImage imageNamed:kSign_Stamp_Select_Thumbnail_Filename];
    btnSelectFrame.contentMode = UIViewContentModeScaleAspectFill;
    btnSelectFrame.tag = SIGN_STAMP_SCROLL_BTN_TAG;
    [sender addSubview:btnSelectFrame];
    
    [self.delegate CutScrollerViewButtonClicked:sender.tag];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    cutScrollerView.frame = self.frame;
    if(INTERFACE_LANDSCAPE && DEVICE_PHONE)//如果横屏时候
    {
        cutScrollerView.contentSize=CGSizeMake(5*(100)+20+250, 0);//(5*(100)+20, 0);
    }
    else
    {
        cutScrollerView.contentSize = CGSizeMake(5*(65+10)+10, 0);
    }
    
    for(UIButton *view in cutScrollerView.subviews)
    {
        CropThumButton *btn = (CropThumButton *)view;
        int thum = btn.tag;
        if(INTERFACE_LANDSCAPE && DEVICE_PHONE)//如果横屏时候
        {
            btn.frame = CGRectMake(thum*90+20,15 , 65, 65);
            btn.transform = CGAffineTransformMakeRotation(270 * ( M_PI / 180.0f));
        }
        else
        {
            btn.frame = CGRectMake(thum*(65+10)+10, 10, 65, 65);
            btn.transform = CGAffineTransformMakeRotation(0 * ( M_PI / 180.0f));
        }
    }
}

-(void)setScrollContentSize:(CGSize)cgsize
{
    cutScrollerView.contentSize = cgsize;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
