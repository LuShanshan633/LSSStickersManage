//
//  LSSPasterStageView.m
//  LSSPaster
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 LuShanshan. All rights reserved.
//

#import "LSSStickersStageView.h"
#import "LSSStickersView.h"
#import "UIImage+AddFunction.h"

#define APPFRAME    [UIScreen mainScreen].bounds

@interface LSSStickersStageView () <XTPasterViewDelegate>
{
    CGPoint         startPoint ;
    CGPoint         touchPoint ;
    NSMutableArray  *m_listPaster ;
}

@property (nonatomic,strong) UIButton       *bgButton ;
@property (nonatomic,strong) UIImageView    *imgView ;
@property (nonatomic,strong) LSSStickersView   *pasterCurrent ;
@property (nonatomic)        int            newPasterID ;

@end

@implementation LSSStickersStageView

- (void)setOriginImage:(UIImage *)originImage
{
    _originImage = originImage ;
    
    self.imgView.image = originImage ;
}

- (int)newPasterID
{
    _newPasterID++ ;
    
    return _newPasterID ;
}

- (void)setPasterCurrent:(LSSStickersView *)pasterCurrent
{
    _pasterCurrent = pasterCurrent ;
    
    [self.superPverlayViews bringSubviewToFront:_pasterCurrent] ;
}

- (UIButton *)bgButton
{
    if (!_bgButton) {
        _bgButton = [[UIButton alloc] initWithFrame:self.superPverlayViews.frame] ;
        _bgButton.tintColor = nil ;
        _bgButton.backgroundColor = nil ;
        [_bgButton addTarget:self
                      action:@selector(backgroundClicked:)
            forControlEvents:UIControlEventTouchUpInside] ;
        if (![_bgButton superview]) {
            [self.superPverlayViews addSubview:_bgButton] ;
        }
    }
    
    return _bgButton ;
}

- (UIImageView *)imgView
{
    if (!_imgView)
    {
        CGRect rect = CGRectZero ;
        rect.size.width = self.frame.size.width ;
        rect.size.height = self.frame.size.width ;
        rect.origin.y = ( self.frame.size.height - self.frame.size.width ) / 2.0 ;
        _imgView = [[UIImageView alloc] initWithFrame:rect] ;
        
        _imgView.contentMode = UIViewContentModeScaleAspectFit ;
        
        if (![_imgView superview])
        {
            [self addSubview:_imgView] ;
        }
    }
    
    return _imgView ;
}

#pragma mark - initial
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        m_listPaster = [[NSMutableArray alloc] initWithCapacity:1] ;
//        [self imgView] ;
    }
    
    return self;
}

#pragma mark - public
- (void)addPasterWithImg:(UIImage *)imgP imgUrl:(NSString *)imgUrl
{
    [self clearAllOnFirst] ;
    self.pasterCurrent = [[LSSStickersView alloc] initWithStageFrame:self.frame pasterID:self.newPasterID
                                                          img:imgP imgUrl:imgUrl] ;
    [self addSubview:self.pasterCurrent];
    _pasterCurrent.delegate = self ;
    [m_listPaster addObject:_pasterCurrent] ;
}

- (void)setSuperPverlayViews:(UIView *)superPverlayViews{
    _superPverlayViews = superPverlayViews;
    [self bgButton] ;

}
- (void)addStreamSessionPasterViewImg:(UIImage *)imgP imgUrl:(NSString *)imgUrl
{
    
    [self clearAllOnFirst] ;
    self.pasterCurrent = [[LSSStickersView alloc] initWithStageFrame:self.superPverlayViews.frame pasterID:self.newPasterID
                                                          img:imgP imgUrl:imgUrl] ;
    [self.superPverlayViews addSubview:self];
    //七牛的推流贴图贴图view添加方法
//    [[ICPLStreamingSetManager shareStreamingManager].streamingSession addOverlayView:self.pasterCurrent];

    _pasterCurrent.delegate = self ;
    [m_listPaster addObject:_pasterCurrent] ;
}

-(void)clearOnFirsrResponseWithAllPaster{
    [self clearAllOnFirst];
}
- (LSSStickersModel *)getCurrentImage {
    LSSStickersModel * model = [LSSStickersModel new];
    UIImage *imgTemp = [UIImage getImageFromView:self.pasterCurrent] ;
    model.size = imgTemp.size;
    model.centerPoint = self.pasterCurrent.center;
    model.trans = self.pasterCurrent.transform;
    model.imagePaster = self.pasterCurrent.imagePaster;
    model.imgUrl = self.pasterCurrent.imageUrl;
    return model;
}
-(NSMutableArray*)getPasterViewsModelArray{
    NSMutableArray * arr = [NSMutableArray new];
    [m_listPaster enumerateObjectsUsingBlock:^(LSSStickersView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
        LSSStickersModel * model = [LSSStickersModel new];
        UIImage *imgTemp = [UIImage getImageFromView:pasterV] ;

        model.centerPoint = pasterV.center;
        model.trans = pasterV.transform;
        model.size = imgTemp.size;
        model.imagePaster = pasterV.imagePaster;
        model.imgUrl = pasterV.imageUrl;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject: model];

        [arr addObject:data];
//        [arr addObject:model];
    }];
    return arr;
}
-(NSArray *)getPasterViewsArray{
    [self clearAllOnFirst] ;
    return m_listPaster;
}

- (UIImage *)doneEdit
{
//    NSLog(@"done") ;
    [self clearAllOnFirst] ;
    
//    NSLog(@"self.originImage.size : %@",NSStringFromCGSize(self.originImage.size)) ;
    CGFloat org_width = self.originImage.size.width ;
    CGFloat org_heigh = self.originImage.size.height ;
    CGFloat rateOfScreen = org_width / org_heigh ;
    CGFloat inScreenH = self.superPverlayViews.frame.size.width / rateOfScreen ;
    
    CGRect rect = CGRectZero ;
    rect.size = CGSizeMake(APPFRAME.size.width, inScreenH) ;
    rect.origin = CGPointMake(0, (self.superPverlayViews.frame.size.height - inScreenH) / 2) ;
    
    UIImage *imgTemp = [UIImage getImageFromView:self.pasterCurrent] ;
    
    UIImage *imgCut = [UIImage squareImageFromImage:imgTemp scaledToSize:rect.size.width] ;
    CALayer * presentlayer = self.pasterCurrent.layer.presentationLayer;
    CGFloat rafians = atan2f(presentlayer.affineTransform.b, presentlayer.affineTransform.a);
    CGFloat defree = rafians * (180 / M_PI);
    defree = defree >=0?defree:360+defree;
    NSLog(@"imgTemp.size : %@,defree = %f",NSStringFromCGSize(imgTemp.size),defree) ;

    return imgTemp ;
}


- (void)backgroundClicked:(UIButton *)btBg
{
    NSLog(@"back clicked") ;
    
    [self clearAllOnFirst] ;
    self.pasterCurrent = nil;
}

- (void)clearAllOnFirst
{
    self.pasterCurrent.isOnFirst = NO;

//    [m_listPaster enumerateObjectsUsingBlock:^(LSSPasterView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
//         pasterV.isOnFirst = NO ;
//    }] ;
}

#pragma mark - PasterViewDelegate
- (void)makePasterBecomeFirstRespond:(int)pasterID
{
    [m_listPaster enumerateObjectsUsingBlock:^(LSSStickersView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
        
        pasterV.isOnFirst = NO ;

        if (pasterV.pasterID == pasterID)
        {
            self.pasterCurrent = pasterV ;
            pasterV.isOnFirst = YES ;
        }
        
    }] ;
}
- (void)makePasterBecomeFirstRespondVIew:(LSSStickersView *)pasterView{
    if (self.pasterCurrent == nil) {
        self.pasterCurrent = pasterView ;
    }else{
        if (self.pasterCurrent != pasterView) {
            self.pasterCurrent.isOnFirst = NO;
            self.pasterCurrent = pasterView ;
        }
    }

}
- (void)removePaster:(int)pasterID
{
    [m_listPaster enumerateObjectsUsingBlock:^(LSSStickersView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
        if (pasterV.pasterID == pasterID)
        {
            [m_listPaster removeObjectAtIndex:idx] ;
            *stop = YES ;
        }
    }] ;
}
-(void)removePasterView:(LSSStickersView *)pasterview{
    [m_listPaster removeObject:pasterview];
}
@end

