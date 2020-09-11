//
//  LSSStickersView.h
//  LSSStickersManage
//
//  Created by 陆闪闪 on 2020/9/11.
//

#import <UIKit/UIKit.h>

@class LSSStickersView ;

@protocol LSSStickersViewDelegate <NSObject>
@optional
- (void)makeStickersBecomeFirstRespondVIew:(LSSStickersView *)stickersView ;
- (void)removeStickersView:(LSSStickersView*)stickersView ;
- (void)endEditStickerView:(LSSStickersView *)stickersView;
@end

@interface LSSStickersView : UIView

@property (nonatomic,strong)    UIImage *imageSticker ;
@property (nonatomic,assign)   CGPoint prevPoint;
@property (nonatomic,strong)    NSString *imageUrl ;

@property (nonatomic)           int     stickersID ;
@property (nonatomic)           BOOL    isOnFirst ;
@property (nonatomic,weak)    id <LSSStickersViewDelegate> delegate ;
- (instancetype)initWithStageFrame:(CGRect)stageFrame
                      stickerID:(int)stickersID
                           img:(UIImage *)img imgUrl:(NSString *)imgUrl;
- (void)remove ;

@end
