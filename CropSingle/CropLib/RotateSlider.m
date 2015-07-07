//
//  rotateSlider.m
//  SPL
//
//  Created by sunpeijia on 15-2-10.
//
//

#import "RotateSlider.h"
#import "utils.h"

//#define slider_width 304
//#define slider_height 26

@implementation RotateSlider

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=[UIColor colorWithRed:31.0f/255.0f green:31.0f/255.0f blue:31.0f/255.0f alpha:1.0f];
        
//        imageViewBg=[[UIImageView alloc]init];
//        imageViewBg.frame=CGRectMake(0, 30, self.frame.size.width, 30);
//        imageViewBg.userInteractionEnabled=YES;
//        [self addSubview:imageViewBg];
        
        UIImage *sliderimg = [UIImage imageNamed:@"06-06_rotate_fineadjust_scale"];
        slider_width = sliderimg.size.width;
        slider_height = sliderimg.size.height;
        imageViewSLd=[[UIImageView  alloc]initWithImage:sliderimg];
        imageViewSLd.frame=CGRectMake(self.bounds.size.width/2 - slider_width/2, 15, slider_width, slider_height);//CGRectMake(0, 30, self.frame.size.width, 30);
        imageViewSLd.userInteractionEnabled=YES;
        [self addSubview:imageViewSLd];
        
        upSlider=[[UISlider   alloc]init];
        upSlider.frame=CGRectMake(-4, -10, slider_width + 8, 10);
        upSlider.backgroundColor=[UIColor  clearColor];
        [upSlider setThumbImage:[UIImage  imageNamed:@"06-08_rotate_fineadjust_centerarrow"] forState:UIControlStateNormal];
        upSlider.minimumTrackTintColor=[UIColor  clearColor];
        upSlider.maximumTrackTintColor=[UIColor  clearColor];
        [upSlider setMinimumTrackImage:[UIImage imageNamed:@"dhClear"] forState:UIControlStateNormal];
        upSlider.value=0;
        upSlider.minimumValue=-30;
        upSlider.maximumValue=30;
        [imageViewSLd  addSubview:upSlider];
        
        Slider=[[UISlider   alloc]init];
        Slider.frame=CGRectMake(0, 0, slider_width, 30);
        Slider.backgroundColor=[UIColor  clearColor];
        [Slider addTarget:self action:@selector(sliderValue:) forControlEvents:UIControlEventValueChanged];
        
        Slider.value=0;
        Slider.minimumValue=-30;
        Slider.maximumValue=30;
        [Slider setThumbImage:[UIImage  imageNamed:@"06-07_rotate_fineadjust_centerline"] forState:UIControlStateHighlighted];
        [Slider setThumbImage:[UIImage  imageNamed:@"06-07_rotate_fineadjust_centerline"] forState:UIControlStateNormal];
        Slider.minimumTrackTintColor=[UIColor  clearColor];
        Slider.maximumTrackTintColor=[UIColor  clearColor];
        [Slider setMinimumTrackImage:[UIImage imageNamed:@"dhClear"] forState:UIControlStateNormal];
        [imageViewSLd  addSubview:Slider];
        
        [Slider addTarget:self action:@selector(sliderBeginControl:) forControlEvents:UIControlEventTouchDown];
        [Slider addTarget:self action:@selector(sliderStopControl:) forControlEvents:UIControlEventTouchUpInside];
        [Slider addTarget:self action:@selector(sliderStopControl:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return self;
}

-(void)sliderValue:(UISlider *)uislider
{
    upSlider.value = uislider.value;
    [delegate RotateSliderValueChanged:uislider.value];
}

-(void)sliderBeginControl:(UISlider *)slider
{
    if ([delegate respondsToSelector:@selector(sliderBegin:)])
    {
        [delegate sliderBegin:slider];
    }
}
-(void)sliderStopControl:(UISlider *)slider
{
    if ([delegate respondsToSelector:@selector(sliderStop:)])
    {
        [delegate sliderStop:slider];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    imageViewSLd.frame = CGRectMake(self.bounds.size.width/2 - slider_width/2, 15, slider_width, slider_height);
}

-(void)resetSliderValue:(CGFloat)value
{
    upSlider.value = value;
    Slider.value = value;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
