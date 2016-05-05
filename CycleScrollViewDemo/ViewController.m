//
//  ViewController.m
//  CycleScrollViewDemo
//
//  Created by ChenJie on 15/10/29.
//  Copyright © 2015年 ChenJie. All rights reserved.
//

#import "ViewController.h"
#import "CJCycleScrollView.h"
#import "NSTimer+Addition.h"

#define iPhoneW [UIScreen mainScreen].bounds.size.width
#define iPhoneH [UIScreen mainScreen].bounds.size.height
#define DURATIONTIME 2.0
#define BANNER_HEIGHT 180

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *imagePathAry1;

@property (strong, nonatomic) CJCycleScrollView *scrollView1;

@end

@implementation ViewController
- (NSMutableArray *)imagePathAry1{
    if (!_imagePathAry1) {
        NSString *firstImageName = @"banner1";
        NSString *secondImageName = @"banner2";
        NSString *thirdImageName = @"banner3";
        NSString *fourImageName = @"banner4";
        _imagePathAry1 = [@[fourImageName,firstImageName,secondImageName,thirdImageName,fourImageName,firstImageName] mutableCopy];
    }
    return _imagePathAry1;
}

#pragma mark - 
#pragma mark - viewDidLoad
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.scrollView1.timer resumeTimerAfterTimeInterval:DURATIONTIME];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加载本地图片";
    
    self.navigationController.navigationBar.translucent = NO;
    [self firstMethod1];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.scrollView1.timer pauseTimer];
}

#pragma mark -
#pragma mark - 加载本地图片
- (void)firstMethod1{
    CGRect frame = CGRectMake(0, 10, iPhoneW, BANNER_HEIGHT);
    self.scrollView1 = [[CJCycleScrollView alloc] initWithFrame:frame imageNames:self.imagePathAry1 animationDuration:0.0];
//    __weak typeof(self) weakself = self;
    self.scrollView1.pageControllPostion = PageControlPostionCenter;
    self.scrollView1.TapActionBlock = ^(NSInteger pageIndex){
        NSLog(@"pageIndex:%ld",pageIndex);
    };
    [self.view addSubview:self.scrollView1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
