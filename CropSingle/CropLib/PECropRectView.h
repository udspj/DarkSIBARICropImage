//
//  PECropRectView.h
//  PhotoCropEditor
//
//  Created by kishikawa katsumi on 2013/05/21.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    top = 0,
    left = 1,
    bottom = 2,
    right = 3,
    topleft = 4,
    topright = 5,
    bottomleft = 6,
    bottomright = 7
}ResizeControlTBLR;

@protocol PECropRectViewDelegate;

@interface PECropRectView : UIView

@property (nonatomic, weak) id<PECropRectViewDelegate> delegate;
@property (nonatomic) BOOL showsGridMajor;
@property (nonatomic) BOOL showsGridMinor;

@property (nonatomic) BOOL keepingAspectRatio;
@property (nonatomic) CGFloat fixedAspectRatio;

@property (assign) ResizeControlTBLR resizeControlTBLR; // 指示点击的是哪个角

@end

@protocol PECropRectViewDelegate <NSObject>

- (void)cropRectViewDidBeginEditing:(PECropRectView *)cropRectView;
- (void)cropRectViewEditingChanged:(PECropRectView *)cropRectView;
- (void)cropRectViewDidEndEditing:(PECropRectView *)cropRectView;

@end

