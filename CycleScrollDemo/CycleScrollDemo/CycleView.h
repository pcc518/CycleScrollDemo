//
//  CycleView.h
//  CycleScrollDemo
//
//  Created by PC开发 on 2017/5/27.
//  Copyright © 2017年 PC开发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleView : UIView


//数组
@property(nonatomic,strong) NSMutableArray *imgNameArray;
//初始化方法
- (instancetype)initWithFrame:(CGRect)frame Interval:(NSTimeInterval)interval;

//添加block回调
- (void)addTapBlock:(void(^)(NSInteger index))block;


@end
