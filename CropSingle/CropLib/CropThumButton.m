//
//  CropThumButton.m
//  SPL
//
//  Created by sunpeijia on 14/11/12.
//
//

#import "CropThumButton.h"

@implementation CropThumButton


@synthesize cropImage=_cropImage;
@synthesize cropLabel=_cropLabel;
-(id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _cropImage=[[UIImageView   alloc]init];
        _cropImage.frame=CGRectMake(0, 0, 65, 65);
//        _cropImage.backgroundColor=[UIColor   blueColor];
//        _cropImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _cropImage.contentMode = UIViewContentModeScaleAspectFit;

        [self  addSubview:_cropImage];
        
        _cropLabel=[[UILabel  alloc]init];
        _cropLabel.frame=CGRectMake(0, 65, 65, 20);
        _cropLabel.font=[UIFont   systemFontOfSize:10];
        _cropLabel.textColor=[UIColor  whiteColor];
        _cropLabel.textAlignment=NSTextAlignmentCenter;
        _cropLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _cropLabel.numberOfLines = 0;
        _cropLabel.text=@"nothing";
        [self  addSubview:_cropLabel];
        
        
        
    }
    return self;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
