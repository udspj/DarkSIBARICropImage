//
//  CutScrollerView.h
//  SPL
//
//  Created by sunpeijia on 15-2-10.
//
//

#import <UIKit/UIKit.h>

@protocol CutScrollerViewDelegate <NSObject>

-(void)CutScrollerViewButtonClicked:(NSInteger)btntag;

@end

@interface CutScrollerView : UIView <UIScrollViewDelegate>
{
    UIScrollView *cutScrollerView;//略缩图scroller
    UIImage *_cropImage;
    __weak id<CutScrollerViewDelegate> delegate;
}

@property(nonatomic,weak)__weak id<CutScrollerViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame CropImage:(UIImage *)cropImage;

-(void)setScrollContentSize:(CGSize)cgsize;

@end
