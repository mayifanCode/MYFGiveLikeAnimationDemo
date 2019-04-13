//
//  LikeView.m
//  animationHeart
//
//  Created by Ma Yifan on 2019/4/11.
//  Copyright © 2019 sensetime. All rights reserved.
//

#import "LikeView.h"
#define STWeakSelf __weak typeof(self) weakSelf = self;

typedef NS_ENUM(NSInteger, LikeType) {
    GiveType, //点赞
    CancelType //取消赞
};


@interface LikeView()

@property (nonatomic,strong) UIImageView *giveLikeView;
@property (nonatomic,strong) UIImageView *cancelLikeView;
@property (nonatomic,assign) CGFloat length;//半径
@property (nonatomic,strong) NSMutableArray *array;

@end



@implementation LikeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addGesture];
    }
    return self;
}

- (UIImageView *)createGiveLikeView
{
    UIImageView *giveLikeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    giveLikeView.backgroundColor = [UIColor clearColor];
    UIImage *image = [UIImage imageNamed:@"icon_home_like_after"];
    giveLikeView.userInteractionEnabled = YES;
    giveLikeView.tag = GiveType;
    giveLikeView.image = image;
    giveLikeView.hidden = NO;
    _giveLikeView = giveLikeView;
    return _giveLikeView;
}

- (UIImageView *)cancelLikeView
{
    if(_cancelLikeView == nil) {
        _cancelLikeView = [[UIImageView alloc] initWithFrame:self.bounds];
        UIImage *image = [UIImage imageNamed:@"icon_home_like_before"];
        _cancelLikeView.image = image;
        _cancelLikeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *cancelLikeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction:)];
        [_cancelLikeView addGestureRecognizer:cancelLikeGesture];
        _cancelLikeView.tag = CancelType;
        _cancelLikeView.hidden = NO;
    }
    return _cancelLikeView;
}





- (void)likeAction:(UIImageView *)giveLikeView
{
    [self giveLikeAction:giveLikeView];
}

- (void)cancelAction:(UITapGestureRecognizer *)sender
{
    
}

- (void)giveLikeAction:(UIImageView *)giveLikeView
{
    [self animtionChangeLikeType:giveLikeView];
    [self createTrigonsAnimtion:giveLikeView];
    [self createCircleAnimation:giveLikeView];
}


- (void)createCircleAnimation:(UIImageView *)giveLikeView
{
    CAShapeLayer *circleLayer = [[CAShapeLayer alloc] init];
    circleLayer.frame = giveLikeView.frame;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.strokeColor = [UIColor redColor].CGColor;
    circleLayer.lineWidth = 1;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(giveLikeView.bounds.size.width/2, giveLikeView.bounds.size.height/2) radius:giveLikeView.bounds.size.width startAngle:-1.57 endAngle:-1.57+3.14*2 clockwise:YES];
    circleLayer.path = bezierPath.CGPath;
    [self.layer addSublayer:circleLayer];
    
    //动画
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    NSTimeInterval groupInterval = self.animationDurtion * 0.8;
    group.duration = groupInterval;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    CABasicAnimation * scaleAnimtion = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimtion.beginTime = 0;
    scaleAnimtion.duration = groupInterval * 0.8;
    scaleAnimtion.fromValue = @(0);
    scaleAnimtion.toValue = @(1);
    
    CABasicAnimation * widthStartAnimtion = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    widthStartAnimtion.beginTime = 0;
    widthStartAnimtion.duration = groupInterval * 0.8;
    widthStartAnimtion.fromValue = @(1);
    widthStartAnimtion.toValue = @(2);
    
    CABasicAnimation * widthEndAnimtion = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    widthEndAnimtion.beginTime = groupInterval * 0.8;
    widthEndAnimtion.duration = groupInterval * 0.2;
    widthEndAnimtion.fromValue = @(2);
    widthEndAnimtion.toValue = @(0);
    
    group.animations = @[scaleAnimtion,widthStartAnimtion,widthEndAnimtion];
    [circleLayer addAnimation:group forKey:nil];

}

- (void)animtionChangeLikeType:(UIImageView *)giveLikeView
{
   
        giveLikeView.hidden = NO;
        [UIView animateKeyframesWithDuration:self.animationDurtion * 4 delay:0.0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            /*参数1:关键帧开始时间
                       参数2:关键帧占用时间比例
                       参数3:到达该关键帧时的属性值 */
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 * self.animationDurtion animations:^{
                giveLikeView.transform =  CGAffineTransformMakeScale(3, 3);;
            }];
            [UIView addKeyframeWithRelativeStartTime:0.5 * self.animationDurtion relativeDuration:0.5 * self.animationDurtion animations:^{
                giveLikeView.transform = CGAffineTransformIdentity;
            }];
            [UIView addKeyframeWithRelativeStartTime:self.animationDurtion relativeDuration:self.animationDurtion * 3 animations:^{
                giveLikeView.alpha = 0;
            }];
        } completion:^(BOOL finished) {
            giveLikeView.hidden = YES;
            [giveLikeView removeFromSuperview];
        }];
    
}

//创建三角形
- (void)createTrigonsAnimtion:(UIImageView *)giveLikeView
{
    for(int i=0;i<6;i++) {
        //创建一个layer并设置位置和填充色
        CAShapeLayer *shape = [[CAShapeLayer alloc] init];
        shape.position = CGPointMake(giveLikeView.bounds.size.width/2, giveLikeView.bounds.size.height/2);
        shape.fillColor = [UIColor redColor].CGColor;
        //设置贝塞尔曲线，执行路径
        UIBezierPath *startPath = [[UIBezierPath alloc] init];
        [startPath moveToPoint:CGPointMake(-2, 30)];
        [startPath addLineToPoint:CGPointMake(2, 30)];
        [startPath addLineToPoint:CGPointMake(0, 0)];
        [startPath addLineToPoint:CGPointMake(-2, 30)];
        shape.path = startPath.CGPath;
        
        //旋转
        shape.transform = CATransform3DMakeRotation(3.14 / 3 * i, 0, 0, 1);
        [giveLikeView.layer addSublayer:shape];
        
        //动画组
        CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
        groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        groupAnimation.duration = self.animationDurtion;
        groupAnimation.fillMode = kCAFillModeForwards;
        groupAnimation.removedOnCompletion = NO;
        
        //基础动画1
        CABasicAnimation *scaleAnimtion = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        //缩放时间占20%
        scaleAnimtion.duration = self.animationDurtion * 0.2;
        scaleAnimtion.fromValue = @(0);
        scaleAnimtion.toValue = @(1);

        //绘制三角形结束 一条直线
        UIBezierPath *endPath = [UIBezierPath bezierPath];
        [endPath moveToPoint:CGPointMake(-2, 30)];
        [endPath addLineToPoint:CGPointMake(2, 30)];
        [endPath addLineToPoint:CGPointMake(0, 30)];

        //基础动画2
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.beginTime = self.animationDurtion * 0.2;
        pathAnimation.duration = self.animationDurtion * 0.8;
        pathAnimation.fromValue = (__bridge id)startPath.CGPath;
        pathAnimation.toValue = (__bridge id)endPath.CGPath;

        groupAnimation.animations = @[scaleAnimtion,pathAnimation];
        [shape addAnimation:groupAnimation forKey:nil];
    }
}

- (void)addGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(creatOneHeart:)];
    [self addGestureRecognizer:tap];
    
}



- (void)creatOneHeart:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self];
    dispatch_async(dispatch_get_main_queue(),^{
        [self initOneNewHeart:point];
    });
}

- (void)initOneNewHeart:(CGPoint)point
{
    UIImageView *giveLikeView = [self createGiveLikeView];
    giveLikeView.center = point;
    [self.array addObject:giveLikeView];
    [self addSubview:giveLikeView];
    [self likeAction:giveLikeView];
}


@end
