//
//  LSSStickersModel.h
//  LSSStickersManage
//
//  Created by 陆闪闪 on 2020/9/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
/**
用于保存贴图数据，直播意外崩溃时重新推流需要重新设置贴图的大小，旋转角度，位置等
*/
@interface LSSStickersModel : NSObject
//图片
@property(nonatomic,strong)UIImage *imageSticker;
//图片url
@property(nonatomic,strong)NSString * imgUrl;
//大小
@property(nonatomic,assign)CGSize size;
//从内存中拿贴图的尺寸，不可使用size
@property(nonatomic,assign)CGFloat  width;
@property(nonatomic,assign)CGFloat  height;

//中心点
@property(nonatomic,assign)CGPoint centerPoint;
//从内存中拿贴图的中心位置，不可使用centerPoint
@property(nonatomic,assign)CGFloat  centerPointX;
@property(nonatomic,assign)CGFloat  centerPointY;
//旋转角度
@property(nonatomic,assign)CGAffineTransform  transform;
//从内存中拿贴图的旋转，不可使用transform
@property(nonatomic,assign)CGFloat  transA;
@property(nonatomic,assign)CGFloat  transB;
@property(nonatomic,assign)CGFloat  transC;
@property(nonatomic,assign)CGFloat  transD;
@property(nonatomic,assign)CGFloat  transTx;
@property(nonatomic,assign)CGFloat  transTy;
@end

NS_ASSUME_NONNULL_END
