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
    
    [LSSStickersManage shared].superPverlayViews = self.view;
    [LSSStickersManage shared].delegate = self;

    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 200, 50)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"添加贴图" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
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
