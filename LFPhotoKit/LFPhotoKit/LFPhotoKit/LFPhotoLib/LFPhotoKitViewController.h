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
    LFPhotoKitSourceTypeImage,
    LFPhotoKitSourceTypeVideo
};
@class LFPhotoKitViewController;

@protocol LFPhotoKitViewControllerDelegate <NSObject>

- (void)photoKitController:(LFPhotoKitViewController *)photoKitController
                coverImage:(UIImage *)coverImage;

@end

@interface LFPhotoKitViewController : UIViewController

@property (nonatomic, strong) UIImage *originImage;

@property (nonatomic, strong) NSURL *videoUrl;

@property (nonatomic, assign) LFPhotoKitSourceType sourceType;

@property (nonatomic, weak) id<LFPhotoKitViewControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
