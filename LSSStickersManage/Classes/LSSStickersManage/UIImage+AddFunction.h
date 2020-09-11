//
//  UIImage+AddFunction.h
//
//  Created by 陆闪闪 on 14-6-13.
//  Copyright (c) 2014年 LuShanshan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AddFunction)

+ (UIImage *)squareImageFromImage:(UIImage *)image
                     scaledToSize:(CGFloat)newSize ;

+ (UIImage *)getImageFromView:(UIView *)theView ;

@end
