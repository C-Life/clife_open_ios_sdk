//
//  HETCircleLoader.m
//  HETCircleLoader
//
//  Created by hcc on 16/8/30.
//  Copyright © 2016年 HET. All rights reserved.
//
#import "HETCircleLoader.h"

#define HET_SPINNER_COLOR       [UIColor whiteColor]
#define HET_SPINNER_LINE_WIDTH  fmaxf(self.frame.size.width * 0.01, 1.f)

@interface HETCircleLoader ()

@property (nonatomic, assign) CGFloat       lineWidth;
@property (nonatomic, assign) UIColor       *lineTintColor;
@property (nonatomic, strong) UILabel       *progressLable;

@property (nonatomic, strong) UIButton      *closeBtn;
@property (nonatomic, strong) UIView        *view;
@property (nonatomic, strong) CAShapeLayer  *backgroundLayer;
@property (nonatomic, assign) BOOL          isSpinning;
@property (nonatomic, strong) UIView        *superView;
@property (nonatomic, strong) UIView        *backgroundView;;
@end

@implementation HETCircleLoader



- (void )showInView:(UIView *)view
{
    self.superView       = view;
    float height         = [[UIScreen mainScreen] bounds].size.height;
    float width          = [[UIScreen mainScreen] bounds].size.width;
    self.frame = CGRectMake(0, 0, width, height);
    [self setup];
    [self start];
    
    [view addSubview:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(start)    name:UIApplicationDidBecomeActiveNotification object:nil];
}

+ (HETCircleLoader *)showInView:(UIView *)view
{
    
    HETCircleLoader *hud = [[HETCircleLoader alloc] init];
    hud.superView        = view;
    float height         = [[UIScreen mainScreen] bounds].size.height;
    float width          = [[UIScreen mainScreen] bounds].size.width;
    hud.frame = CGRectMake(0, 0, width, height);
    [hud setup];
    [hud start];
    [view addSubview:hud];
    
    return hud;
}
+ (BOOL)hideInView:(UIView *)view
{
    HETCircleLoader *hud = [HETCircleLoader HUDForView:view];
    [hud stop];
    if (hud)
    {
        [hud removeFromSuperview];
        return YES;
    }
    return NO;
}

- (BOOL)hideInView:(UIView *)view
{
    HETCircleLoader *hud = [HETCircleLoader HUDForView:view];
    [hud stop];
    if (hud)
    {
        [hud removeFromSuperview];
        return YES;
    }
    return NO;
}
+ (HETCircleLoader *)HUDForView: (UIView *)view
{
    HETCircleLoader *hud = nil;
    NSArray *subViewsArray = view.subviews;
    Class hudClass = [HETCircleLoader class];
    for (UIView *aView in subViewsArray)
    {
        if ([aView isKindOfClass:hudClass])
        {
            hud = (HETCircleLoader *)aView;
        }
    }
    return hud;
}

- (void)setup
{
    float height         = [[UIScreen mainScreen] bounds].size.height;
    float width          = [[UIScreen mainScreen] bounds].size.width;
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height-64)];
    
    [self addSubview:self.backgroundView];
    
    
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 180, 113)];
    self.view.backgroundColor       = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.view.layer.cornerRadius    = 6;
    self.view.clipsToBounds         = YES;
    self.view.layer.masksToBounds   = YES;
    self.view.center = CGPointMake(width/2.0, (height - 64)/2.0);
    [self.backgroundView addSubview:self.view];

    self.progressLable          = [[UILabel alloc] initWithFrame:CGRectMake(0, 85, self.view.bounds.size.width, 20)];
    self.progressLable.font              = [UIFont boldSystemFontOfSize:14.0f];
    self.progressLable.textColor         = HET_SPINNER_COLOR;
    self.progressLable.textAlignment     = NSTextAlignmentCenter;
    [self.view addSubview:self.progressLable];

    self.closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(154, 5, 22, 22)];
    [self.closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_closeBtn"] forState:UIControlStateNormal];
    [self.view addSubview:self.closeBtn];
    

    
    _lineWidth = HET_SPINNER_LINE_WIDTH;
    self.backgroundLayer            = [CAShapeLayer layer];
    _backgroundLayer.strokeColor    = HET_SPINNER_COLOR.CGColor;
    _backgroundLayer.fillColor      = [UIColor clearColor].CGColor;
    _backgroundLayer.lineCap        = kCALineCapRound;
    _backgroundLayer.lineWidth      = _lineWidth;
    [self.view.layer addSublayer:_backgroundLayer];
}

- (void)drawRect:(CGRect)rect
{
    _backgroundLayer.frame = self.view.bounds;
}

- (void)drawBackgroundCircle:(BOOL) partial
{
    CGFloat startAngle  = - ((float)M_PI / 2); 
    CGFloat endAngle    = (2 * (float)M_PI) + startAngle;
    CGPoint center      = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    CGFloat radius      = 24;

    UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
    processBackgroundPath.lineWidth     = _lineWidth;
    if (partial)
    {
        endAngle = (1.6f * (float)M_PI) + startAngle;
    }
    [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    _backgroundLayer.path = processBackgroundPath.CGPath;
}

- (void)start
{
    self.isSpinning = YES;
    [self drawBackgroundCircle:YES];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue           = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration          = 1;
    rotationAnimation.cumulative        = YES;
    rotationAnimation.repeatCount       = HUGE_VALF;
    [_backgroundLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stop
{
    [self drawBackgroundCircle:NO];
    [_backgroundLayer removeAllAnimations];
    self.isSpinning = NO;
}
- (void)closeBtnClick
{
    !self.cancelBind?:self.cancelBind();
}
-(void)setProgressStr:(NSString *)progressStr
{
    _progressStr = progressStr;
    self.progressLable.text = progressStr;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
   
}
@end
