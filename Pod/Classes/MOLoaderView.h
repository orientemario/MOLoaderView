//
//  MOLoaderView.h
//  MOLoaderView
//
//  Created by Mario Oriente @Work on 14/11/14.
//  Copyright (c) 2014 Mario Oriente. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoaderViewBlock)();

@interface MOLoaderView : UIView

@property (nonatomic, assign) BOOL isLoading;

-(void)waitingAnimation;
-(void)animateWithProgress:(CGFloat)progress;
-(void)showAtPoint:(CGPoint)center withZoomOut:(BOOL)zoomOut;
-(void)hide;

-(instancetype)initWithRadius:(CGFloat)r strokeWidth:(CGFloat)width backgroundCircleColor:(UIColor *)backgroundCircleColor circleColor:(UIColor *)circleColor strokeColor:(UIColor *)strokeColor showPercentage:(BOOL)showPercentage withSymbol:(BOOL)showSymbol didCompleteBlock:(LoaderViewBlock)block;
-(instancetype)initWithRadius:(CGFloat)r strokeWidth:(CGFloat)width blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle strokeColor:(UIColor *)strokeColor showPercentage:(BOOL)showPercentage withSymbol:(BOOL)showSymbol didCompleteBlock:(LoaderViewBlock)block;
@end
