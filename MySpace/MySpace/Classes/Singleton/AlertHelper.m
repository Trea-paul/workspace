//
//  AlertHelper.m
//  CYSDemo
//
//  Created by Paul on 2017/5/17.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "AlertHelper.h"

@interface AlertHelper ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation AlertHelper
{
    UIViewController *viewController;
}

+ (instancetype)sharedAlertHelper
{
    static AlertHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[AlertHelper alloc] init];
    });
    return helper;
}

//+ (void)alertActionSheetWithType:(ActionSheetType)type inController:(UIViewController *)controller;
//{
//    [self alertPhotoSelectionInController:controller];
//}

- (void)alertActionSheetWithType:(ActionSheetType)type
                    inController:(UIViewController *)controller
                    alertActions:(void(^)(UIAlertController *alertController))alertActions
{
    if (type == ActionSheetTypeGender)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        alertActions(alertView);
        dispatch_async(dispatch_get_main_queue(), ^{
            [controller presentViewController:alertView animated:YES completion:nil];
        });
    }
    else if (type == ActionSheetTypePhoto)
    {
        viewController = controller;
        [self alertPhotoSelectionInController:controller];
    }
    
}

- (void)alertActionWithType:(UIAlertControllerStyle)type
                      title:(NSString *)title
                    message:(NSString *)message
               inController:(UIViewController *)controller
               alertActions:(void(^)(UIAlertController *alertController))alertActions
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:type];
    alertActions(alertView);
    dispatch_async(dispatch_get_main_queue(), ^{
        [controller presentViewController:alertView animated:YES completion:nil];
    });
}

- (void)alertPhotoSelectionInController:(UIViewController *)controller;
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"使用默认头像" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从图库选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectPhotoFromAlbum];
    }];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectPhotoFromCamera];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertView addAction:defaultAction];
    [alertView addAction:albumAction];
    [alertView addAction:cameraAction];
    [alertView addAction:cancelAction];
    
    [controller presentViewController:alertView animated:YES completion:nil];
}

- (void)selectPhotoFromAlbum
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [viewController presentViewController:imagePickerController animated:YES completion:nil];
   
}

- (void)selectPhotoFromCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"该设备不支持拍照功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [viewController presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - 照片代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:@"public.image"])
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewdidFinishPickingMediaWithImage:tempPath:)])
        {
            UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
            
            //先把图片转成NSData
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);;
            
            
            // 路径用作发送请求的参数
            NSString *imageName = [NSString stringWithFormat:@"%@_%@.jpg", @"IMG", [DateUtils currentDateStringWithFormatterString:DATE_STYLE_yyyyMMddHHmmss_file]];
            NSString *imagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:imageName];
            NSString *uploadImagePath = nil;
            uploadImagePath = imagePath;
            [imageData writeToFile:imagePath atomically:YES];
            
            [self.delegate alertViewdidFinishPickingMediaWithImage:image tempPath:imagePath];
        }
       
        
        
    }
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}





@end
