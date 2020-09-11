//
//  LSSPasterView.h
//  LSSPaster
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 LuShanshan. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LSSPasterStageView.h"

@class LSSStickersView ;

@protocol XTPasterViewDelegate <NSObject>
- (void)makePasterBecomeFirstRespond:(int)pasterID ;
- (void)makePasterBecomeFirstRespondVIew:(LSSStickersView *)pasterView ;

- (void)removePaster:(int)pasterID ;
- (void)removePasterView:(LSSStickersView*)pasterview ;

@end

@interface LSSStickersView : UIView

@property (nonatomic,strong)    UIImage *imagePaster ;
@property (nonatomic,assign)   CGPoint prevPoint;
@property (nonatomic,strong)    NSString *imageUrl ;

@property (nonatomic)           int     pasterID ;
@property (nonatomic)           BOOL    isOnFirst ;
@property (nonatomic,weak)    id <XTPasterViewDelegate> delegate ;
- (instancetype)initWithStageFrame:(CGRect)stageFrame
                      pasterID:(int)pasterID
                           img:(UIImage *)img imgUrl:(NSString *)imgUrl;
- (void)remove ;

@end
