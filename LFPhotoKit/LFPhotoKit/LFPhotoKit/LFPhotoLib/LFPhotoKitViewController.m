//
//  LFPhotoKitViewController.m
//  LFPhotoKit
//
//  Created by liufei on 2019/7/17.
//  Copyright © 2019 liufei. All rights reserved.
//

#import "LFPhotoKitViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LFPhotoConfig.h"
@interface LFPhotoKitViewController ()<UIScrollViewDelegate>
{
    CGRect cropBoxFrame;
    CGSize oldImageSize;
    CMTime videoDuration;
    double totalSecond;
}
@property (nonatomic, strong) UIScrollView *backContentView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *coverAreaView;

@property (nonatomic, strong) UIImageView *tempImageView;

@property (nonatomic, strong) AVURLAsset *videoAsset;

@property (nonatomic, strong) AVAssetImageGenerator *generator;

@end

@implementation LFPhotoKitViewController

- (instancetype)init {
    if (self = [super init]) {
        cropBoxFrame = CGRectMake(0, k_CoverMargin, kScreenWidth, kScreenWidth);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self configUI];
    // Do any additional setup after loading the view.
}
- (void)configUI {
    if (self.sourceType == LFPhotoKitSourceTypeImage) {
        oldImageSize = self.originImage.size;
    } else if (self.sourceType == LFPhotoKitSourceTypeVideo) {
        self.videoAsset = [[AVURLAsset alloc] initWithURL:self.videoUrl options:nil];
        self.generator = [[AVAssetImageGenerator alloc] initWithAsset:_videoAsset];
        videoDuration = _videoAsset.duration;
        totalSecond = CMTimeGetSeconds(videoDuration);
        self.originImage = [self getImageWithSecond:0.f];
        oldImageSize = self.originImage.size;
    } else {
        oldImageSize = CGSizeMake(0, 0);        
    }
    //以cropboxsize 宽或者高最大的那个为基准
    CGFloat scale = 0.0f;
    CGSize cropBoxSize = CGSizeMake(kScreenWidth, kScreenWidth);
    scale = MAX(cropBoxSize.width/oldImageSize.width, cropBoxSize.height/oldImageSize.height);
    
    //按照比例算出初次展示的尺寸
    CGSize scaledSize = (CGSize){floorf(oldImageSize.width * scale), floorf(oldImageSize.height * scale)};
    self.imageView.frame = CGRectMake(0, 0, oldImageSize.width, oldImageSize.height);
    //配置scrollview
    self.backContentView.minimumZoomScale = scale;
    self.backContentView.maximumZoomScale = 3.0f;
    
    //初始缩放系数
    self.backContentView.zoomScale = self.backContentView.minimumZoomScale;
    self.backContentView.contentSize = scaledSize;
    //调整位置 使其居中
    if (cropBoxFrame.size.width < scaledSize.width - FLT_EPSILON || cropBoxFrame.size.height < scaledSize.height - FLT_EPSILON) {
        CGPoint offset = CGPointZero;
        offset.x = -floorf((CGRectGetWidth(self.backContentView.frame) - scaledSize.width) * 0.5f);
        offset.y = -floorf((CGRectGetHeight(self.backContentView.frame) - scaledSize.height) * 0.5f);
        self.backContentView.contentOffset = offset;
    }
    self.imageView.image = _originImage;
    [self setUpSubViews];
}
#pragma mark private action
- (void)handleClose:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)handleSave:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoKitController:coverImage:)]) {
        [self.delegate photoKitController:self coverImage:[self.imageView.image croppedImageWithFrame:[self imageCropFrame]]];
    }
}
- (void)handlePanCover:(UIPanGestureRecognizer *)gesture {
    //1.获取平移的增量.
    //    CGPoint increment = [gesture translationInView:gesture.view];
    CGPoint localPoint = [gesture locationInView:nil];
    
    //2,改变视图的位置. 仿射变换(让视图上得每个点发生变化).
    if (gesture.state == UIGestureRecognizerStateChanged) {
        if (localPoint.x < 24) {
            gesture.view.center = CGPointMake(24,kScreenHeight - 24);
        } else if (localPoint.x> kScreenWidth - 24) {
            gesture.view.center = CGPointMake(kScreenWidth - 24, kScreenHeight - 24);
        } else {
            gesture.view.center = CGPointMake([gesture locationInView:nil].x, kScreenHeight - 24);
            [self changeTempImage];
            
        }
        
    }
    //3.因为系统计算的增量是相当于第一次的增量,增量叠加,我们只需要将之前的增量置零即可.
    //[gesture setTranslation:CGPointZero inView:gesture.view];
}
- (void)changeTempImage {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tempImageView.image = [self getImageWithSecond:self.tempImageView.lf_x * self->totalSecond / (kScreenWidth - 48)];
        self.imageView.image = self.tempImageView.image;
    });
}
//最后裁剪时图片位置确定
- (CGRect)imageCropFrame
{
    CGSize imageSize = self.imageView.image.size;
    CGSize contentSize = self.backContentView.contentSize;
    CGPoint contentOffset = self.backContentView.contentOffset;
    UIEdgeInsets edgeInsets = self.backContentView.contentInset;
    
    CGRect frame = CGRectZero;
    frame.origin.x = floorf((contentOffset.x + edgeInsets.left) * (imageSize.width / contentSize.width));
    frame.origin.x = MAX(0, frame.origin.x);
    
    frame.origin.y = floorf((contentOffset.y + edgeInsets.top) * (imageSize.height / contentSize.height));
    frame.origin.y = MAX(0, frame.origin.y);
    
    frame.size.width = ceilf(cropBoxFrame.size.width * (imageSize.width / contentSize.width));
    frame.size.width = MIN(imageSize.width, frame.size.width);
    
    frame.size.height = ceilf(cropBoxFrame.size.height * (imageSize.height / contentSize.height));
    frame.size.height = MIN(imageSize.height, frame.size.height);
    
    return frame;
}
#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}
#pragma mark - layout subviews
- (void)setUpSubViews {
    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, k_CoverMargin)];
    topBackView.backgroundColor = CustomColor(51, 51, 51, 0.8);
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, k_CoverMargin - 30, kScreenWidth, 20)];
    textLabel.font =  [UIFont systemFontOfSize:12];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"滑动屏幕选择裁剪区域";
    [topBackView addSubview:textLabel];
    if (self.sourceType == LFPhotoKitSourceTypeVideo) {
        self.tempImageView.image = self.imageView.image;
        [self setUpVideoCoverBottomView];
    }
    UIView *bottomBackView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - k_CoverMargin, kScreenWidth, k_CoverMargin)];
    bottomBackView.backgroundColor = CustomColor(51, 51, 51, 0.8);
    [self.view addSubview:topBackView];
    self.coverAreaView = [[UIImageView alloc] initWithFrame:cropBoxFrame];
    self.coverAreaView.image = [UIImage imageNamed:@"icon_coverviewfinder"];
    [self.view addSubview:self.coverAreaView];
    [self.view addSubview:bottomBackView];
    UIButton *cancelButton = [self createActionBtnWithTitle:@"取消"];
    cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomBackView addSubview:cancelButton];

    [cancelButton addTarget:self action:@selector(handleClose:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[cancelButton(80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cancelButton)]];
    [bottomBackView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cancelButton(30)]-60-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cancelButton)]];
    UIButton *doneButton = [self createActionBtnWithTitle:@"确定"];
    doneButton.translatesAutoresizingMaskIntoConstraints = NO;
    [doneButton addTarget:self action:@selector(handleSave:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackView addSubview:doneButton];
    [bottomBackView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[doneButton(80)]-30-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(doneButton)]];
    [bottomBackView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[doneButton(30)]-60-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(doneButton)]];
    if (self.sourceType == LFPhotoKitSourceTypeVideo) {
        [self.view bringSubviewToFront:self.tempImageView];
    }
}
- (UIButton *)createActionBtnWithTitle:(NSString *)title {
    UIButton *sender = [UIButton buttonWithType:UIButtonTypeCustom];
    [sender setTitle:title forState:UIControlStateNormal];
    [sender.layer setCornerRadius:3.f];
    [sender.layer setMasksToBounds:YES];
    [sender.layer setBorderColor:[UIColor whiteColor].CGColor];
    [sender.layer setBorderWidth:0.5];
    [sender setBackgroundColor:CustomColor(0, 0, 0, 0.2)];
    [sender.titleLabel setFont:[UIFont systemFontOfSize:14]];
    return sender;
}
- (void)setUpVideoCoverBottomView {
    for ( int i  = 0; i < 9 ; i++) {
        UIImageView *coverPreView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i / 9, kScreenHeight - 45, kScreenWidth / 9, 42)];
        coverPreView.contentMode = UIViewContentModeScaleAspectFill;
        coverPreView.clipsToBounds = YES;
        coverPreView.image = [self getImageWithSecond:i * totalSecond / 9];
        [self.view addSubview:coverPreView];
    }
}
- (UIImage *)getImageWithSecond:(float)videoSecond {
    self.generator.appliesPreferredTrackTransform = YES;
    self.generator.requestedTimeToleranceAfter = kCMTimeZero;
    self.generator.requestedTimeToleranceBefore = kCMTimeZero;
    CMTime requestTime = CMTimeMakeWithSeconds(videoSecond, self.videoAsset.duration.timescale);
    CMTime actualTime;
    CGImageRef imageRef = [self.generator copyCGImageAtTime:requestTime actualTime:&actualTime error:nil];
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}
#pragma mark - lazy
- (UIScrollView *)backContentView {
    if (!_backContentView) {
        _backContentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _backContentView.delegate = self;
        _backContentView.showsVerticalScrollIndicator = NO;
        _backContentView.showsHorizontalScrollIndicator = NO;
        _backContentView.minimumZoomScale = 1.0;
        _backContentView.maximumZoomScale = 3.0;
        [_backContentView setZoomScale:1.0];
        // 以cropBoxFrame为基准设施 scrollview 的insets 使其与cropBoxFrame 匹配 防止 缩放时突变回顶部
        _backContentView.contentInset = (UIEdgeInsets){CGRectGetMinY(cropBoxFrame),
            CGRectGetMinX(cropBoxFrame),
            CGRectGetMaxY(self.view.bounds) - CGRectGetMaxY(cropBoxFrame),
            CGRectGetMaxX(self.view.bounds) - CGRectGetMaxX(cropBoxFrame)};
        [self.view addSubview:_backContentView];
        if (@available(iOS 11.0, *)){
            _backContentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _backContentView;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView =[[UIImageView alloc] initWithFrame:self.view.bounds];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        //[_imageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMoveCover:)]];
        [self.backContentView addSubview:_imageView];
    }
    return  _imageView;
}
- (UIImageView *)tempImageView {
    if (!_tempImageView) {
        _tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 48, 48, 48)];
        _tempImageView.layer.borderWidth = 3.f;
        _tempImageView.layer.borderColor = CustomColor(255, 201, 98, 1).CGColor;
        _tempImageView.contentMode = UIViewContentModeScaleAspectFill;
        _tempImageView.clipsToBounds = YES;
        _tempImageView.userInteractionEnabled = YES;
        [_tempImageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanCover:)]];
        [self.view addSubview:_tempImageView];
        
    }
    return _tempImageView;
}
- (void)dealloc {
    NSLog(@"xiao");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
