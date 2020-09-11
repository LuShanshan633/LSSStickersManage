//
//  LSSStickersManage.h
//  FBSnapshotTestCase
//
//  Created by 陆闪闪 on 2020/9/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSSStickersManage : NSObject
+(instancetype)shared;
@property (nonatomic,strong) UIView * superPverlayViews ;
- (void)addStreamSessionStickerImage:(UIImage *)stikerImage stikerUrl:(NSString *)stikerUrl;

@end

NS_ASSUME_NONNULL_END
