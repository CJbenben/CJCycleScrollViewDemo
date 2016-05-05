//
//  CJViewController.m
//  CycleScrollViewDemo
//
//  Created by ChenJie on 16/5/4.
//  Copyright © 2016年 ChenJie. All rights reserved.
//

#import "CJViewController.h"
#import "CJCycleScrollView.h"
#import "NSTimer+Addition.h"

#define SERVICE_IMAGEURL @"http://101.231.75.25:8080/img/"

#define iPhoneW [UIScreen mainScreen].bounds.size.width
#define iPhoneH [UIScreen mainScreen].bounds.size.height
#define DURATIONTIME 2.0
#define BANNER_HEIGHT 180

@interface CJViewController ()

@property (strong, nonatomic) NSMutableArray *imagePathAry2;

@property (strong, nonatomic) CJCycleScrollView *scrollView2;

@end

@implementation CJViewController

- (NSMutableArray *)imagePathAry2{
    if (!_imagePathAry2) {
        NSString *firstURL = [NSString stringWithFormat:@"%@%@",SERVICE_IMAGEURL,@"INDEX_zhuying.jpg"];
        NSString *secondURL = [NSString stringWithFormat:@"%@%@",SERVICE_IMAGEURL,@"INDEX_higherHealth.jpg"];
        NSString *thirdURL = [NSString stringWithFormat:@"%@%@",SERVICE_IMAGEURL,@"INDEX_foreignHealth.jpg"];
        NSString *fourURL = [NSString stringWithFormat:@"%@%@",SERVICE_IMAGEURL,@"INDEX_weather.jpg"];
        _imagePathAry2 = [@[fourURL,firstURL,secondURL,thirdURL,fourURL,firstURL] mutableCopy];
    }
    return _imagePathAry2;
}
#pragma mark -
#pragma mark - viewDidLoad
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.scrollView2.timer resumeTimerAfterTimeInterval:DURATIONTIME];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加载网络图片(图片为屏宽)";
    
    self.navigationController.navigationBar.translucent = NO;
    [self secondMethod2];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.scrollView2.timer pauseTimer];
}

#pragma mark -
#pragma mark - 加载本地图片
- (void)secondMethod2{
    CGRect scrollViewF = CGRectMake(0, 10, iPhoneW, BANNER_HEIGHT);
    
    self.scrollView2 = [CJCycleScrollView cjCycleScrollViewFrame:scrollViewF imagePaths:self.imagePathAry2 animationDuration:0.0];
    self.scrollView2.pageControllPostion = PageControlPostionRight;
    self.scrollView2.TapActionBlock = ^(NSInteger pageIndex){
        NSLog(@"pageIndex:%ld",pageIndex);
    };
    [self.view addSubview:self.scrollView2];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
