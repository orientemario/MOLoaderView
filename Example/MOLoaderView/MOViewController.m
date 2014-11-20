//
//  ViewController.m
//  Loader
//
//  Created by Mario Oriente @Work on 14/11/14.
//  Copyright (c) 2014 Mario Oriente. All rights reserved.
//

#import "MOViewController.h"
#import "MOLoaderView.h"

#define TINT_COLOR [UIColor colorWithRed:0.000 green:0.751 blue:1.000 alpha:1.000]

@interface MOViewController ()

@property (nonatomic, strong) MOLoaderView *loader;
@property (nonatomic, assign) CGFloat currentProgress;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UISegmentedControl *blurStyleChoice;
@property (weak, nonatomic) IBOutlet UISegmentedControl *loaderStyleChoice;
@property (weak, nonatomic) IBOutlet UISwitch *showingZoomEffectSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *showPercentageSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *showPercentageSymbolSwitch;
@property (weak, nonatomic) IBOutlet UILabel *zoomEffectLabel;
@property (weak, nonatomic) IBOutlet UIButton *showButton;

@end

@implementation MOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.blurStyleChoice.enabled = NO;
    self.showingZoomEffectSwitch.onTintColor = self.showPercentageSwitch.onTintColor = self.showPercentageSymbolSwitch.onTintColor = TINT_COLOR;
    
    [self.showingZoomEffectSwitch addTarget:self action:@selector(showingZoomEffectSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.showPercentageSwitch addTarget:self action:@selector(percentageSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.showButton.enabled = NO;
}

- (void)showingZoomEffectSwitchChanged:(id)sender{
    self.zoomEffectLabel.text = [sender isOn] ? @"Zoom Out" : @"Zoom In";
}

- (void)percentageSwitchChanged:(id)sender{
    if(![sender isOn]){
        [self.showPercentageSymbolSwitch setOn:NO animated:YES];
    }
    self.showPercentageSymbolSwitch.enabled = [sender isOn];
}

- (IBAction)showButton:(id)sender
{
    [self disableEverything];
    
    if([self.loaderStyleChoice selectedSegmentIndex] == 1){
        self.loader = [[MOLoaderView alloc] initWithRadius:100
                                               strokeWidth:5.0
                                     backgroundCircleColor:[UIColor colorWithRed:0.435 green:0.443 blue:0.475 alpha:1.000]
                                               circleColor:[UIColor colorWithRed:0.122 green:0.129 blue:0.141 alpha:1.000]
                                               strokeColor:TINT_COLOR
                                            showPercentage:self.showPercentageSwitch.on
                                                withSymbol:self.showPercentageSymbolSwitch.on
                                          didCompleteBlock:^{
                                              [self.timer invalidate];
                                              self.timer = nil;
                                              self.currentProgress = 0;
                                              NSLog(@"COMPLETE!");
                                              
                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                  [self.loader hide];
                                                  [self enableEverything];
                                              });
                                          }];
    } else {
        self.loader = [[MOLoaderView alloc] initWithRadius:100
                                               strokeWidth:5.0
                                           blurEffectStyle:self.blurStyleChoice.selectedSegmentIndex
                                               strokeColor:[UIColor whiteColor]
                                            showPercentage:self.showPercentageSwitch.on
                                                withSymbol:self.showPercentageSymbolSwitch.on
                                          didCompleteBlock:^{
                                              [self.timer invalidate];
                                              self.timer = nil;
                                              self.currentProgress = 0;
                                              NSLog(@"COMPLETE!");
                                              
                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                  [self.loader hide];
                                                  [self enableEverything];
                                              });
                                          }];
    }
    
    [self.loader showAtPoint:CGPointMake(self.view.center.x, self.view.frame.size.height/2) withZoomOut:self.showingZoomEffectSwitch.on];
    [self.view addSubview:self.loader];
    [self performSelector:@selector(startProgress) withObject:nil afterDelay:2];
}


- (IBAction)segmentedControlForStyleLoaderTouched:(id)sender
{
    if([self.loaderStyleChoice selectedSegmentIndex] == 0){
        self.blurStyleChoice.enabled = YES;
        self.showButton.enabled = NO;
    } else {
        self.blurStyleChoice.selectedSegmentIndex = UISegmentedControlNoSegment;
        self.blurStyleChoice.enabled = NO;
        self.showButton.enabled = YES;
    }
}

- (IBAction)segmentedControlForBlurStyleEffectTouched:(id)sender
{
    self.showButton.enabled = YES;
}

-(void)startProgress
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.33 target:self selector:@selector(incrementProgress) userInfo:nil repeats:YES];
}

-(void)incrementProgress
{
    self.currentProgress += MAX(self.currentProgress, 1) * .33;
    if(self.currentProgress>100){
        self.currentProgress = 100;
    }
    //DOWNLOAD
    [self.loader animateWithProgress:self.currentProgress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)enableEverything
{
    self.showButton.enabled = YES;
    self.loaderStyleChoice.enabled = YES;
    self.blurStyleChoice.enabled = (BOOL)(self.loaderStyleChoice.selectedSegmentIndex == 0);
    self.showingZoomEffectSwitch.enabled = YES;
    self.showPercentageSwitch.enabled = YES;
    self.showPercentageSymbolSwitch.enabled = self.showPercentageSwitch.on;
}

-(void)disableEverything
{
    self.showButton.enabled = NO;
    self.blurStyleChoice.enabled = NO;
    self.loaderStyleChoice.enabled = NO;
    self.showingZoomEffectSwitch.enabled = NO;
    self.showPercentageSwitch.enabled = NO;
    self.showPercentageSymbolSwitch.enabled = NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
