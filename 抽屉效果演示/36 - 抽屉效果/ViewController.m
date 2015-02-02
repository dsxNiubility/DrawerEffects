//
//  ViewController.m
//  36 - 抽屉效果
//
//  Created by 董 尚先 on 14-12-26.
//  Copyright (c) 2014年 shangxianDante. All rights reserved.
//

#import "ViewController.h"


#define kMax 60
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *greenView;
@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (weak, nonatomic) IBOutlet UIView *redView;

@property (nonatomic,assign) CGFloat offsetX;

@property (nonatomic,assign) BOOL isDraging;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isDraging = YES;
    UITouch *tou = [touches anyObject];
    
    CGPoint now = [tou locationInView:self.redView];  // $$$$$
    CGPoint pre = [tou previousLocationInView:self.redView];
    
    CGFloat offsetX = now.x - pre.x;
    self.offsetX = offsetX;
    
    self.redView.frame = [self rectWithOffsetX:offsetX];
    
    // 判断下往左拖显示绿色 往右拖显示红色
    if (self.redView.frame.origin.x <= 0) {
        self.greenView.hidden = YES;
        self.blueView.hidden = NO;
    }else{
        self.blueView.hidden = YES;
        self.greenView.hidden = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 判断下 如果当前没有拖动，那点一下就返回原状
    if (_isDraging == NO && self.redView.frame.origin.x != 0) {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.redView.frame = self.view.frame;
        }];
    }
    
    // 先设置一个目标点 判断要走哪个目标点
    CGFloat target = 0;
    if (_redView.frame.origin.x > kScreenW * 0.5) {
        target = 290;
    }else if(CGRectGetMaxX(self.redView.frame) < kScreenW * 0.5){
        target = -250;
    }
    
    // 用目标减去自己现在的位置得到偏移量
    CGFloat offset = target - _redView.frame.origin.x;
    
    CGRect frame = self.redView.frame;
    
    frame.origin.x += offset;
    
    // 可能存在误差小数点 判断下 直接还原
    if (target == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.redView.frame = self.view.frame;
        }];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            
            // 通过偏移量 算出当前frame各项属性的确切位置
            self.redView.frame = [self rectWithOffsetX:offset];
        }];
    }

    self.isDraging = NO;
}


- (CGRect)rectWithOffsetX:(CGFloat)offsetX  // $$$$$
{
    CGFloat offsetY = offsetX * kMax / kScreenW;
    
    // 计算出比例
    CGFloat scale = (kScreenH - 2 * offsetY)/kScreenH;
    
    // 如果是往左拖 会越来越大 不能这样啊
    if (self.redView.frame.origin.x < 0) {
        scale =  (kScreenH + 2 * offsetY)/kScreenH;
    }
    
    CGRect frame = self.redView.frame;
    
    frame.origin.x += offsetX;
    frame.size.width = frame.size.width * scale;
    frame.size.height = frame.size.height * scale;
    frame.origin.y = (kScreenH - frame.size.height) * 0.5;   // $$$$$
    
    return frame;
}

- (void)test{
    CGFloat half = self.view.bounds.size.width/2.0;
    
    
    //    NSLog(@"%f",half);
    //
    //    NSLog(@"%f",CGRectGetMaxX(self.redView.frame));
    
    if (self.redView.frame.origin.x <= half && CGRectGetMaxX(self.redView.frame) >= half) {
        [UIView animateWithDuration:0.25 animations:^{
            self.redView.frame = self.view.frame;
        }];
    }else if (CGRectGetMaxX(self.redView.frame) <= half){
        CGRect redFrame = self.redView.frame;
        redFrame.origin.x = -250;
        //        redFrame = [self rectWithOffsetX: - 250];
        //        redFrame.origin.y = 60;
        //        redFrame.size.height = kScreenH - 120;
        [UIView animateWithDuration:0.25 animations:^{
            self.redView.frame = redFrame;
        }];
    }else{
        CGRect redFrame = self.redView.frame;
        redFrame.origin.x = 290;
        redFrame =  [self rectWithOffsetX:kScreenW - 290];
        [UIView animateWithDuration:0.25 animations:^{
            self.redView.frame = redFrame;
        }];
    }

}
@end
