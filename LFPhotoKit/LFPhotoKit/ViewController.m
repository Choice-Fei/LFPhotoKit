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
    UIButton *reloadButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [reloadButton addTarget:self action:@selector(handleImage:) forControlEvents:UIControlEventTouchUpInside];
    reloadButton.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:reloadButton];
    tempImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 220,kScreenWidth, kScreenWidth)];
    [self.view addSubview:tempImage];
    // Do any additional setup after loading the view, typically from a nib.
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


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}


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
