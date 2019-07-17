//
//  UIView+LFExtension.m
//  MMVMDemo
//
//  Created by liufei on 2018/12/4.
//  Copyright © 2018年 liufei. All rights reserved.
//

#import "UIView+LFExtension.h"

@implementation UIView (LFExtension)
- (CGFloat)lf_bottom {
    return self.lf_y + self.lf_h;
}
- (void)setLf_bottom:(CGFloat)lf_bottom {
    CGRect frame = self.frame;
    frame.origin.y = lf_bottom - self.lf_h;
    self.frame = frame;
}
- (void)setLf_h:(CGFloat)lf_h {
    CGRect frame = self.frame;
    frame.size.height = lf_h;
    self.frame = frame;
}
- (CGFloat)lf_h {
    return self.frame.size.height;
}
- (void)setLf_w:(CGFloat)lf_w {
    CGRect frame = self.frame;
    frame.size.width = lf_w;
    self.frame = frame;
}
- (CGFloat)lf_w {
    return self.frame.size.width;
}
- (CGFloat)lf_x {
    return self.frame.origin.x;
}
- (void)setLf_x:(CGFloat)lf_x {
    CGRect frame = self.frame;
    frame.origin.x = lf_x;
    self.frame = frame;
}
- (CGFloat)lf_y {
    return self.frame.origin.y;
}
- (void)setLf_y:(CGFloat)lf_y {
    CGRect frame = self.frame;
    frame.origin.y = lf_y;
    self.frame = frame;
}
- (void)setLf_right:(CGFloat)lf_right {
    CGRect frame = self.frame;
    frame.origin.x = lf_right - frame.size.width;
    self.frame = frame;
}
- (CGFloat)lf_right {
    return self.lf_x + self.lf_w;
}

/* centerX的setter和getter方法 */
- (void)setLf_centerX:(CGFloat)lf_centerX
{
    CGPoint center = self.center;
    center.x = lf_centerX;
    self.center = center;
}

- (CGFloat)lf_centerX
{
    return self.center.x;
}
/* centerY的setter和getter方法 */
- (void)setLf_centerY:(CGFloat)lf_centerY
{
    CGPoint center = self.center;
    center.y = lf_centerY;
    self.center = center;
}

- (CGFloat)lf_centerY
{
    return self.center.y;
}
/* size的setter和getter方法 */
-(void)setLf_size:(CGSize)lf_size {
    CGRect frame = self.frame;
    frame.size = lf_size;
    self.frame = frame;
}
- (CGSize)lf_size {
    return self.frame.size;
}
@end
