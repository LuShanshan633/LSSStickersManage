//
//  LSSViewController.m
//  LSSStickersManage
//
//  Created by LuShanshan633 on 09/11/2020.
//  Copyright (c) 2020 LuShanshan633. All rights reserved.
//

#import "LSSViewController.h"
#import <LSSStickersManage/LSSStickersManage.h>
@interface LSSViewController ()<LSSStickersManageDelegate>

@end

@implementation LSSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView * stickerManageView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:stickerManageView];
    stickerManageView.backgroundColor = [UIColor whiteColor];
    //必须设置父视图View
    [LSSStickersManage shared].superPverlayViews = stickerManageView;
    [LSSStickersManage shared].delegate = self;

    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 200, 50)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"添加贴图" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

//    //所有贴纸view
//    NSArray * viewArr = [[LSSStickersManage shared] getStickersViewsArray];
//    //所有贴纸的元素旋转大小等model数组
//    NSArray * modelArr = [[LSSStickersManage shared] getStickersModelArray];

	// Do any additional setup after loading the view, typically from a nib.
}

-(void)addAction{
    [[LSSStickersManage shared] addStreamSessionStickerImage:[UIImage imageNamed:@"IMG_2976"] stikerUrl:@""];
}

#pragma mark - delegate
- (void)refreshStickerView:(LSSStickersView *)stickersView{
    //更新推流画面
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
