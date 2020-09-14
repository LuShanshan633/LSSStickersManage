//
//  LSSStickersManage.m
//  LSSStickersManage
//
//  Created by 陆闪闪 on 2020/9/11.
//

#import "LSSStickersManage.h"

@implementation LSSStickersManage
+ (instancetype)shared{
     static LSSStickersManage *once = nil;
     if (!once) {
         once = [[LSSStickersManage alloc] init];
     }
    return once;
}
//添加背景点击事件
-(void)addBackClickBtn{
    [self backButton];
}
- (void)setSuperPverlayViews:(UIView *)superPverlayViews{
    _superPverlayViews = superPverlayViews;
    stackersViewArray = [NSMutableArray new];
    [self addBackClickBtn];
}
//添加贴图View
- (void)addStreamSessionStickerImage:(UIImage *)stikerImage stikerUrl:(NSString *)stikerUrl{
        [self clearAllOnFirst] ;
    self.currentStickersView = [[LSSStickersView alloc] initWithStageFrame:self.superPverlayViews.frame stickerID:self.newStickersID img:stikerImage imgUrl:stikerUrl] ;
    [self.superPverlayViews addSubview:self.currentStickersView];
        //七牛的推流贴图贴图view添加方法
    //    [[ICPLStreamingSetManager shareStreamingManager].streamingSession addOverlayView:self.currentStickersView];
    self.currentStickersView.delegate = self ;
    [stackersViewArray addObject:self.currentStickersView] ;
}
#pragma mark - Action
- (void)backgroundClicked:(UIButton *)backBtn{
    [self clearAllOnFirst] ;
    self.currentStickersView = nil;
}
- (void)clearAllOnFirst
{
    self.currentStickersView.isOnFirst = NO;
}

#pragma mark - delegate
- (void)makeStickersBecomeFirstRespondVIew:(LSSStickersView *)stickersView{
    if (self.currentStickersView == nil) {
        self.currentStickersView = stickersView ;
    }else{
        if (self.currentStickersView != stickersView) {
            self.currentStickersView.isOnFirst = NO;
            self.currentStickersView = stickersView ;
        }
    }

}
-(void)removeStickersView:(LSSStickersView *)stickersView{
    [stackersViewArray removeObject:stickersView];
}
- (void)endEditStickerView:(LSSStickersView *)stickersView{
    [self.delegate refreshStickerView:stickersView];
}
#pragma mark - getDataSource
- (LSSStickersModel *)getCurrentStickersModel{
    LSSStickersModel * model = [LSSStickersModel new];
    UIImage *imgTemp = [UIImage getImageFromView:self.currentStickersView] ;
    model.size = imgTemp.size;
    model.centerPoint = self.currentStickersView.center;
    model.transform = self.currentStickersView.transform;
    model.imageSticker = self.currentStickersView.imageSticker;
    model.imgUrl = self.currentStickersView.imageUrl;
    return model;

}
- (NSMutableArray *)getStickersModelArray{
    NSMutableArray * arr = [NSMutableArray new];
    [stackersViewArray enumerateObjectsUsingBlock:^(LSSStickersView *StickersView, NSUInteger idx, BOOL * _Nonnull stop) {
        LSSStickersModel * model = [LSSStickersModel new];
        UIImage *imgTemp = [UIImage getImageFromView:StickersView] ;
        model.centerPoint = StickersView.center;
        model.transform = StickersView.transform;
        model.size = imgTemp.size;
        model.imgUrl = StickersView.imageUrl;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject: model];
        [arr addObject:data];
    }];
    return arr;
}
- (NSArray *)getStickersViewsArray{
    [self clearAllOnFirst];
    return [stackersViewArray copy];
}


- (void)clearOnFirstResponseWithAllStickers{
    [self clearAllOnFirst] ;
    self.currentStickersView = nil;
}

#pragma mark - lazy
- (int)newStickersID{
    _newStickersID++ ;
    
    return _newStickersID ;
}
- (void)setCurrentStickersView:(LSSStickersView *)stickersCurrent
{
    _currentStickersView = stickersCurrent ;
    [self.superPverlayViews bringSubviewToFront:_currentStickersView] ;
}
- (void)removeAllStickersView{
    
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:self.superPverlayViews.frame] ;
        _backButton.tintColor = nil ;
        _backButton.backgroundColor = nil ;
        [_backButton addTarget:self
                      action:@selector(backgroundClicked:)
            forControlEvents:UIControlEventTouchUpInside] ;
        if (![_backButton superview]) {
            [self.superPverlayViews addSubview:_backButton] ;
        }
    }
    return _backButton ;
}


@end
