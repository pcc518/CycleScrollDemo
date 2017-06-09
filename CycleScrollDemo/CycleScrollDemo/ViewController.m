//
//  ViewController.m
//  CycleScrollDemo
//
//  Created by PC开发 on 2017/5/27.
//  Copyright © 2017年 PC开发. All rights reserved.
//

#import "ViewController.h"
#import "CycleView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.f];
    
    CycleView *cycleView = [[CycleView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 400) Interval:5];
    cycleView.imgNameArray = [@[@"0.gif",@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg"]mutableCopy];

    
    [self.view addSubview:cycleView];
    
    [cycleView addTapBlock:^(NSInteger index) {
        NSLog(@"当前点击第%ld页",(long)index);
    }];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
