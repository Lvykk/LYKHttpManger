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
    [AFHttpAPIClient transferParamsType:NetworkTransferBinary];
    self.view.backgroundColor = UIColor.redColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"开始请求");
    //common/getAdvert/1
    [LYKHttpManger URL:@"common/getAdvert/1" ParamsDic:nil RquestType:NetworkRequestGet ResultClass:nil Succeed:^(NSInteger startCode, NSString * _Nonnull message, id  _Nonnull resultObj) {
        NSLog(@"code = %ld ,message = %@ , data = %@",startCode,message,resultObj);
        UIAlertController *controllrr = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [controllrr addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [AFHttpAPIClient setTimeoutInterval:10.f];
        }]];
        [self presentViewController:controllrr animated:YES completion:nil];
    } Failure:^(NSError * _Nonnull error) {
        UIAlertController *controllrr = [UIAlertController alertControllerWithTitle:@"提示" message:error.description preferredStyle:UIAlertControllerStyleAlert];
        [controllrr addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [AFHttpAPIClient setTimeoutInterval:10.f];
        }]];
        [self presentViewController:controllrr animated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
