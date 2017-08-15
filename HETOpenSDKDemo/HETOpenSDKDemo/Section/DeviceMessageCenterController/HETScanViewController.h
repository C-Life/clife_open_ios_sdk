//
//  HETScanViewController.h
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/7/12.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import "HETBaseViewController.h"
#import <AVFoundation/AVFoundation.h>

typedef void (^FinishingBlock)(NSString *string);


@interface HETScanViewController : HETBaseViewController<AVCaptureMetadataOutputObjectsDelegate>

{
    FinishingBlock _finishingBlock;
    UIView *_scanLayer;
}



@property(strong,nonatomic) AVCaptureSession *session;
@property(strong,nonatomic)  AVCaptureVideoPreviewLayer *previewLayer;
@property(strong, nonatomic) UIView *scanRectView;

- (void)finishingBlock:(FinishingBlock)finishingBlock;
@end
