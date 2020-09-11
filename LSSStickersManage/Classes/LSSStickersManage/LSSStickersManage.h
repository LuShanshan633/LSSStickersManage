//
//  LSSStickersManage.h
//  LSSStickersManage
//
//  Created by 陆闪闪 on 2020/9/11.
//

#import <Foundation/Foundation.h>
#import "LSSStickersView.h"
#import "LSSStickersModel.h"
#import "UIImage+AddFunction.h"
NS_ASSUME_NONNULL_BEGIN
@protocol LSSStickersManageDelegate <NSObject>
@optional
- (void)refreshStickerView:(LSSStickersView *)stickersView;
@end

@interface LSSStickersManage : NSObject<LSSStickersViewDelegate>{
    CGPoint         startPoint ;
    CGPoint         touchPoint ;
    NSMutableArray  *stackersViewArray ;
}
+(instancetype)shared;
@property (nonatomic,strong) LSSStickersView   *currentStickersView ;
@property (nonatomic) int newStickersID ;
@property (nonatomic,weak)    id <LSSStickersManageDelegate> delegate ;
@property(nonatomic,strong)UIButton * backButton;

///父视图
@property (nonatomic,strong) UIView * superPverlayViews ;

/// 添加贴图
/// @param stikerImage 图片不可为空
/// @param stikerUrl 图片地址
- (void)addStreamSessionStickerImage:(UIImage *)stikerImage stikerUrl:(NSString *)stikerUrl;
///获取当前编辑的贴图model
- (LSSStickersModel *)getCurrentStickersModel;
/// 获取当前页面的所有贴图model进行保存，已转NSData数组
- (NSMutableArray*)getStickersModelArray;
/// 获取当前页面的所有贴图View
- (NSArray *)getStickersViewsArray;
///清除所有贴图的编辑状态
- (void)clearOnFirsrResponseWithAllStickers;
/// 移除所有贴图
- (void)removeAllStickersView;

@end

NS_ASSUME_NONNULL_END
