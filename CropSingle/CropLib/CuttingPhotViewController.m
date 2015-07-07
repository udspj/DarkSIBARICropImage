//
//  CuttingPhotViewController.m
//  SPL
//
//  Created by sunpeijia on 14/12/14.
//
//

#import "CuttingPhotViewController.h"
#import "OLUtilities.h"
#import <ImageIO/ImageIO.h>
#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageProperties.h>
#import "utils.h"


@implementation CuttingPhotViewController

@synthesize cropImage=_cropImage;
@synthesize delegate=_delegate;
@synthesize cropInfo=_cropInfo;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor blackColor];
}

- (void)viewDidUnload
{
    NSString* filePath = [NSString stringWithFormat:@"%@/tempFileWithExifForPhotoStory.jpg",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    [self releaseAndNil];
    [super viewDidUnload];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setupNavigationBar];

    memoryTag = 0;
    sliderValue = 0.0f;
    int pixel = DEVICE_PHONE ? 480 : 728;
    
    getImage= [self.cropInfo objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *imageCheckedSize = [OLUtilities resizeImage:getImage maxResolution:pixel];
    self.cropView = [[SIBARICropImageView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.bounds.size.height-160)];
    if(INTERFACE_LANDSCAPE && DEVICE_PHONE)
    {
        self.cropView.frame =CGRectMake(0,0, self.view.bounds.size.width-100, self.view.bounds.size.height-60);
    }
    [self.cropView setInitCropImage:imageCheckedSize];
    self.cropView.imageNormal = getImage;
    if (getImage.size.width < getImage.size.height)
    {
        self.cropView.isVertical = YES;
    }
    [self.view addSubview:self.cropView];
    [self changeCropRectViewRatio:1 isFromBtn:YES];
    [self changeCropRectViewRatio:0 isFromBtn:YES];
    

    Slider = [[RotateSlider alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-100-60, self.view.bounds.size.width, 60)];
    Slider.delegate = self;
    [self.view  addSubview:Slider];

    
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-100, self.view.bounds.size.width, 160)];
    backgroundView.backgroundColor=[UIColor colorWithRed:31.0f/255.0f green:31.0f/255.0f blue:31.0f/255.0f alpha:1.0f];
    [self.view  addSubview:backgroundView];
    
    
    cutScrollerView = [[CutScrollerView alloc] initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width, 100) CropImage:_cropImage];
    cutScrollerView.delegate = self;
    [backgroundView addSubview:cutScrollerView];
    //[cutScrollerView setScrollContentSize:CGSizeMake(0, 1000)];

    [self relySize];
}

-(void)setupNavigationBar
{
    [self.navigationController.navigationBar setTintColor:[UIColor  colorWithRed:211.0f/255.0f green:166.0f/255.0f blue:25.0f/255.0f alpha:1]];

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    UIBarButtonItem* fixedSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    fixedSpace.width = -13;
    UIBarButtonItem* backItem = [[[UIBarButtonItem alloc] initWithTitle:@"   back"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(back:)]autorelease];
    
    UIBarButtonItem* fixedSpace2 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    fixedSpace2.width = -13;
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: fixedSpace2,backItem,nil] animated:YES];
    
    self.title = @"crop image";
    self.navigationItem.titleView = [utils titleLabelWithTitle:self.title];
    UIImage* imageThumb =  [UIImage imageNamed:@"06-05_rotate_90_selected.png"];
    UIBarButtonItem* roatBtn = [[[UIBarButtonItem alloc] initWithImage:imageThumb
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(roatBackground:)] autorelease];
    UIBarButtonItem *close = [[[UIBarButtonItem alloc] initWithTitle:@"next"
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(saveAndExit:)]autorelease];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:close, roatBtn, nil];
}

-(void)back:(UIButton *)btn
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)saveAndExit:(UIButton *)btn
{
    UIImage *cuteditimg = [self.cropView getCroppedUIImage];
    NSMutableDictionary *dict= [NSMutableDictionary dictionaryWithDictionary:self.cropInfo];
    [dict setObject:cuteditimg forKey:UIImagePickerControllerEditedImage];
    [dict setObject:[NSNumber numberWithInt:UIImageOrientationRight] forKey:(NSString *) kCGImagePropertyOrientation];
    
    [_delegate CuttingPhotoDidFinish:dict];
    [self.navigationController  popViewControllerAnimated:NO];
}

#pragma mark - RotateSlider delegate

-(void)RotateSliderValueChanged:(float)value
{
    if (sliderValue == lroundf(value))
    {
        return;
    }
    sliderValue = lroundf(value);
    self.cropView.isClickBottom = YES;
    //NSLog(@"sliderValue %f",sliderValue);
    [self.cropView slideRotateImageScrollView:sliderValue];
    self.cropView.isClickBottom = NO;
}

-(void)sliderBegin:(UISlider *)slider
{
    [self.cropView.cropRectView setShowsGridMinor:YES];
}

-(void)sliderStop:(UISlider *)slider
{
    [self.cropView.cropRectView setShowsGridMinor:NO];
}

#pragma mark - CutScrollerView delegate

-(void)CutScrollerViewButtonClicked:(NSInteger)btntag
{
    //NSLog(@"btntag %d",btntag);
    [self changeCropRectViewRatio:btntag isFromBtn:YES];
}
-(void)changeCropRectViewRatio:(NSInteger)btntag isFromBtn:(BOOL)isbtn
{
    self.cropView.isClickBottom = YES;
    memoryTag = btntag;
    CGFloat ratio = 0.0f;
    switch (btntag) {
        case 0:
            if (isbtn)
            {
                [Slider resetSliderValue:0.0f];
                transRoat = 0.0f;
                Orient = transRoat;
            }
            break;
        case 1:
            ratio = 3.0f / 4.0f;
            break;
        case 2:
            ratio = 1.0f;
            break;
        case 3:
            ratio = 9.0f / 16.0f;
            break;
        case 4:
            ratio = 2.0f / 3.0f;
            break;
            
        default:
            break;
    }
    [self.cropView changeCropRectViewRatio:ratio isFromBtn:isbtn];
    self.cropView.isClickBottom = NO;
}

-(void)roatBackground:(UIButton *)btn
{
    transRoat = transRoat + 90.0f;
    if(transRoat == 360.0f)
    {
        transRoat = 0.0f;
    }
    [self.cropView directionRotateImageScrollView:transRoat];
    Orient = transRoat;
    [self changeCropRectViewRatio:memoryTag isFromBtn:NO];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)
interfaceOrientation duration:(NSTimeInterval)duration
{
    [self relySize];
}
//横竖屏适配
-(void)relySize
{
    CGFloat fixPnavibar = 44; // 竖屏导航条高度，无状态栏20px
    CGFloat fixLnavibar = 32; // 横屏导航条高度，无状态栏20px
    if (!DEVICE_PHONE)
    {
        fixPnavibar = 44;
        fixLnavibar = 44;
    }
    if(INTERFACE_LANDSCAPE)//如果横屏时候
    {
        if(DEVICE_PHONE)
        {
            //backgroundView.frame = CGRectMake(80, 0,self.view.bounds.size.width, 100);
            backgroundView.transform =	CGAffineTransformMakeRotation(90.0f * ( M_PI / 180.0f));
            backgroundView.frame=CGRectMake(self.view.bounds.size.width-100,0,100, self.view.bounds.size.height);
            self.cropView.frame =CGRectMake(0,0, self.view.bounds.size.width-100, self.view.bounds.size.height-60);
            [self.cropView layoutPECropViewSubviews];
            cutScrollerView.transform =	CGAffineTransformMakeRotation(0.0f * ( M_PI / 180.0f));
            cutScrollerView.frame = CGRectMake(0, 0,self.view.bounds.size.width, 100);
            //[cutScrollerView setScrollContentSize:CGSizeMake(5*(100)+20+250, 0)];
            Slider.frame=CGRectMake(0, self.view.bounds.size.height-60, self.view.bounds.size.width-100, 60);
            
            self.cropView.selfProtraitFrame = CGRectMake(0,0, self.view.bounds.size.height+fixLnavibar, self.view.bounds.size.width-160-fixPnavibar);
            self.cropView.selfLandscapeFrame = CGRectMake(0,0, self.view.bounds.size.width-100, self.view.bounds.size.height-60);
        }
        else
        {
            self.cropView.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.bounds.size.height-160);//CGRectMake(0,self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.bounds.size.height-160-self.navigationController.navigationBar.frame.size.height);
            [self.cropView layoutPECropViewSubviews];
            backgroundView.transform =	CGAffineTransformMakeRotation(0.0f * ( M_PI / 180.0f));
            backgroundView.frame=CGRectMake(0, self.view.bounds.size.height-100, self.view.bounds.size.width, 160);
            cutScrollerView.transform =	CGAffineTransformMakeRotation(0.0f * ( M_PI / 180.0f));
            cutScrollerView.frame = CGRectMake(0, 0,self.view.bounds.size.width, 100);
            Slider.frame=CGRectMake(0, self.view.bounds.size.height-100-60, self.view.bounds.size.width, 60);
            
            self.cropView.selfProtraitFrame = CGRectMake(0,0, self.view.bounds.size.height+fixLnavibar, self.view.bounds.size.width-160-fixPnavibar);
            self.cropView.selfLandscapeFrame = CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height-160);
        }
    }
    else
    {
        if(DEVICE_PHONE)
        {
            backgroundView.transform =	CGAffineTransformMakeRotation(0.0f * ( M_PI / 180.0f));
            backgroundView.frame=CGRectMake(0, self.view.bounds.size.height-100, self.view.bounds.size.width, 160);
            cutScrollerView.transform =	CGAffineTransformMakeRotation(0.0f * ( M_PI / 180.0f));
            cutScrollerView.frame = CGRectMake(0, 0,self.view.bounds.size.width, 100);
            self.cropView.frame = CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height-160);
            [self.cropView layoutPECropViewSubviews];
            Slider.frame=CGRectMake(0, self.view.bounds.size.height-100-60, self.view.bounds.size.width, 60);
            
            self.cropView.selfProtraitFrame = CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height-160);
            self.cropView.selfLandscapeFrame = CGRectMake(0,0, self.view.bounds.size.height-100+fixPnavibar, self.view.bounds.size.width-60-fixLnavibar);
        }
        else
        {
            backgroundView.transform =	CGAffineTransformMakeRotation(0.0f * ( M_PI / 180.0f));
            backgroundView.frame=CGRectMake(0, self.view.bounds.size.height-100, self.view.bounds.size.width, 160);
            cutScrollerView.transform =	CGAffineTransformMakeRotation(0.0f * ( M_PI / 180.0f));
            cutScrollerView.frame = CGRectMake(0, 0,self.view.bounds.size.width, 100);
            self.cropView.frame =CGRectMake(0,0, self.view.frame.size.width, self.view.bounds.size.height-160);
            [self.cropView layoutPECropViewSubviews];
            Slider.frame=CGRectMake(0, self.view.bounds.size.height-100-60, self.view.bounds.size.width, 60);
            
            self.cropView.selfProtraitFrame = CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height-160);
            self.cropView.selfLandscapeFrame = CGRectMake(0,0, self.view.bounds.size.height+fixPnavibar, self.view.bounds.size.width-160-fixLnavibar);
        }
    }
}

-(void)releaseAndNil
{
//    if(artFilterPreView)
//    {
//        [artFilterPreView release];
//        artFilterPreView  = nil;
//    }
    if(_cropImage)
    {
        [_cropImage release];
        _cropImage  = nil;
    }
    
    if(_cropView)
    {
        [_cropView release];
        _cropView  = nil;
    }
    if(_cropInfo)
    {
        [_cropInfo release];
        _cropInfo  = nil;
    }
    if(backgroundView)
    {
        [backgroundView release];
        backgroundView  = nil;
    }
    if(_trueImage)
    {
        [_trueImage release];
        _trueImage  = nil;
    }
    
}
-(void)dealloc
{
    [self releaseAndNil];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
