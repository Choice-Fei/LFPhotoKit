//
//  LFPhotoConfig.h
//  LFPhotoKit
//
//  Created by liufei on 2019/7/17.
//  Copyright © 2019 liufei. All rights reserved.
//

#ifndef LFPhotoConfig_h
#define LFPhotoConfig_h
#import "UIImage+ALi.h"
#import "UIView+LFExtension.h"

#define kStatusBarH ([UIApplication sharedApplication].statusBarFrame.size.height)//(44/20)

#define kStatusTabbarH  ((kStatusBarH == 44.0) ? 34.0 : 0.0)

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define k_CoverMargin (kScreenHeight - kScreenWidth )/ 2

#define CustomColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#endif /* LFPhotoConfig_h */
