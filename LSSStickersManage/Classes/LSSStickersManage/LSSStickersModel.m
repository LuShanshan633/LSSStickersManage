
//
//  LSSStickersModel.m
//  LSSStickersManage
//
//  Created by 陆闪闪 on 2020/9/11.
//

#import "LSSStickersModel.h"

@implementation LSSStickersModel
- (void)setSize:(CGSize)size{
    _size = size;
    self.width = size.width;
    self.height = size.height;
}

- (void)setTransform:(CGAffineTransform)transform{
    _transform = transform;
    self.transA = transform.a;
    self.transB = transform.b;
    self.transC = transform.c;
    self.transD = transform.d;
    self.transTx = transform.tx;
    self.transTy = transform.ty;
}
- (void)setCenterPoint:(CGPoint)centerPoint{
    _centerPoint = centerPoint;
    self.centerPointX = centerPoint.x;
    self.centerPointY = centerPoint.y;
}

#pragma mark - 编解码，用于存储nsuserdefault
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self. imgUrl forKey:@"imgUrl"];
    [aCoder encodeObject:@(self.transA) forKey:@"transA"];
    [aCoder encodeObject:@(self.transB) forKey:@"transB"];
    [aCoder encodeObject:@(self.transC) forKey:@"transC"];
    [aCoder encodeObject:@(self.transD) forKey:@"transD"];
    [aCoder encodeObject:@(self.transTx) forKey:@"transTx"];
    [aCoder encodeObject:@(self.transTy) forKey:@"transTy"];
    [aCoder encodeObject:@(self.centerPointX) forKey:@"centerPointX"];
    [aCoder encodeObject:@(self.centerPointY) forKey:@"centerPointY"];
    [aCoder encodeObject:@(self.width) forKey:@"width"];
    [aCoder encodeObject:@(self.height) forKey:@"height"];

}
 
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
 
        self.imgUrl = [aDecoder decodeObjectForKey:@"imgUrl"];
        self.transA = [[aDecoder decodeObjectForKey:@"transA"] floatValue];
        self.transB = [[aDecoder decodeObjectForKey:@"transB"] floatValue];
        self.transC = [[aDecoder decodeObjectForKey:@"transC"] floatValue];
        self.transD = [[aDecoder decodeObjectForKey:@"transD"] floatValue];
        self.transTx = [[aDecoder decodeObjectForKey:@"transTx"] floatValue];
        self.transTy = [[aDecoder decodeObjectForKey:@"transTy"] floatValue];
        self.centerPointX = [[aDecoder decodeObjectForKey:@"centerPointX"] floatValue];
        self.centerPointY = [[aDecoder decodeObjectForKey:@"centerPointY"] floatValue];
        self.width = [[aDecoder decodeObjectForKey:@"width"] floatValue];
        self.height = [[aDecoder decodeObjectForKey:@"height"] floatValue];
    }
    return self;
}
@end
