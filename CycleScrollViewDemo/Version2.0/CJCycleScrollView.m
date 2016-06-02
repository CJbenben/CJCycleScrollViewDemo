//
//  CJCycleScrollView.m
//  CycleScrollViewDemo
//
//  Created by ChenJie on 15/10/29.
//  Copyright © 2015年 ChenJie. All rights reserved.
//

#import "CJCycleScrollView.h"
#import "NSTimer+Addition.h"
#import "UIImageView+WebCache.h"

#define iPhoneW [UIScreen mainScreen].bounds.size.width
#define iPhoneH [UIScreen mainScreen].bounds.size.height

#define PAGECONTROL_WIDTH       30
#define PAGECONTROL_HEIGHT      30

@interface CJCycleScrollView()<UIScrollViewDelegate>
/**
 *  滚动图片总数
 */
@property (assign, nonatomic) NSInteger imageCount;

/**
 *  当前页
 */
@property (assign, nonatomic) CGFloat currentIndex;

@property (assign, nonatomic) CGFloat x;

/**
 *  动画时间
 */
@property (nonatomic , assign) NSTimeInterval animationDuration;

/**
 *  滚动视图异常处理计数
 */
@property (assign, nonatomic) NSInteger scrollAbnormalCount;


@property (assign, nonatomic) CGFloat imageX;

@end

@implementation CJCycleScrollView

- (void)setPageControllPostion:(PageControlPostion)pageControllPostion{
    
    _pageControllPostion = pageControllPostion;
    
    if (_pageControllPostion == PageControlPostionLeft){
        self.pageControl.frame = CGRectMake(30, self.frame.size.height - PAGECONTROL_HEIGHT, PAGECONTROL_WIDTH, PAGECONTROL_HEIGHT);
    }else if (_pageControllPostion == PageControlPostionRight) {
        self.pageControl.frame = CGRectMake(iPhoneW - 30 - PAGECONTROL_WIDTH, self.frame.size.height - PAGECONTROL_HEIGHT, PAGECONTROL_WIDTH, PAGECONTROL_HEIGHT);
    }else if (_pageControllPostion == PageControlPostionTop) {
        self.pageControl.frame = CGRectMake((iPhoneW - PAGECONTROL_WIDTH)/2.0, -PAGECONTROL_HEIGHT, PAGECONTROL_WIDTH, PAGECONTROL_HEIGHT);
    }else if (_pageControllPostion == PageControlPostionBottom){
        self.pageControl.frame = CGRectMake((iPhoneW - PAGECONTROL_WIDTH)/2.0, self.frame.size.height, PAGECONTROL_WIDTH, PAGECONTROL_HEIGHT);
    }else if (_pageControllPostion == PageControlPostionNull){
        self.pageControl.frame = CGRectMake((iPhoneW - PAGECONTROL_WIDTH)/2.0, iPhoneH, PAGECONTROL_WIDTH, PAGECONTROL_HEIGHT);
    }else{
        self.pageControl.frame = CGRectMake((iPhoneW - PAGECONTROL_WIDTH)/2.0, self.frame.size.height - PAGECONTROL_HEIGHT, PAGECONTROL_WIDTH, PAGECONTROL_HEIGHT);
    }
    
}

+ (instancetype)cjCycleScrollViewFrame:(CGRect)scrollViewF imagePaths:(NSMutableArray *)imagePaths animationDuration:(NSTimeInterval)animationDuration{
    CGRect imageViewF = CGRectMake(0, 0, scrollViewF.size.width, scrollViewF.size.height);
    return [self cjCycleScrollViewFrame:scrollViewF imageViewFrame:imageViewF radius:0.0 imagePaths:imagePaths animationDuration:animationDuration];
}


//**********************************************************自定义滚动位置▼**********************************************************/
- (instancetype)initWithFrame:(CGRect)frame imageViewFrame:(CGRect)imageViewF radius:(CGFloat)radius imagePaths:(NSMutableArray *)imagePaths animationDuration:(NSTimeInterval)animationDuration{
    if (self = [super initWithFrame:frame]) {
        self.x = iPhoneW;
        if (animationDuration > 0.0) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration) target:self selector:@selector(updateCycleScrollImagesLocation) userInfo:nil repeats:YES];
        }
        CGRect scrollFrame = CGRectMake(0, 0, iPhoneW, frame.size.height);
        
        CGRect imageViewFrame = imageViewF;
        
        self.imageX = imageViewFrame.origin.x;
        
        self.scrollView = [self createScrollViewWithPath:imagePaths scrollViewFrame:scrollFrame imageViewFrame:imageViewFrame radius:radius];
        self.scrollView.delegate = self;
        CGRect frame = scrollFrame;
        frame.origin.x = frame.size.width;
        [self.scrollView scrollRectToVisible:frame animated:NO];
        [self addSubview:self.scrollView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [self.scrollView addGestureRecognizer:tapGesture];
        
        CGRect pageFrame = CGRectMake(frame.size.width/2.0 - 15, frame.size.height - 30, 30, 30);
        [imagePaths removeObjectAtIndex:0];
        [imagePaths removeObjectAtIndex:imagePaths.count - 1];
        self.imageCount = imagePaths.count;
        self.pageControl = [self createPageControl:imagePaths frame:pageFrame];
        [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.pageControl];
        
    }
    return self;
}

+ (instancetype)cjCycleScrollViewFrame:(CGRect)scrollViewF imageViewFrame:(CGRect)imageViewF radius:(CGFloat)radius imagePaths:(NSMutableArray *)imagePaths animationDuration:(NSTimeInterval)animationDuration{
    return [[self alloc] initWithFrame:scrollViewF imageViewFrame:imageViewF radius:radius imagePaths:imagePaths animationDuration:animationDuration];
}

//**********************************************************自定义滚动位置▲**********************************************************/

- (UIScrollView *)createScrollViewWithPath:(NSMutableArray *)imagesPathAry scrollViewFrame:(CGRect)scrollViewF imageViewFrame:(CGRect)imageViewF radius:(CGFloat)radius{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollViewF];
    scrollView.contentSize = CGSizeMake(scrollViewF.size.width * imagesPathAry.count, scrollViewF.size.height);
    for (int i = 0; i<imagesPathAry.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imagesPathAry[i]] placeholderImage:[UIImage imageNamed:@"pageLoading.jpg"] options:SDWebImageRefreshCached];
        
        if (radius != 0) {
            imageView.layer.borderColor = [UIColor clearColor].CGColor;
            imageView.layer.borderWidth = 1.0;
            imageView.layer.cornerRadius = radius;
            imageView.layer.masksToBounds = YES;
        }
        
        imageViewF.origin = CGPointMake(scrollView.frame.size.width * i + self.imageX, 0);
        imageViewF.size = imageViewF.size;
        imageView.frame = imageViewF;
        [scrollView addSubview:imageView];
    }
    scrollView.pagingEnabled = YES;//设置整屏滚动
    scrollView.bounces = NO;//设置边缘无弹跳
    scrollView.showsHorizontalScrollIndicator = NO;//水平滚动条
    scrollView.showsVerticalScrollIndicator = NO;//竖直滚动条
    return scrollView;
}

- (UIPageControl *)createPageControl:(NSArray *)images frame:(CGRect)frame{
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.frame = frame;
    pageControl.numberOfPages = images.count;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.userInteractionEnabled = YES;
    return pageControl;
}

- (void)updateCycleScrollImagesLocation{
    
    self.x +=  iPhoneW;
    
    int count = (int)self.x % (int)iPhoneW;
    
    self.scrollAbnormalCount = self.x/iPhoneW;
    
    if (count == 0) {
        [self.scrollView setContentOffset:CGPointMake(self.x, 0) animated:YES];
    }else{
        [self.scrollView setContentOffset:CGPointMake(iPhoneW * (self.scrollAbnormalCount + 1), 0) animated:YES];
    }
    
    if (self.x == iPhoneW * (self.imageCount + 1)) {
        self.x = iPhoneW;
    }
}

- (void)changePage:(UIPageControl *)pageControl{
    NSLog(@"小按钮点点点");
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)gr{
    if (self.TapActionBlock) {
        self.TapActionBlock(self.currentIndex);
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.currentIndex = scrollView.contentOffset.x / iPhoneW;
    
    NSLog(@"self.currentIndex:%.2f",self.currentIndex);
    
    CGRect frame = CGRectMake(iPhoneW, 0, iPhoneW, scrollView.frame.size.height);
    
    if (scrollView == self.scrollView) {
        
        if ((NSInteger)self.currentIndex == self.currentIndex) {//判断整数
            self.pageControl.currentPage = self.currentIndex - 1;
            if (self.currentIndex - 1 == self.imageCount) {
                frame.origin.x = iPhoneW;
                self.x = frame.origin.x;
                [self.scrollView scrollRectToVisible:frame animated:NO];
            }else if (self.currentIndex == 0){
                frame.origin.x = iPhoneW * self.imageCount;
                self.x = frame.origin.x;
                [self.scrollView scrollRectToVisible:frame animated:NO];
            }else{
                self.x = self.currentIndex * iPhoneW;
//                [[NSNotificationCenter defaultCenter] postNotificationName:CHANGEBACKGROUNDIMAGEVIEW object:[NSNumber numberWithFloat:self.currentIndex]];
            }
        }
    }else if (scrollView == self.scrollView){//预留
        self.pageControl.currentPage = self.currentIndex - 1;
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.timer resumeTimerAfterTimeInterval:self.animationDuration];
}

//**********************************************************加载本地图片数据**********************************************************/
- (instancetype)initWithFrame:(CGRect)frame imageNames:(NSMutableArray *)imageNames animationDuration:(NSTimeInterval)animationDuration{
    if (self = [super initWithFrame:frame]) {
        self.x = iPhoneW;
        if (animationDuration > 0.0) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration) target:self selector:@selector(updateCycleScrollImagesLocation) userInfo:nil repeats:YES];
        }
        
        CGRect scrollFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        self.scrollView = [self createScrollView:imageNames frame:scrollFrame];
        self.scrollView.delegate = self;
        CGRect frame = scrollFrame;
        frame.origin.x = frame.size.width;
        [self.scrollView scrollRectToVisible:frame animated:NO];
        [self addSubview:self.scrollView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [self.scrollView addGestureRecognizer:tapGesture];
        
        CGRect pageFrame = CGRectMake(frame.size.width/2.0 - 15, frame.size.height - 30, 30, 30);
        [imageNames removeObjectAtIndex:0];
        [imageNames removeObjectAtIndex:imageNames.count - 1];
        self.imageCount = imageNames.count;
        self.pageControl = [self createPageControl:imageNames frame:pageFrame];
        [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.pageControl];
        
    }
    return self;
}

- (UIScrollView *)createScrollView:(NSMutableArray *)images frame:(CGRect)frame{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.contentSize = CGSizeMake(frame.size.width * images.count, frame.size.height);
    for (int i = 0; i<images.count; i++) {
        UIImage *image = [UIImage imageNamed:images[i]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        frame.origin = CGPointMake(frame.size.width * i, 0);
        frame.size = scrollView.frame.size;
        imageView.frame = frame;
        [scrollView addSubview:imageView];
    }
    scrollView.pagingEnabled = YES;//设置整屏滚动
    scrollView.bounces = NO;//设置边缘无弹跳
    scrollView.showsHorizontalScrollIndicator = NO;//水平滚动条
    scrollView.showsVerticalScrollIndicator = NO;//竖直滚动条
    return scrollView;
}
//**********************************************************加载本地图片数据**********************************************************/









//**********************************************************自定义视图内容**********************************************************/
+ (instancetype)cjCycleScrollViewFrame:(CGRect)frame customContents:(NSMutableArray *)contentAry animationDuration:(NSTimeInterval)animationDuration{
    return [[self alloc] initWithFrame:frame customContents:contentAry animationDuration:animationDuration];
}

- (instancetype)initWithFrame:(CGRect)frame customContents:(NSMutableArray *)contentAry animationDuration:(NSTimeInterval)animationDuration{
    if (self = [super initWithFrame:frame]) {
        self.x = iPhoneW;
        if (animationDuration > 0.0) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration) target:self selector:@selector(updateCycleScrollImagesLocation) userInfo:nil repeats:YES];
        }
        CGRect scrollFrame = CGRectMake(0, 0, iPhoneW, frame.size.height);
        
        CGFloat customViewX = 25;
        CGRect customMainViewFrame = CGRectMake(customViewX, 0, iPhoneW - 2 * customViewX, frame.size.height);
        
        self.imageX = customMainViewFrame.origin.x;
        
        self.scrollView = [self createCustomScrollViewWithContentAry:contentAry scrollViewFrame:scrollFrame customMainViewFrame:customMainViewFrame];
        
        self.scrollView.delegate = self;
        CGRect frame = scrollFrame;
        frame.origin.x = frame.size.width;
        [self.scrollView scrollRectToVisible:frame animated:NO];
        [self addSubview:self.scrollView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [self.scrollView addGestureRecognizer:tapGesture];
        
        CGRect pageFrame = CGRectMake(frame.size.width/2.0 - 15, frame.size.height - 30, 30, 30);
        [contentAry removeObjectAtIndex:0];
        [contentAry removeObjectAtIndex:contentAry.count - 1];
        self.imageCount = contentAry.count;
        self.pageControl = [self createPageControl:contentAry frame:pageFrame];
        [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.pageControl];
        
    }
    return self;
}

- (UIScrollView *)createCustomScrollViewWithContentAry:(NSMutableArray *)contentAry scrollViewFrame:(CGRect)scrollViewFrame customMainViewFrame:(CGRect)customViewFrame{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    scrollView.contentSize = CGSizeMake(scrollViewFrame.size.width * contentAry.count, scrollViewFrame.size.height);
    for (int i = 0; i<contentAry.count; i++) {
        UIView *bottomMainView = [[UIView alloc] init];
        if (i == 0) {
            bottomMainView.backgroundColor = [UIColor yellowColor];
        }else if (i == 1){
            bottomMainView.backgroundColor = [UIColor purpleColor];
        }else if (i == 2){
            bottomMainView.backgroundColor = [UIColor blueColor];
        }else if (i == 3){
            bottomMainView.backgroundColor = [UIColor greenColor];
        }else if (i == 4){
            bottomMainView.backgroundColor = [UIColor yellowColor];
        }else if (i == 5){
            bottomMainView.backgroundColor = [UIColor purpleColor];
        }
        bottomMainView.layer.borderWidth = 1.0;
        bottomMainView.layer.cornerRadius = 10;
        bottomMainView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        customViewFrame.origin = CGPointMake(scrollView.frame.size.width * i + self.imageX, 0);
        customViewFrame.size = customViewFrame.size;
        bottomMainView.frame = customViewFrame;
        [scrollView addSubview:bottomMainView];
        
        [self addCustomSubViewsWithSuperView:bottomMainView contentAry:contentAry index:i];
        
    }
    scrollView.pagingEnabled = YES;//设置整屏滚动
    scrollView.bounces = NO;//设置边缘无弹跳
    scrollView.showsHorizontalScrollIndicator = NO;//水平滚动条
    scrollView.showsVerticalScrollIndicator = NO;//竖直滚动条
    return scrollView;
}

- (void)addCustomSubViewsWithSuperView:(UIView *)bottomMainView contentAry:(NSMutableArray *)contentAry index:(NSInteger)index{
    /*
    CGFloat iconX = bottomMainView.frame.width/2.0 - 60;
    CGFloat iconY = bottomMainView.frame.height * 0.4 * 0.1;
    CGFloat iconW = bottomMainView.height * 0.4 - 2 * iconY;
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconW, iconW)];
    iconView.layer.borderWidth = 1.0;
    iconView.layer.cornerRadius = iconW/2.0;
    iconView.layer.borderColor = [UIColor blackColor].CGColor;
    iconView.backgroundColor = [UIColor whiteColor];
    [bottomMainView addSubview:iconView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + PADDING, iconView.y, 120, iconView.height)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = contentAry[index];
    [bottomMainView addSubview:titleLabel];
    
    
    CGFloat lineLabelX = 30;
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineLabelX, bottomMainView.height * 0.4, bottomMainView.width - 2 * lineLabelX, 1)];
    lineLabel.backgroundColor = [UIColor whiteColor];
    [bottomMainView addSubview:lineLabel];
    
    UILabel *adTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineLabel.x, CGRectGetMaxY(lineLabel.frame) + PADDING, lineLabel.width, bottomMainView.height * 0.2)];
    adTextLabel.backgroundColor = [UIColor clearColor];
    adTextLabel.text = @"时令相关广告词广告词";
    [bottomMainView addSubview:adTextLabel];
    
    
    UILabel *adTextLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(adTextLabel.x, CGRectGetMaxY(adTextLabel.frame), adTextLabel.width, adTextLabel.height)];
    adTextLabel2.backgroundColor = [UIColor clearColor];
    adTextLabel2.text = @"时令相关广告";
    [bottomMainView addSubview:adTextLabel2];
     */
}
//**********************************************************自定义视图内容**********************************************************/
@end
