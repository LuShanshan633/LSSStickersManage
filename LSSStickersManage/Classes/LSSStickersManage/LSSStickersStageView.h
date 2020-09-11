//
//  LSSPasterStageView.h
//  LSSPaster
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 LuShanshan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSSStickersModel.h"
#import "LSSStickersView.h"
@interface LSSStickersStageView : UIView
@property (nonatomic,strong) UIView   *superPverlayViews ;

@property (nonatomic,strong) UIImage *originImage ;
- (void)addStreamSessionPasterViewImg:(UIImage *)imgP imgUrl:(NSString *)imgUrl;
- (instancetype)initWithFrame:(CGRect)frame ;
- (void)addPasterWithImg:(UIImage *)imgP imgUrl:(NSString *)imgUrl;
- (UIImage *)doneEdit ;
- (LSSStickersModel *)getCurrentImage ;
-(NSMutableArray*)getPasterViewsModelArray;
-(NSArray *)getPasterViewsArray;
- (void)clearOnFirsrResponseWithAllPaster ;

@end
