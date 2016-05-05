//
//  CJCycleScrollView.h
//  CycleScrollViewDemo
//
//  Created by ChenJie on 15/10/29.
//  Copyright © 2015年 ChenJie. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  pageControl位置
 */
typedef NS_ENUM(NSUInteger, PageControlPostion) {
    /** Center position. */
    PageControlPostionCenter = 0,
    /** top position. */
    PageControlPostionTop,
    /** left position. */
    PageControlPostionLeft,
    /** bottom position. */
    PageControlPostionBottom,
    /** right position. */
    PageControlPostionRight,
    /** null position. */
    PageControlPostionNull,
};

@interface CJCycleScrollView : UIView

/**
 * 当点击的时候，执行的block
 */
@property (nonatomic , copy) void (^TapActionBlock)(NSInteger pageIndex);

/**
 *  小数点位置
 */
@property (assign, nonatomic) PageControlPostion pageControllPostion;

/**
 *  定时器
 */
@property(nonatomic,strong) NSTimer *timer;

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) UIPageControl *pageControl;


+ (instancetype)cjCycleScrollViewFrame:(CGRect)scrollViewF imagePaths:(NSMutableArray *)imagePaths animationDuration:(NSTimeInterval)animationDuration;

+ (instancetype)cjCycleScrollViewFrame:(CGRect)scrollViewF imageViewFrame:(CGRect)imageViewF radius:(CGFloat)radius imagePaths:(NSMutableArray *)imagePaths animationDuration:(NSTimeInterval)animationDuration;

+ (instancetype)cjCycleScrollViewFrame:(CGRect)scrollViewF customContents:(NSMutableArray *)contentAry animationDuration:(NSTimeInterval)animationDuration;

/**
 *  加载本地图片
 *
 *  @param frame             一张滚动图片的frame
 *  @param imageNames        滚动图片的名字数组(可变)
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动
 *
 *  @return nil
 */
- (instancetype)initWithFrame:(CGRect)frame imageNames:(NSMutableArray *)imageNames animationDuration:(NSTimeInterval)animationDuration;


/**
 *  加载网络图片、缓存处理
 *
 *  @param frame             一张滚动图片的frame
 *  @param imagePaths        动态图片地址数组(可变)
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动
 *
 *  @return nil
 */
//- (instancetype)initWithFrame:(CGRect)frame imagePaths:(NSMutableArray *)imagePaths animationDuration:(NSTimeInterval)animationDuration;


/**
 *  加载网络图片、缓存处理(bannar图片自定义frame)
 *
 *  @param frame             scrollViewFrame
 *  @param imageViewF        一张图片的frame
 *  @param radius            圆角大小
 *  @param imagePaths        动态图片地址数组(可变)
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动
 *
 *  @return nil
 */
- (instancetype)initWithFrame:(CGRect)frame imageViewFrame:(CGRect)imageViewF radius:(CGFloat)radius imagePaths:(NSMutableArray *)imagePaths animationDuration:(NSTimeInterval)animationDuration;


/**
 *  自定义bannar图上面的view
 *
 *  @param frame             scrollViewFrame
 *  @param contentAry        需要显示内容的数组(可变)
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动
 *
 *  @return nil
 */
- (instancetype)initWithFrame:(CGRect)frame customContents:(NSMutableArray *)contentAry animationDuration:(NSTimeInterval)animationDuration;

@end
