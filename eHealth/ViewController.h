//
//  ViewController.h
//  eHealth
//
//  Created by Ezra Kirsh on 2016-03-05.
//  Copyright © 2016 Ezra Kirsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate> {
    AVCaptureSession *session;
    AVCaptureDevice *device;
    AVCaptureDeviceInput *input;
    AVCaptureMetadataOutput *output;
    AVCaptureVideoPreviewLayer *prevLayer;
    UIView *barcodeView;
    UILabel *label;
    NSMutableArray *capturedObjects;
    NSMutableArray *currentItems;
}


@end

