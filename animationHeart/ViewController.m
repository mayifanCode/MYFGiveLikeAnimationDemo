//
//  ViewController.m
//  animationHeart
//
//  Created by Ma Yifan on 2019/4/11.
//  Copyright © 2019 sensetime. All rights reserved.
//

#import "ViewController.h"
#import "LikeView.h"

@interface ViewController ()

@property (nonatomic, strong) LikeView *likeView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.likeView];
}

- (LikeView *)likeView
{
    if(!_likeView) {
        _likeView = [[LikeView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _likeView.center = self.view.center;
        _likeView.animationDurtion = 0.4;
        _likeView.backgroundColor = [UIColor clearColor];
    }

    return _likeView;
}




@end
