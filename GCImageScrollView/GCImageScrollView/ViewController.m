//
//  ViewController.m
//  GCImageScrollView
//
//  Created by WWYT-TAgo-RD-CXH on 2018/11/8.
//  Copyright © 2018 sunflower. All rights reserved.
//

#import "ViewController.h"
#import "GCImageScrollView.h"
#import "UIimageView+WebCache.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    GCImageScrollView *imageScrollView = [[GCImageScrollView alloc] initWithFrame:self.view.bounds scrollDuration:3.0f];
    
    NSArray *images = [NSArray arrayWithObjects:
                       @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2375609456,4220648115&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=159393807,1386612130&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3913769477,2718754866&fm=26&gp=0.jpg",
                       @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1930281861,823170983&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1792173067,3810231280&fm=26&gp=0.jpg",
                       @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=64257681,3207562848&fm=26&gp=0.jpg",
                       nil];
    
    imageScrollView.imageURLStringArray = images;
    imageScrollView.gc_imageViewLoad = ^(UIImageView * _Nonnull imageView, NSURL * _Nonnull url) {
        [imageView sd_setImageWithURL:url];
    };
    
    [self.view addSubview:imageScrollView];
}


@end
