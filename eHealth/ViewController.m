//
//  ViewController.m
//  eHealth
//
//  Created by Ezra Kirsh on 2016-03-05.
//  Copyright © 2016 Ezra Kirsh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    capturedObjects = [NSMutableArray array];
    currentItems = [NSMutableArray array];
    
    capturedObjects = [NSMutableArray array];
    currentItems = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentItems"]];
    
    barcodeView = [[UIView alloc] init];
    barcodeView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    barcodeView.layer.borderColor = [UIColor greenColor].CGColor;
    barcodeView.layer.borderWidth = 3;
    [self.view addSubview:barcodeView];
    
    UISwipeGestureRecognizer *rec = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    rec.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:rec];
    
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"(none)";
    [self.view addSubview:label];
    
    session = [[AVCaptureSession alloc] init];
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (input) {
        [session addInput:input];
    }
    else {
        NSLog(@"Error: %@", error);
    }
    
    output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session addOutput:output];
    
    output.metadataObjectTypes = [output availableMetadataObjectTypes];
    
    prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    prevLayer.frame = self.view.bounds;
    prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:prevLayer];
    
    [session startRunning];
    
    [self.view bringSubviewToFront:label];
    [self.view bringSubviewToFront:barcodeView];
}

-(void)swipeLeft {
    NSLog(@"Swiping");
    [self performSegueWithIdentifier:@"swipeLeft" sender:self];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSArray *allowedTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code];
    NSString *detectionString = nil;
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in allowedTypes) {
            if (metadata.type == type) {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)metadata;
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                
                if (detectionString != nil)
                {
                    if (![capturedObjects containsObject:detectionString]) {
                        [self getFood:detectionString];
                        [capturedObjects addObject:detectionString];
                        [[NSUserDefaults standardUserDefaults] setObject:capturedObjects forKey:@"capturedObjects"];

                    }
                    break;
                }
                else {
                    label.text = @"(none)";
                }
                break;
            }
        }
    }
    
    barcodeView.frame = highlightViewRect;
}

-(void)getFood:(NSString *)code {
    NSError *error;
    NSString *url_string = [NSString stringWithFormat: @"https://api.nutritionix.com/v1_1/item?upc=%@&appId=a0233af0&appKey=88b347d6b0d96281422718d5b3889cde", code];
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *item = json[@"item_name"];
    label.text = item;
    [currentItems addObject:item];
    [[NSUserDefaults standardUserDefaults] setObject:currentItems forKey:@"currentItems"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
