//
//  LSSPasterModel.h
//  LSSPaster
//
//  Created by 陆闪闪 on 2020/9/10.
//  Copyright © 2020 LuShanshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface LSSStickersModel : NSObject
@property(nonatomic,strong)NSString * imgUrl;
@property(nonatomic,assign)CGSize size;
@property(nonatomic,assign)CGPoint centerPoint;
@property(nonatomic,strong)UIImage *imagePaster;
@property(nonatomic,assign)CGAffineTransform  trans;
@property(nonatomic,assign)CGFloat  transA;
@property(nonatomic,assign)CGFloat  transB;
@property(nonatomic,assign)CGFloat  transC;
@property(nonatomic,assign)CGFloat  transD;
@property(nonatomic,assign)CGFloat  transTx;
@property(nonatomic,assign)CGFloat  transTy;
@property(nonatomic,assign)CGFloat  centerPointX;
@property(nonatomic,assign)CGFloat  centerPointY;
@property(nonatomic,assign)CGFloat  width;
@property(nonatomic,assign)CGFloat  height;
@end

NS_ASSUME_NONNULL_END
