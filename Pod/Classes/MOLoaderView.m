//
//  MOLoaderView.m
//  MOLoaderView
//
//  Created by Mario Oriente @Work on 14/11/14.
//  Copyright (c) 2014 Mario Oriente. All rights reserved.
//

#import "MOLoaderView.h"
#import "POP.h"

@interface MOLoaderView () <POPAnimationDelegate>

@property (nonatomic, strong) CAShapeLayer *strokeLayer;

@property (nonatomic, strong) UIColor *backgroundCircleColor;
@property (nonatomic, strong) UIColor *ringColor;
@property (nonatomic, strong) UIColor *strokeColor;

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat strokeWidth;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *frontView;

@property (nonatomic, strong) UIVisualEffectView *backgroundBlurView;
@property (nonatomic, strong) UIVisualEffectView *circleBlurView;
@property (nonatomic, strong) UIVisualEffectView *vibrancyEffectView;

@property (nonatomic, assign) UIBlurEffect *blurEffect;

@property (nonatomic, copy) UILabel *percentageLabel;
@property (nonatomic, assign) BOOL percentageSymbolVisible;

@property (nonatomic, copy) void(^completionBlock)();

@end

@implementation MOLoaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.alpha = 0;
    }
    return self;
}

-(instancetype)initWithRadius:(CGFloat)r
                  strokeWidth:(CGFloat)width
        backgroundCircleColor:(UIColor *)backgroundCircleColor
                  circleColor:(UIColor *)circleColor
                  strokeColor:(UIColor *)strokeColor
               showPercentage:(BOOL)showPercentage
                   withSymbol:(BOOL)showSymbol
             didCompleteBlock:(LoaderViewBlock)block {
    
    if ((self = [super initWithFrame:CGRectMake(0, 0, r*2, r*2)])) {
        [self.layer setCornerRadius:r];
        self.radius = r;
        self.strokeWidth = width;
        self.backgroundCircleColor = backgroundCircleColor;
        self.ringColor = circleColor;
        self.strokeColor = strokeColor;
        [self.layer setCornerRadius:r];
        [self.layer setMasksToBounds:NO];
        self.completionBlock = block;
        self.isLoading = NO;
        [self initLayers];
        if(showPercentage){
            _percentageSymbolVisible = showSymbol;
            [self initPercentageLabelWithVribrancyEffect:NO];
        }
    }
    return self;
}

-(instancetype)initWithRadius:(CGFloat)r
                  strokeWidth:(CGFloat)width
              blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle
                  strokeColor:(UIColor *)strokeColor
               showPercentage:(BOOL)showPercentage
                   withSymbol:(BOOL)showSymbol
             didCompleteBlock:(LoaderViewBlock)block
{
    if ((self = [super initWithFrame:CGRectMake(0, 0, r*2, r*2)])) {
        [self.layer setCornerRadius:r];
        self.radius = r;
        self.strokeWidth = width;
        self.strokeColor = strokeColor;
        [self.layer setCornerRadius:r];
        [self.layer setMasksToBounds:NO];
        self.completionBlock = block;
        self.isLoading = NO;
        self.blurEffect = [UIBlurEffect effectWithStyle:blurEffectStyle];
        [self initBlurredLayers];
        if(showPercentage){
            _percentageSymbolVisible = showSymbol;
            [self initPercentageLabelWithVribrancyEffect:YES];
        }
    }
    return self;
}

-(void)initPercentageLabelWithVribrancyEffect:(BOOL)vibrancy
{
    CGFloat multyplyFactor = 1.5;
    
    UIFont *helveticaFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:self.radius*multyplyFactor];
    _percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.strokeWidth, self.strokeWidth, multyplyFactor*self.frame.size.width-self.strokeWidth, self.frame.size.height-self.strokeWidth)];
    _percentageLabel.font = helveticaFont;
    _percentageLabel.numberOfLines = 1;
    _percentageLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _percentageLabel.center = CGPointMake(self.frame.size.width/2-self.strokeWidth, self.frame.size.height/2-self.strokeWidth);
    _percentageLabel.textAlignment = NSTextAlignmentCenter;
    _percentageLabel.textColor = [self.strokeColor colorWithAlphaComponent:1];

    UIFont *percentageSymbolFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:self.radius/multyplyFactor];
    UILabel *percentageSymbolLabel = [[UILabel alloc] initWithFrame:self.frontView.frame];
    percentageSymbolLabel.font = percentageSymbolFont;
    percentageSymbolLabel.text = @"%";
    [percentageSymbolLabel sizeToFit];
    percentageSymbolLabel.textAlignment = NSTextAlignmentCenter;
    percentageSymbolLabel.textColor = [self.strokeColor colorWithAlphaComponent:.25];
    percentageSymbolLabel.center = CGPointMake(self.frame.size.width/2-self.strokeWidth, self.frontView.frame.size.height-percentageSymbolLabel.frame.size.height/6);
    
    if(vibrancy){
        UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:self.blurEffect];
        _vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
        [_vibrancyEffectView setFrame:self.frame];
        [[_vibrancyEffectView contentView] addSubview:_percentageLabel];
        
        if(_percentageSymbolVisible){
            [[_vibrancyEffectView contentView] addSubview:percentageSymbolLabel];
        }
        [[_circleBlurView contentView] addSubview:_vibrancyEffectView];
    } else {
        if(_percentageSymbolVisible){
            [self.frontView addSubview:percentageSymbolLabel];
        }
        [self.frontView addSubview:_percentageLabel];
    }
}

- (void)initBlurredLayers
{
//    UIBlurEffect *extraLightEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIBlurEffect *lightEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIBlurEffect *darkEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    CGRect outerShape = CGRectMake(0, 0, 2*self.radius, 2*self.radius);
    CGRect innerShape = CGRectMake(self.strokeWidth/2, self.strokeWidth/2, 2*(self.radius-self.strokeWidth), 2*(self.radius-self.strokeWidth));
    CGRect strokeShape = CGRectInset(outerShape, self.strokeWidth/2, self.strokeWidth/2);
    
    self.backgroundView = [[UIView alloc] initWithFrame:outerShape];
    UIVisualEffectView *backgroundBlurView = [[UIVisualEffectView alloc] initWithEffect:(self.blurEffect == darkEffect) ? darkEffect : lightEffect];
    backgroundBlurView.frame = outerShape;
    backgroundBlurView.layer.cornerRadius = backgroundBlurView.frame.size.width/2;
    backgroundBlurView.layer.masksToBounds = YES;
    [self.backgroundView addSubview:backgroundBlurView];
    [self addSubview:self.backgroundView];
    
    self.frontView = [[UIView alloc] initWithFrame:innerShape];
    _circleBlurView = [[UIVisualEffectView alloc] initWithEffect:self.blurEffect];
    _circleBlurView.frame = innerShape;
    _circleBlurView.layer.cornerRadius = _circleBlurView.frame.size.width/2;
    _circleBlurView.layer.masksToBounds = YES;
    [self.frontView addSubview:_circleBlurView];
    [self addSubview:self.frontView];
    
    _strokeLayer = [CAShapeLayer layer];
    [_strokeLayer setPath:[UIBezierPath bezierPathWithRoundedRect:strokeShape cornerRadius:self.radius].CGPath];
    [_strokeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [_strokeLayer setStrokeColor:[self.strokeColor CGColor]];
    [_strokeLayer setLineWidth:self.strokeWidth];
    [_strokeLayer setLineCap:kCALineCapRound];
    [_strokeLayer setStrokeEnd:0.0];
    [_strokeLayer setOpacity:0.0];
    [_strokeLayer setFrame:self.frame];
    [self.layer addSublayer:_strokeLayer];
}

- (void)initLayers
{
    CGRect outerShape = CGRectMake(0, 0, 2*self.radius, 2*self.radius);
    CGRect innerShape = CGRectMake(self.strokeWidth, self.strokeWidth, 2*(self.radius-self.strokeWidth), 2*(self.radius-self.strokeWidth));
    CGRect strokeShape = CGRectInset(outerShape, self.strokeWidth/2, self.strokeWidth/2);
    
    self.backgroundView = [[UIView alloc] initWithFrame:outerShape];
    [self.backgroundView setBackgroundColor:self.backgroundCircleColor];
    self.backgroundView.layer.cornerRadius = outerShape.size.width/2;
    self.backgroundView.layer.masksToBounds = YES;
    
    self.frontView = [[UIView alloc] initWithFrame:innerShape];
    [self.frontView setBackgroundColor:self.ringColor];
    self.frontView.layer.cornerRadius = innerShape.size.width/2;
    self.frontView.layer.masksToBounds = YES;
    
    _strokeLayer = [CAShapeLayer layer];
    [_strokeLayer setPath:[UIBezierPath bezierPathWithRoundedRect:strokeShape cornerRadius:self.radius].CGPath];
    [_strokeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [_strokeLayer setStrokeColor:[self.strokeColor CGColor]];
    [_strokeLayer setLineWidth:self.strokeWidth];
    [_strokeLayer setLineCap:kCALineCapRound];
    [_strokeLayer setStrokeEnd:0.0];
    [_strokeLayer setFrame:self.frame];
    
    [self addSubview:self.backgroundView];
    [self addSubview:self.frontView];
    [self.layer addSublayer:_strokeLayer];
}

-(void)showAtPoint:(CGPoint)center withZoomOut:(BOOL)zoomOut
{
    [self setCenter:center];
    self.alpha = 0;
    
    CGFloat startScale = 0.1;
    
    if (zoomOut) {
        startScale = 3.0;
    }
    
    POPBasicAnimation *fadeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    fadeAnimation.toValue = @1;
    fadeAnimation.duration = .35;
    fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self pop_addAnimation:fadeAnimation forKey:@"fade"];
    
    POPSpringAnimation *showBackgroundAnimation = [POPSpringAnimation animation];
    showBackgroundAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];
    showBackgroundAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(startScale, startScale)];
    showBackgroundAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    showBackgroundAnimation.springBounciness = 10.0;
    showBackgroundAnimation.springSpeed = 10.0;
    [self.backgroundView pop_addAnimation:showBackgroundAnimation forKey:@"showBackground"];
    
    POPSpringAnimation *showCircleAnimation = [POPSpringAnimation animation];
    showCircleAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];
    showCircleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(startScale, startScale)];
    showCircleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    showCircleAnimation.springBounciness = 15.0;
    showCircleAnimation.springSpeed = 15.0;
    [self.frontView pop_addAnimation:showCircleAnimation forKey:@"showCircle"];
    
    [self performSelector:@selector(waitingAnimation) withObject:nil afterDelay:0];
}

-(void)updatePercentageLabelWithProgress:(CGFloat)progress
{
    if(_percentageLabel){
        _percentageLabel.text = [NSString stringWithFormat:@"%d", (int)roundf(progress)];
    }
}

- (void)animateWithProgress:(CGFloat)progress
{
    POPBasicAnimation *waitingAnimation = [_strokeLayer pop_animationForKey:@"waiting"];
    POPBasicAnimation *strokeStartAnimation = [_strokeLayer pop_animationForKey:@"strokeStart"];
    POPBasicAnimation *strokeEndAnimation = [_strokeLayer pop_animationForKey:@"strokeEnd"];
    POPBasicAnimation *thicknessAnimation = [_strokeLayer pop_animationForKey:@"thickness"];
    
    __block POPSpringAnimation *progressAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    progressAnimation.toValue = @(MIN(MAX(0, progress/100), 1));

    if(strokeStartAnimation){
        strokeStartAnimation.delegate = strokeEndAnimation.delegate = thicknessAnimation.delegate = nil;
        strokeStartAnimation.repeatForever = strokeEndAnimation.repeatForever = waitingAnimation.repeatForever = thicknessAnimation.repeatForever = NO;
        strokeStartAnimation.completionBlock = ^void(POPAnimation *anim, BOOL finished){
            if(finished){
                [_strokeLayer pop_removeAllAnimations];
                [_strokeLayer setStrokeStart:0];
                [_strokeLayer setStrokeEnd:0];
                [_strokeLayer setLineWidth:self.strokeWidth];

                progressAnimation.fromValue = @0;
                [_strokeLayer pop_addAnimation:progressAnimation forKey:@"progress"];
                [self updatePercentageLabelWithProgress:progress];
            }
        };
    } else {
        [_strokeLayer pop_addAnimation:progressAnimation forKey:@"progress"];
        [self updatePercentageLabelWithProgress:progress];
        
        __weak typeof(self) weakSelf = self;
        progressAnimation.completionBlock = ^void(POPAnimation *anim, BOOL finished){
            if(finished && _strokeLayer.strokeEnd == 1.0){
                [_strokeLayer pop_removeAllAnimations];
                [self pop_removeAllAnimations];
                weakSelf.completionBlock();
            }
        };
    }
}

-(void)pop_animationDidReachToValue:(POPAnimation *)anim
{
    anim.autoreverses = YES;
}

-(void)waitingAnimation
{
    [self.strokeLayer setLineWidth:0];
    [_strokeLayer pop_removeAllAnimations];
    
/* kPOPShapeLayerLineWidth property definition */
/**/    NSString *kPOPShapeLayerLineWidth = [POPAnimatableProperty propertyWithName:@"shapeLayer.lineWidth" initializer:^(POPMutableAnimatableProperty *prop) {
/**/        prop.readBlock = ^(CAShapeLayer *obj, CGFloat values[]) {
/**/            values[0] = obj.lineWidth;
/**/        };
/**/        prop.writeBlock = ^(CAShapeLayer *obj, const CGFloat values[]) {
/**/            obj.lineWidth = values[0];
/**/        };
/**/        prop.threshold = 0.01;
/**/    }];
/* YOU CAN DELETE THIS PART AFTER POP RELEASES 1.0.8 WHICH INCLUDES THIS PROPERTY BY DEFAULT */
    
    POPBasicAnimation *progressAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    POPBasicAnimation *strokeEndAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    POPBasicAnimation *strokeStartAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeStart];
    POPBasicAnimation *thicknessAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerLineWidth];
    POPBasicAnimation *strokeOpacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    
    strokeOpacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    strokeOpacityAnimation.fromValue = @0;
    strokeOpacityAnimation.toValue = @1;
    
    thicknessAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    thicknessAnimation.fromValue = @1;
    thicknessAnimation.toValue = @(self.strokeWidth);
    thicknessAnimation.duration = 1;
    thicknessAnimation.repeatForever = YES;
    thicknessAnimation.delegate = self;
    
//    thicknessAnimation.tracer.shouldLogAndResetOnCompletion = YES;
//    [thicknessAnimation.tracer start];
    
    progressAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    progressAnimation.duration = 2.5;
    progressAnimation.removedOnCompletion = YES;
    progressAnimation.fromValue = @0;
    progressAnimation.toValue = @(M_PI*4);
    progressAnimation.repeatForever = YES;
    
    
    strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    strokeStartAnimation.fromValue = @0;
    strokeStartAnimation.toValue = @.75;
    strokeStartAnimation.duration = 2;
    strokeStartAnimation.repeatForever = YES;
    strokeStartAnimation.autoreverses = YES;
    strokeStartAnimation.delegate = self;
    
    
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    strokeEndAnimation.fromValue = @0;
    strokeEndAnimation.toValue = @.75;
    strokeEndAnimation.duration = 2;
    strokeEndAnimation.repeatForever = YES;
    strokeEndAnimation.autoreverses = YES;
    strokeEndAnimation.delegate = self;
    
    thicknessAnimation.beginTime = CACurrentMediaTime() + .5;
    strokeStartAnimation.beginTime = CACurrentMediaTime() + .75;
    strokeEndAnimation.beginTime = CACurrentMediaTime();
    
    [_strokeLayer pop_addAnimation:progressAnimation forKey:@"waiting"];
    [_strokeLayer pop_addAnimation:strokeEndAnimation forKey:@"strokeEnd"];
    [_strokeLayer pop_addAnimation:strokeStartAnimation forKey:@"strokeStart"];
    [_strokeLayer pop_addAnimation:thicknessAnimation forKey:@"thickness"];
    [_strokeLayer pop_addAnimation:strokeOpacityAnimation forKey:@"opacity"];
    
    _isLoading = YES;
}

-(void)hide
{
    POPBasicAnimation *fadeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    fadeAnimation.toValue = @0;
    fadeAnimation.duration = .25;
    fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self pop_addAnimation:fadeAnimation forKey:@"fade"];
    
    POPSpringAnimation *hideAnimation = [POPSpringAnimation animation];
    hideAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];
    hideAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)];
    hideAnimation.springBounciness = 10.0;
    hideAnimation.springSpeed = 7.0;
    [self pop_addAnimation:hideAnimation forKey:@"hide"];
    
    hideAnimation.completionBlock = ^void(POPAnimation *anim, BOOL finished){
        
        if(finished){
            _isLoading = NO;
            _percentageLabel = nil;
            [self.backgroundView pop_removeAllAnimations];
            [self.frontView pop_removeAllAnimations];
            [_strokeLayer pop_removeAllAnimations];
            [self pop_removeAllAnimations];
            [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        }
    };
}

@end
