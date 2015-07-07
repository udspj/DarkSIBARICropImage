//
//  ViewController.m
//  CropSingle
//
//  Created by sunpeijia on 15-3-27.
//  Copyright (c) 2015年 sunpeijia. All rights reserved.
//

#import "ViewController.h"
#import "OLUtilities.h"
#import "utils.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    if(OS_OVER_7)
    {
        
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.picker animated:YES completion:nil];
}

-(void)CuttingPhotoDidFinish:(NSDictionary *)info
{
    
        
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        UIImage* imageCheck = nil;
        UIImage* imagePickerOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
    
        imageCheck = [UIImage imageWithData:UIImageJPEGRepresentation(imagePickerOriginal, 1.0)];
    
        CuttingPhotViewController   *cutViewController=[[CuttingPhotViewController  alloc]init];
        int pixel = DEVICE_PHONE ? 480 : 728;
        cutViewController.cropImage=[OLUtilities resizeImage:imageCheck maxResolution:pixel];
        cutViewController.cropInfo=info;
        cutViewController.delegate=self;
        cutViewController.trueImage=imageCheck;
        
        [self.navigationController  pushViewController:cutViewController animated:YES];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [self.picker dismissViewControllerAnimated:YES completion:^{}];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
