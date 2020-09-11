//
//  LSSPasterView.m
//  LSSPaster
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 LuShanshan. All rights reserved.
//

#import "LSSStickersView.h"

#define PASTER_SLIDE        150
#define FLEX_SLIDE          15.0
#define BT_SLIDE            30.0
#define BORDER_LINE_WIDTH   1.0
#define SECURITY_LENGTH     15.0


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
//    [self.delegate removePaster:self.pasterID] ;
    [self.delegate removePasterView:self] ;
}

#pragma mark -- Initial
- (instancetype)initWithStageFrame:(CGRect)stageFrame pasterID:(int)pasterID img:(UIImage *)img imgUrl:(NSString *)imgUrl
{
    self = [super init];
    if (self)
    {
        self.pasterID = pasterID ;
        self.imagePaster = img ;
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
    CGFloat sliderContentw = PASTER_SLIDE - FLEX_SLIDE * 2 ;
    CGFloat sliderContenth = (PASTER_SLIDE - FLEX_SLIDE * 2)/(scale > 0?scale:1.0);
    rect.origin = CGPointMake(FLEX_SLIDE, FLEX_SLIDE) ;
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
            self.btSizeCtrl.frame =CGRectMake(self.bounds.size.width-BT_SLIDE,
                                                   self.bounds.size.height-BT_SLIDE,
                                                   BT_SLIDE,
                                                   BT_SLIDE);
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
            CGFloat Height = PASTER_SLIDE/scale ;

            if (finalWidth > PASTER_SLIDE*(1+2))
            {
                finalWidth = PASTER_SLIDE*(1+2) ;
            }
            if (finalWidth < PASTER_SLIDE*(1-2))
            {
                finalWidth = PASTER_SLIDE*(1-2) ;
            }
            if (finalHeight > Height*(1+2))
            {
                finalHeight = Height*(1+2) ;
            }
            if (finalHeight < Height*(1-2))
            {
                finalHeight = Height*(1-2) ;
            }
            
            self.bounds = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     finalWidth,
                                     finalHeight) ;
            
            self.btSizeCtrl.frame = CGRectMake(self.bounds.size.width-BT_SLIDE  ,
                                                    self.bounds.size.height-BT_SLIDE ,
                                                    BT_SLIDE ,
                                                    BT_SLIDE) ;
            
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
- (void)setImagePaster:(UIImage *)imagePaster
{
    _imagePaster = imagePaster ;
    
    self.imgContentView.image = imagePaster ;
}


- (void)setupWithBGFrame:(CGRect)bgFrame
{
    CGRect rect = CGRectZero ;
    rect.size = CGSizeMake(PASTER_SLIDE, PASTER_SLIDE/scale) ;
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
//    [self.delegate makePasterBecomeFirstRespond:self.pasterID] ;
    [self.delegate makePasterBecomeFirstRespondVIew:self] ;

}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGesture
{
    self.isOnFirst = YES ;
//    [self.delegate makePasterBecomeFirstRespond:self.pasterID] ;
    [self.delegate makePasterBecomeFirstRespondVIew:self] ;

    self.imgContentView.transform = CGAffineTransformScale(self.imgContentView.transform,
                                                           pinchGesture.scale,
                                                           pinchGesture.scale) ;
    pinchGesture.scale = 1 ;
}

- (void)handleRotation:(UIRotationGestureRecognizer *)rotateGesture
{
    self.isOnFirst = YES ;
//    [self.delegate makePasterBecomeFirstRespond:self.pasterID] ;
    [self.delegate makePasterBecomeFirstRespondVIew:self] ;
    self.transform = CGAffineTransformRotate(self.transform, rotateGesture.rotation) ;
    rotateGesture.rotation = 0 ;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isOnFirst = YES ;
//    [self.delegate makePasterBecomeFirstRespond:self.pasterID] ;
    [self.delegate makePasterBecomeFirstRespondVIew:self] ;
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
    self.imgContentView.layer.borderWidth = isOnFirst ? BORDER_LINE_WIDTH : 0.0f ;
    
    if (isOnFirst)
    {
        NSLog(@"pasterID : %d is On",self.pasterID) ;
    }
    if (isOnFirst == NO) {//七牛直播更新推流贴纸的父视图overlayView为了刷新推流的画面
       // [[ICPLStreamingSetManager shareStreamingManager].streamingSession performSelector:@selector(refreshOverlayView:) withObject:self afterDelay:0];
    }
}

- (UIImageView *)imgContentView
{
    if (!_imgContentView)
    {
        CGRect rect = CGRectZero ;
        CGFloat sliderContent = PASTER_SLIDE - FLEX_SLIDE * 2 ;
        rect.origin = CGPointMake(FLEX_SLIDE, FLEX_SLIDE) ;
        rect.size = CGSizeMake(sliderContent, sliderContent) ;
        
        _imgContentView = [[UIImageView alloc] initWithFrame:rect] ;
        _imgContentView.backgroundColor = nil ;
        _imgContentView.layer.borderColor = [UIColor whiteColor].CGColor ;
        _imgContentView.layer.borderWidth = BORDER_LINE_WIDTH ;
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
        _btSizeCtrl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - BT_SLIDE  ,
                                                                        self.frame.size.height - BT_SLIDE ,
                                                                        BT_SLIDE ,
                                                                        BT_SLIDE)
                            ] ;
        _btSizeCtrl.userInteractionEnabled = YES;
        _btSizeCtrl.image = [UIImage imageNamed:@"bt_paster_transform"] ;

        UIPanGestureRecognizer *panResizeGesture = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(resizeTranslate:)] ;
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
        btRect.size = CGSizeMake(BT_SLIDE, BT_SLIDE) ;

        _btDelete = [[UIImageView alloc]initWithFrame:btRect] ;
        _btDelete.userInteractionEnabled = YES;
        _btDelete.image = [UIImage imageNamed:@"bt_paster_delete"] ;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(btDeletePressed:)] ;
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

//- (void)btOriginalAction
//{
//    [self.delegate clickOriginalButton] ;
//}

@end
