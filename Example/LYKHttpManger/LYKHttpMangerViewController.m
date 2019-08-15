//
//  LYKHttpMangerViewController.m
//  LYKHttpManger
//
//  Created by kkk901029@163.com on 03/19/2019.
//  Copyright (c) 2019 kkk901029@163.com. All rights reserved.
//

#import "LYKHttpMangerViewController.h"
#import "LYKHttpManger.h"

@interface LYKHttpMangerViewController ()

@end

@implementation LYKHttpMangerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [LYKHttpManger sharedBaseHttpTool].serviceIP = @"https://fll.caihong0574.com/client/";
    [AFHttpAPIClient setContentTypes:[NSSet setWithObjects:@"application/javascript", nil]];
//    NSLog(@"type = %ld",AFHttpAPIClient.responseDataType);
//    [AFHttpAPIClient transferParamsType:NetworkTransferBinary];
    self.view.backgroundColor = UIColor.redColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"开始请求");
    //common/getAdvert/1
//    [AFHttpAPIClient setResponseSerializeType:NetworkResponseData_Binary];
//    [AFHttpAPIClient setRequestSerializeType:NetworkRequestData_Binary];
    long long nowTime = [NSDate date].timeIntervalSince1970*1000.f;
    NSString *url = [NSString stringWithFormat:@"https://suggest3.sinajs.cn/suggest/type=&key=%@&name=suggestdata_%@",@"wk",@(nowTime)];
//    [LYKHttpManger URL:url ParamsDic:nil RquestType:NetworkRequestGet ResultClass:nil Succeed:^(id  _Nonnull resultObj) {
//        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//        NSLog(@"resultObj = %@",[[NSString alloc] initWithData:resultObj encoding:encoding]);
//    } Failure:^(NSError * _Nonnull error) {
//        NSLog(@"error = %@",error);
//    }];
//    NSLog(@"type = %ld",AFHttpAPIClient.responseDataType);
    AFHttpAPIClient.responseDataType = NetworkResponseData_Binary;
    [LYKHttpManger URL:url ParamsDic:nil RquestType:NetworkRequestGet ResultClass:nil Succeed:^(id  _Nonnull resultObj) {
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSLog(@"resultObj = %@",[[NSString alloc] initWithData:resultObj encoding:encoding]);
    } Failure:^(NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
    
//    NSLog(@"type = %ld",AFHttpAPIClient.responseDataType);
//    AFHttpAPIClient.responseDataType = NetworkResponseData_JSON;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
