# MOLoaderView

[![Version](https://img.shields.io/cocoapods/v/MOLoaderView.svg?style=flat)](http://cocoadocs.org/docsets/MOLoaderView)
[![License](https://img.shields.io/cocoapods/l/MOLoaderView.svg?style=flat)](http://cocoadocs.org/docsets/MOLoaderView)
[![Platform](https://img.shields.io/cocoapods/p/MOLoaderView.svg?style=flat)](http://cocoadocs.org/docsets/MOLoaderView)

##Preview

![ExtraLight](https://cloud.githubusercontent.com/assets/7912774/5070655/94856ca2-6e69-11e4-9a1d-ca2694a74312.gif) ![Dark](https://cloud.githubusercontent.com/assets/7912774/5070667/a8dc388e-6e69-11e4-8829-edeb0fd06f42.gif)


## Installation

MOLoaderView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "MOLoaderView"

## Requirements

This library uses [POP](https://github.com/facebook/pop) animation engine by Facebook and `UIBlurEffect` available from iOS 8.0

## Example Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Library Usage
Import the library 

```obj-c
#import "MOLoaderView.h"
```

Initialize your loader using the blurred init

```obj-c
MOLoaderView *loader = [[MOLoaderView alloc] initWithRadius:100 strokeWidth:5.0
                       blurEffectStyle:0 strokeColor:[UIColor whiteColor]
                       showPercentage:YES withSymbol:YES
                       didCompleteBlock:^{
                           NSLog(@"COMPLETE!");
                       }];
```
Or the custom init to choose the combination of colors you like

```obj-c
MOLoaderView *loader = [[MOLoaderView alloc] initWithRadius:100 strokeWidth:5.0
                       backgroundCircleColor:[UIColor colorWithRed:0.435 green:0.443 blue:0.475 alpha:1.000]
                       circleColor:[UIColor colorWithRed:0.122 green:0.129 blue:0.141 alpha:1.000]
                       strokeColor:TINT_COLOR
                       showPercentage:YES withSymbol:NO
                       didCompleteBlock:^{
                            NSLog(@"COMPLETE!");
                       }];
```

Therefore, you can show the loader using

```obj-c
[loader showAtPoint:CGPointMake(self.view.center.x, self.view.frame.size.height/2) withZoomOut:NO];
[self.view addSubview:loader];
```
Increment the progress calling

```obj-c
[loader animateWithProgress:/*currentProgress*/];
```

And, once completed, hide it

```obj-c
[loader hide];
```

## Author

Mario Oriente, oriente.mario@gmail.com

## License

MOLoaderView is available under the MIT license. See the LICENSE file for more info.
