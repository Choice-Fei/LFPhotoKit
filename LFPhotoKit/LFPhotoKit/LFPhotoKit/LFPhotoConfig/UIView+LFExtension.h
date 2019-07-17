//
//  UIView+LFExtension.h
//  MMVMDemo
//
//  Created by liufei on 2018/12/4.
//  Copyright © 2018年 liufei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LFExtension)
@property (nonatomic, assign) CGFloat lf_x;

@property (nonatomic, assign) CGFloat lf_y;

@property (nonatomic, assign) CGFloat lf_h;

@property (nonatomic, assign) CGFloat lf_w;

@property (nonatomic, assign) CGFloat lf_right;

@property (nonatomic, assign) CGFloat lf_bottom;

@property (nonatomic, assign) CGFloat lf_centerY;

@property (nonatomic, assign) CGFloat lf_centerX;

@property (nonatomic, assign) CGSize lf_size;
@end

NS_ASSUME_NONNULL_END
