//
//  ViewController.m
//  LFPhotoKit
//
//  Created by liufei on 2019/7/17.
//  Copyright © 2019 liufei. All rights reserved.
//

#import "ViewController.h"
#import "LFPhotoKit/LFPhotoConfig/LFPhotoConfig.h"
#import "LFPhotoKit/LFPhotoLib/LFPhotoKitViewController.h"
@interface ViewController ()<LFPhotoKitViewControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImageView *tempImage;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)configUI {
    UIButton *reloadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    reloadButton.center = CGPointMake(self.view.center.x,125);
    [reloadButton addTarget:self action:@selector(handleImage:)
           forControlEvents:UIControlEventTouchUpInside];
    [reloadButton setTitle:@"选取图片" forState:UIControlStateNormal];
    reloadButton.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:reloadButton];
    tempImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 220,kScreenWidth, kScreenWidth)];
    tempImage.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:tempImage];
}

- (void)handleImage:(UIButton *)sender {
    UIImagePickerController    *pickVC = [[UIImagePickerController alloc] init];
    pickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickVC.mediaTypes = @[@"public.movie",@"public.image"];
    pickVC.delegate = self;
    pickVC.allowsEditing = NO;
    [self presentViewController:pickVC animated:YES completion:nil];
}

#pragma mark - LFPhotoKitViewControllerDelegate
- (void)photoKitController:(LFPhotoKitViewController *)photoKitController coverImage:(UIImage *)coverImage {
    tempImage.image = coverImage;

}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:NO completion:^{
        LFPhotoKitViewController *photoKitVC = [[LFPhotoKitViewController alloc] init];
        if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.movie"]) {
            NSURL *urlPath = info[UIImagePickerControllerMediaURL];
            photoKitVC.videoUrl = urlPath;
            photoKitVC.sourceType = LFPhotoKitSourceTypeVideo;
        } else {
            photoKitVC.originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            photoKitVC.sourceType = LFPhotoKitSourceTypeImage;
            
        }
        photoKitVC.delegate = self;
        [self presentViewController:photoKitVC animated:YES completion:nil];
    }];
 
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
