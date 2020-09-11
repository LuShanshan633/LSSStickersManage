//
//  LSSStickersView.m
//  LSSStickersManage
//
//  Created by 陆闪闪 on 2020/9/11.
//

#import "LSSStickersView.h"
//初始图片默认宽度
#define STICKERS_INIT_WIDTH 150
//安全距离
#define FLEX_WIDTN 15.0
//删除、放大图片宽高
#define BUTTON_WIDTH 30.0
//图片边框宽度
#define IMG_BORDER_LINE_WIDTH 1.0
//安全距离
#define SECURITY_LENGTH 15.0
//
#define MAX_SCALE_PAN 2


@interface LSSStickersView ()
{
    CGFloat minWidth;
    CGFloat minHeight;
    CGFloat deltaAngle;
    CGPoint touchStart;
    CGRect  bgRect ;
    CGFloat scale;

}
@property (nonatomic,strong) UIImageView    *imgContentView ;
@property (nonatomic,strong) UIImageView    *btDelete ;
@property (nonatomic,strong) UIImageView    *btSizeCtrl ;

@end

@implementation LSSStickersView

- (void)remove
{
    [self removeFromSuperview] ;
    [self.delegate removeStickersView:self] ;
}

#pragma mark -- Initial
- (instancetype)initWithStageFrame:(CGRect)stageFrame stickerID:(int)stickerID img:(UIImage *)img imgUrl:(NSString *)imgUrl
{
    self = [super init];
    if (self)
    {
        self.stickersID = stickerID ;
        self.imageSticker = img ;
        self.imageUrl = imgUrl;
        scale = img.size.width/img.size.height;
        bgRect = stageFrame ;
        [self setupWithBGFrame:bgRect] ;
        [self imgContentView] ;
        [self btDelete] ;
        [self btSizeCtrl] ;

//        [bgView addSubview:self] ;
        self.isOnFirst = YES ;
    }
    return self;
}


- (void)setFrame:(CGRect)newFrame
{
    [super setFrame:newFrame];
    
    CGRect rect = CGRectZero ;
    CGFloat scale = newFrame.size.width/newFrame.size.height ;
    CGFloat sliderContentw = STICKERS_INIT_WIDTH - FLEX_WIDTN * 2 ;
    CGFloat sliderContenth = (STICKERS_INIT_WIDTH - FLEX_WIDTN * 2)/(scale > 0?scale:1.0);
    rect.origin = CGPointMake(FLEX_WIDTN, FLEX_WIDTN) ;
    rect.size = CGSizeMake(sliderContentw, sliderContenth) ;
    self.imgContentView.frame = rect ;
    
    self.imgContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}


- (void)resizeTranslate:(UIPanGestureRecognizer *)recognizer
{
    if (self.isOnFirst == NO) {
        return;
    }
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        self.prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        // preventing from the picture being shrinked too far by resizing
        if (self.bounds.size.width < minWidth || self.bounds.size.height < minHeight)
        {
            self.bounds = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     minWidth + 1 ,
                                     minHeight + 1);
            self.btSizeCtrl.frame =CGRectMake(self.bounds.size.width-BUTTON_WIDTH,
                                                   self.bounds.size.height-BUTTON_WIDTH,
                                                   BUTTON_WIDTH,
                                                   BUTTON_WIDTH);
            self.prevPoint = [recognizer locationInView:self];
        }
        // Resizing
        else
        {
            CGPoint point = [recognizer locationInView:self];
            float wChange = 0.0, hChange = 0.0;
            
            wChange = (point.x - self.prevPoint.x);
            float wRatioChange = (wChange/(float)self.bounds.size.width);
            
            hChange = wRatioChange * self.bounds.size.height;
            
            if (ABS(wChange) > 50.0f || ABS(hChange) > 50.0f)
            {
                self.prevPoint = [recognizer locationOfTouch:0 inView:self];
                return;
            }
            
            CGFloat finalWidth  = self.bounds.size.width + (wChange) ;
            CGFloat finalHeight = self.bounds.size.height + (hChange) ;
            CGFloat Height = STICKERS_INIT_WIDTH/scale ;

            if (finalWidth > STICKERS_INIT_WIDTH*(1+MAX_SCALE_PAN))
            {
                finalWidth = STICKERS_INIT_WIDTH*(1+MAX_SCALE_PAN) ;
            }
            if (finalWidth < STICKERS_INIT_WIDTH*(1-MAX_SCALE_PAN))
            {
                finalWidth = STICKERS_INIT_WIDTH*(1-MAX_SCALE_PAN) ;
            }
            if (finalHeight > Height*(1+MAX_SCALE_PAN))
            {
                finalHeight = Height*(1+MAX_SCALE_PAN) ;
            }
            if (finalHeight < Height*(1-MAX_SCALE_PAN))
            {
                finalHeight = Height*(1-MAX_SCALE_PAN) ;
            }
            
            self.bounds = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     finalWidth,
                                     finalHeight) ;
            
            self.btSizeCtrl.frame = CGRectMake(self.bounds.size.width-BUTTON_WIDTH  ,
                                                    self.bounds.size.height-BUTTON_WIDTH ,
                                                    BUTTON_WIDTH ,
                                                    BUTTON_WIDTH) ;
            
            self.prevPoint = [recognizer locationOfTouch:0
                                                  inView:self] ;
        }
        
        /* Rotation */
        float ang = atan2([recognizer locationInView:self.superview].y - self.center.y,
                          [recognizer locationInView:self.superview].x - self.center.x) ;
        
        float angleDiff = deltaAngle - ang ;

        self.transform = CGAffineTransformMakeRotation(-angleDiff) ;
        
        [self setNeedsDisplay] ;
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        self.prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }

}
- (void)setImageSticker:(UIImage *)imageSticker
{
    _imageSticker = imageSticker ;
    
    self.imgContentView.image = imageSticker ;
}


- (void)setupWithBGFrame:(CGRect)bgFrame
{
    CGRect rect = CGRectZero ;
    rect.size = CGSizeMake(STICKERS_INIT_WIDTH, STICKERS_INIT_WIDTH/scale) ;
    self.frame = rect ;
    self.center = CGPointMake(bgFrame.size.width / 2.0, bgFrame.size.height / 2.0) ;
    self.backgroundColor = nil ;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)] ;
    [self addGestureRecognizer:tapGesture] ;

//    UIPinchGestureRecognizer *pincheGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)] ;
//    [self addGestureRecognizer:pincheGesture] ;
    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)] ;
    [self addGestureRecognizer:rotateGesture] ;
    
    self.userInteractionEnabled = YES ;
    
    minWidth   = self.bounds.size.width * 0.5;
    minHeight  = self.bounds.size.height * 0.5;
  
    deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                       self.frame.origin.x+self.frame.size.width - self.center.x) ;

}
- (void)tap:(UITapGestureRecognizer *)tapGesture
{
    self.isOnFirst = YES ;
    [self.delegate makeStickersBecomeFirstRespondVIew:self] ;

}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGesture
{
    self.isOnFirst = YES ;
    [self.delegate makeStickersBecomeFirstRespondVIew:self] ;

    self.imgContentView.transform = CGAffineTransformScale(self.imgContentView.transform,
                                                           pinchGesture.scale,
                                                           pinchGesture.scale) ;
    pinchGesture.scale = 1 ;
}

- (void)handleRotation:(UIRotationGestureRecognizer *)rotateGesture
{
    self.isOnFirst = YES ;
    [self.delegate makeStickersBecomeFirstRespondVIew:self] ;
    self.transform = CGAffineTransformRotate(self.transform, rotateGesture.rotation) ;
    rotateGesture.rotation = 0 ;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isOnFirst = YES ;
    [self.delegate makeStickersBecomeFirstRespondVIew:self] ;
    UITouch *touch = [touches allObjects][0] ;
    touchStart = [touch locationInView:self.superview] ;
}

- (void)translateUsingTouchLocation:(CGPoint)touchPoint
{
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - touchStart.x,
                                    self.center.y + touchPoint.y - touchStart.y) ;
    
    // Ensure the translation won't cause the view to move offscreen. BEGIN
    CGFloat midPointX = CGRectGetMidX(self.bounds) ;
    if (newCenter.x > self.superview.bounds.size.width - midPointX + SECURITY_LENGTH)
    {
        newCenter.x = self.superview.bounds.size.width - midPointX + SECURITY_LENGTH;
    }
    if (newCenter.x < midPointX - SECURITY_LENGTH)
    {
        newCenter.x = midPointX - SECURITY_LENGTH;
    }
    
    CGFloat midPointY = CGRectGetMidY(self.bounds);
    if (newCenter.y > self.superview.bounds.size.height - midPointY + SECURITY_LENGTH)
    {
        newCenter.y = self.superview.bounds.size.height - midPointY + SECURITY_LENGTH;
    }
    if (newCenter.y < midPointY - SECURITY_LENGTH)
    {
        newCenter.y = midPointY - SECURITY_LENGTH;
    }
    // Ensure the translation won't cause the view to move offscreen. END
    self.center = newCenter;

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isOnFirst) {
        CGPoint touchLocation = [[touches allObjects][0] locationInView:self];
        if (CGRectContainsPoint(self.btSizeCtrl.frame, touchLocation)) {
            return;
        }
        
        CGPoint touch = [[touches allObjects][0] locationInView:self.superview];

        [self translateUsingTouchLocation:touch] ;
        
        touchStart = touch;
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        
}

#pragma mark -- Properties
- (void)setIsOnFirst:(BOOL)isOnFirst
{
    _isOnFirst = isOnFirst ;
    
    self.btDelete.hidden = !isOnFirst ;
    self.btSizeCtrl.hidden = !isOnFirst ;
    self.imgContentView.layer.borderWidth = isOnFirst ? IMG_BORDER_LINE_WIDTH : 0.0f ;
    
    if (isOnFirst)
    {
        NSLog(@"stickersID : %d is On",self.stickersID) ;
    }
    if (isOnFirst == NO) {
        //七牛直播更新推流贴纸的父视图overlayView为了刷新推流的画面
       // [[ICPLStreamingSetManager shareStreamingManager].streamingSession performSelector:@selector(refreshOverlayView:) withObject:self afterDelay:0];
        [self.delegate endEditStickerView:self];
    }
}

- (UIImageView *)imgContentView
{
    if (!_imgContentView)
    {
        CGRect rect = CGRectZero ;
        CGFloat sliderContent = STICKERS_INIT_WIDTH - FLEX_WIDTN * 2 ;
        rect.origin = CGPointMake(FLEX_WIDTN, FLEX_WIDTN) ;
        rect.size = CGSizeMake(sliderContent, sliderContent) ;
        
        _imgContentView = [[UIImageView alloc] initWithFrame:rect] ;
        _imgContentView.backgroundColor = nil ;
        _imgContentView.layer.borderColor = [UIColor whiteColor].CGColor ;
        _imgContentView.layer.borderWidth = IMG_BORDER_LINE_WIDTH ;
        _imgContentView.contentMode = UIViewContentModeScaleAspectFit ;
        
        if (![_imgContentView superview])
        {
            [self addSubview:_imgContentView] ;
        }
    }
    
    return _imgContentView ;
}

- (UIImageView *)btSizeCtrl
{
    if (!_btSizeCtrl)
    {
        _btSizeCtrl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - BUTTON_WIDTH, self.frame.size.height - BUTTON_WIDTH , BUTTON_WIDTH , BUTTON_WIDTH) ] ;
        _btSizeCtrl.userInteractionEnabled = YES;
        _btSizeCtrl.image = [UIImage imageNamed:@"bt_stickers_transform"] ;
        UIPanGestureRecognizer *panResizeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resizeTranslate:)] ;
        [_btSizeCtrl addGestureRecognizer:panResizeGesture] ;
        if (![_btSizeCtrl superview]) {
            [self addSubview:_btSizeCtrl] ;
        }
    }
    
    return _btSizeCtrl ;
}

- (UIImageView *)btDelete
{
    if (!_btDelete)
    {
        CGRect btRect = CGRectZero ;
        btRect.size = CGSizeMake(BUTTON_WIDTH, BUTTON_WIDTH) ;
        _btDelete = [[UIImageView alloc]initWithFrame:btRect] ;
        _btDelete.userInteractionEnabled = YES;
        _btDelete.image = [UIImage imageNamed:@"bt_stickers_delete"] ;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btDeletePressed:)] ;
        [_btDelete addGestureRecognizer:tap] ;
        
        if (![_btDelete superview]) {
            [self addSubview:_btDelete] ;
        }
    }
    
    return _btDelete ;
}

- (void)btDeletePressed:(id)btDel
{
    [self remove] ;
}

@end
