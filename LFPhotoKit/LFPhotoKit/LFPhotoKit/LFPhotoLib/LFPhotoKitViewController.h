//
//  LFPhotoKitViewController.h
//  LFPhotoKit
//
//  Created by liufei on 2019/7/17.
//  Copyright © 2019 liufei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LFPhotoKitSourceType) {
    LFPhotoKitSourceTypeUnknow,
    ///图片类型
    LFPhotoKitSourceTypeImage,
    ///视频类型
    LFPhotoKitSourceTypeVideo
};
@class LFPhotoKitViewController;

@protocol LFPhotoKitViewControllerDelegate <NSObject>

/**
 图片裁剪回调

 @param photoKitController LFPhotoKitViewController
 @param coverImage 裁剪后的图片
 */
- (void)photoKitController:(LFPhotoKitViewController *)photoKitController
                coverImage:(UIImage *)coverImage;

@end

@interface LFPhotoKitViewController : UIViewController

/**原始图片，当sourceType等于LFPhotoKitSourceTypeImage时要传*/
@property (nonatomic, strong) UIImage *originImage;
/**原始视频，当sourceType等于LFPhotoKitSourceTypeVideo时要传*/
@property (nonatomic, strong) NSURL *videoUrl;
/**资源类型*/
@property (nonatomic, assign) LFPhotoKitSourceType sourceType;
/**回调代理*/
@property (nonatomic, weak) id<LFPhotoKitViewControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
