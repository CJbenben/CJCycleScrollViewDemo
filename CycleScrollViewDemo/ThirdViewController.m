//
//  ThirdViewController.m
//  CycleScrollViewDemo
//
//  Created by ChenJie on 16/5/5.
//  Copyright © 2016年 ChenJie. All rights reserved.
//

#import "ThirdViewController.h"
#import "CJCycleScrollView.h"
#import "NSTimer+Addition.h"

#define SERVICE_IMAGEURL @"http://101.231.75.25:8080/img/"

#define iPhoneW [UIScreen mainScreen].bounds.size.width
#define iPhoneH [UIScreen mainScreen].bounds.size.height
#define DURATIONTIME 2.0
#define BANNER_HEIGHT 180

@interface ThirdViewController ()

@property (strong, nonatomic) NSMutableArray *imagePathAry3;

@property (strong, nonatomic) CJCycleScrollView *scrollView3;

@end

@implementation ThirdViewController

- (NSMutableArray *)imagePathAry3{
    if (!_imagePathAry3) {
        NSString *firstURL = [NSString stringWithFormat:@"%@%@",SERVICE_IMAGEURL,@"INDEX_zhuying.jpg"];
        NSString *secondURL = [NSString stringWithFormat:@"%@%@",SERVICE_IMAGEURL,@"INDEX_higherHealth.jpg"];
        NSString *thirdURL = [NSString stringWithFormat:@"%@%@",SERVICE_IMAGEURL,@"INDEX_foreignHealth.jpg"];
        NSString *fourURL = [NSString stringWithFormat:@"%@%@",SERVICE_IMAGEURL,@"INDEX_weather.jpg"];
        _imagePathAry3 = [@[fourURL,firstURL,secondURL,thirdURL,fourURL,firstURL] mutableCopy];
    }
    return _imagePathAry3;
}
#pragma mark -
#pragma mark - viewDidLoad
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.scrollView3.timer resumeTimerAfterTimeInterval:DURATIONTIME];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加载网络图片(自定义图片宽度)";
    
    self.navigationController.navigationBar.translucent = NO;
    [self secondMethod2];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.scrollView3.timer pauseTimer];
}

#pragma mark -
#pragma mark - 加载本地图片
- (void)secondMethod2{
    CGRect scrollViewF = CGRectMake(0, 20, iPhoneW, BANNER_HEIGHT);
    CGRect imageViewF = CGRectMake(10, 20, iPhoneW - 20, BANNER_HEIGHT);
    
    self.scrollView3 = [CJCycleScrollView cjCycleScrollViewFrame:scrollViewF imageViewFrame:imageViewF radius:30.0 imagePaths:self.imagePathAry3 animationDuration:0.0];
    self.scrollView3.pageControllPostion = PageControlPostionLeft;
    self.scrollView3.TapActionBlock = ^(NSInteger pageIndex){
        NSLog(@"pageIndex:%ld",pageIndex);
    };
    [self.view addSubview:self.scrollView3];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
