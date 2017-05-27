//
//  CycleView.m
//  CycleScrollDemo
//
//  Created by PC开发 on 2017/5/27.
//  Copyright © 2017年 PC开发. All rights reserved.
//

#import "CycleView.h"


@interface CycleView ()<UIScrollViewDelegate>

//滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;
//控制页面
@property (nonatomic, strong) UIPageControl *pageControl;
//装载图片数组
@property (nonatomic, strong) NSMutableArray *imgArray;
//装载视图数组
@property (nonatomic, strong) NSMutableArray *viewArray;
//展示当前图片下表
@property (nonatomic, assign) NSInteger index;
//计时器
@property (nonatomic, strong) NSTimer *timer;

//点击回调block
@property (nonatomic, copy) void(^tapBlock)(NSInteger index);

//计时间隔
@property (nonatomic, assign) NSTimeInterval interval;

@end
@implementation CycleView

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame Interval:(NSTimeInterval)interval{
    self = [super initWithFrame:frame];
    if (self) {
        //首先初始化
        self.imgArray = [NSMutableArray new];
        self.viewArray = [NSMutableArray new];
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];//not frame
        //设置滚动范围
        self.scrollView.contentSize = CGSizeMake(frame.size.width * 3, frame.size.height);
        //以页面形式滚动
        self.scrollView.pagingEnabled = YES;
        //隐藏指示条
        self.scrollView.showsHorizontalScrollIndicator = NO;
        //设置代理
        self.scrollView.delegate = self;
        
        [self addSubview:self.scrollView];
        
        //设置三张视图(左,中,右)
        for (int i = 0; i < 3; i++) {
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width * i, 0, frame.size.width, frame.size.height)];
            //添加到父视图/数组
            [self.scrollView addSubview:imgView];
            [self.viewArray addObject:imgView];
        }
        
    }
    
    return self;
}

//图片名数组setter
- (void)setImgNameArray:(NSMutableArray *)imgNameArray{
    if (_imgNameArray != imgNameArray) {
        _imgNameArray = imgNameArray;
        //设置pageControl
        [self.pageControl removeFromSuperview];
        //初始化
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40)];
        [self addSubview:self.pageControl];
        //属性
        self.pageControl.currentPage = 0;
        self.pageControl.numberOfPages = _imgNameArray.count;
        self.pageControl.pageIndicatorTintColor = [UIColor greenColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        //使点击page时页面不会翻转
        self.pageControl.enabled = NO;
        
        //遍历图片数组
        for (int i = 0; i < _imgNameArray.count; i++) {
            UIImage *img = [UIImage imageNamed:_imgNameArray[i]];
            [self.imgArray addObject:img];
            if (i < 3) {
                
                [self.viewArray[i] setImage:img];
            }
            
        }
        //初始化timer
        if (self.interval <= 0) {
            self.timer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addTimerAction) userInfo:nil repeats:YES];
            
        }else{
            self.timer =  [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(addTimerAction) userInfo:nil repeats:YES];
        }
        
        
        //设置当前偏移量
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
        
        //初始下标
        self.index = 0;
        [self layoutImages];
        
        //点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCycleViewAction:)];
        [self.viewArray[1] addGestureRecognizer:tap];
        
        //打开交互(label和UiimageView没有点击手势)
        [self.viewArray[1] setUserInteractionEnabled:YES];
    }
}




//index的setter方法
- (void)setIndex:(NSInteger)index{
    if (_index != index) {
        _index = index;
        //显示当前下标页
        self.pageControl.currentPage = self.index;
    }
}

- (void)addTimerAction{
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 2, 0) animated:YES];
    
    self.index = (self.index + 1) % self.imgNameArray.count;
    [self layoutImages];
    
    
}

//图片的切换设置布局
- (void)layoutImages{
    for (int i = 0; i < 3; i++) {
        [self.viewArray[i] setImage:self.imgArray[(self.index - 1 + self.imgNameArray.count + i ) % self.imgNameArray.count]];
    }
    
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
    
}

//以下代理方法在拖动时才会调用

#pragma mark - UIScrollViewDelegate

static CGFloat x = 0;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    x = scrollView.contentOffset.x;
    
    //计时在未来开启
    [self.timer setFireDate:[NSDate distantFuture]];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ( x > scrollView.contentOffset.x) {
        [self panToLeft:NO Index:self.index];
    }else if (x < scrollView.contentOffset.x){
        [self panToLeft:YES Index:self.index];
    }
    //滑动两秒之后开启
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2]];
}



//根据偏移量确定Index
- (void)panToLeft:(BOOL)left Index:(NSInteger)index{
    
    if (!left) {
        self.index = (index - 1 + self.imgNameArray.count) % self.imgNameArray.count;
    }else {
        self.index = (index + 1) % self.imgNameArray.count;
    }
    //重新设置图片布局
    [self layoutImages];
    
    //回位操作(拖动时不会走scrollViewDidEndScrollingAnimation方法,需再次回位)
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
}


- (void)tapCycleViewAction:(UIGestureRecognizer *)tap {
    if (self.tapBlock) {
        self.tapBlock(self.index);
    }
}

//添加block
- (void)addTapBlock:(void (^)(NSInteger))block{
    self.tapBlock = block;
}



@end
