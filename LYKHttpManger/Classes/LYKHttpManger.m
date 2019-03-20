//
//  LYKHttpManger.m
//  AFNetworking
//
//  Created by Lvyk on 2019/3/19.
//

#import "LYKHttpManger.h"
#import "LYKHttpBaseModel.h"
#import <YYKit/YYKit.h>

@implementation LYKHttpManger

///获取单例,此处使用单例方式是为方便出现根据条件使用域名情况时方便切换
+ (instancetype)sharedBaseHttpTool {
    static LYKHttpManger *sharedBaseHttpTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBaseHttpTool = [[self alloc] init];
    });
    return sharedBaseHttpTool;
}

/**
 负责基础请求,不需要上传文件
 @param url         请求地址
 params      请求参数
 encryptionParams 加密的参数,添加了Token
 type        请求的类型,GET,POST,HEAD,DELE
 progress    请求进度的回调,可不传
 succeed     请求成功的回调,注意---Head请求,返回的类型是NSURLSessionDataTask
 failure     请求失败的回调
 */
+ (__kindof NSURLSessionTask *)URL:(NSString*)url Params:(id)params RquestType:(NetworkRequestType)type ResultClass:(nullable Class)resultClass Succeed:(nullable SucceedBlock)succeed Failure:(nullable FailureBlock)failure {
    return [self URL:url ParamsDic:[params modelToJSONObject] RquestType:type ResultClass:resultClass Succeed:succeed Failure:failure];
}

+ (__kindof NSURLSessionTask *)URL:(NSString*)url ParamsDic:(nullable NSDictionary*)params RquestType:(NetworkRequestType)type ResultClass:(nullable Class)resultClass Succeed:(nullable SucceedBlock)succeed Failure:(nullable FailureBlock)failure {
    return [self URL:url ParamsDic:params RquestType:type ResultClass:resultClass Progress:nil Succeed:succeed Failure:failure];
}

+ (__kindof NSURLSessionTask *)URL:(NSString*)url ParamsDic:(nullable NSDictionary*)params RquestType:(NetworkRequestType)type ResultClass:(nullable Class)resultClass Progress:(nullable ProgressBlock)progress Succeed:(nullable SucceedBlock)succeed Failure:(nullable FailureBlock)failure {
    return [self URL:url ParamsDic:params RquestType:type ResultClass:resultClass Headers:nil Progress:progress Succeed:succeed Failure:failure];
}

+ (__kindof NSURLSessionTask *)URL:(NSString*)url ParamsDic:(nullable NSDictionary*)params RquestType:(NetworkRequestType)type ResultClass:(nullable Class)resultClass Headers:(nullable NSDictionary<NSString*,NSString*>*)headers Progress:(nullable ProgressBlock)progress Succeed:(nullable SucceedBlock)succeed Failure:(nullable FailureBlock)failure {
    NSURLSessionTask *task = [[AFHttpAPIClient sharedClient] startRequestWithType:type URL:[HttpToolManger.serviceIP stringByAppendingString:url] Params:params Headers:headers Progress:progress Succeed:^(id resultObj) {
        if (type==NetworkRequestHead) {//NetworkRequestHead,不做任何处理
            succeed(0,@"请求方式d是Head",resultObj);
        } else {
            [self networkSuccessWithResultClass:resultClass JsonData:resultObj Success:succeed];
        }
    } Failure:failure];
    return task;
}

/**
 负责基础请求,需要上传文件
 @param url 请求地址
 params      请求参数
 headers     请求头参数
 body        上传文件的回调
 progress    请求进度的回调,可不传
 succeed     请求成功的回调,注意---Head请求,返回的类型是NSURLSessionDataTask
 failure     请求失败的回调
 */
+ (__kindof NSURLSessionTask *)POST:(NSString*)url Params:(id)params ResultClass:(nullable Class)resultClass Body:(BodyBlock)body Progress:(nullable ProgressBlock)progress Succeed:(nullable SucceedBlock)succeed Failure:(nullable FailureBlock)failure {
    return [self POST:url ParamsDic:[params modelToJSONObject] ResultClass:resultClass Body:body Progress:progress Succeed:succeed Failure:failure];
}

+ (__kindof NSURLSessionTask *)POST:(NSString*)url ParamsDic:(nullable NSDictionary*)params ResultClass:(nullable Class)resultClass Body:(BodyBlock)body Progress:(nullable ProgressBlock)progress Succeed:(nullable SucceedBlock)succeed Failure:(nullable FailureBlock)failure {
    return [self POST:url ParamsDic:params ResultClass:resultClass Headers:nil Body:body Progress:progress Succeed:succeed Failure:failure];
}

+ (__kindof NSURLSessionTask *)POST:(NSString*)url ParamsDic:(nullable NSDictionary*)params ResultClass:(nullable Class)resultClass Headers:(nullable NSDictionary<NSString*,NSString*>*)headers Body:(BodyBlock)body Progress:(nullable ProgressBlock)progress Succeed:(nullable SucceedBlock)succeed Failure:(nullable FailureBlock)failure {
    NSURLSessionTask *task = [[AFHttpAPIClient sharedClient] startRequestWithURL:[HttpToolManger.serviceIP stringByAppendingString:url] Params:params Headers:headers Body:body Progress:progress Succeed:^(id resultObj) {
        [self networkSuccessWithResultClass:resultClass JsonData:resultObj Success:succeed];
    } Failure:failure];
    return task;
}

#pragma mark ----------------公用的模型转换---------------------
+ (void)networkSuccessWithResultClass:(nullable Class)resultClass JsonData:(id)resultObj Success:(SucceedBlock)success{
    if (success) {
        LYKHttpBaseModel *model = [LYKHttpBaseModel modelWithJSON:resultObj];
        if (resultClass) {//传入类型存在,进行模型转换
            if ([model.data isKindOfClass:[NSArray class]]) {//数组转模型数组
                success([model.code integerValue],model.message,[NSArray modelArrayWithClass:resultClass json:model.data]);
            } else {
                success([model.code integerValue],model.message,[resultClass modelWithJSON:model.data]);
            }
        } else {
            success([model.code integerValue],model.message,model.data);
        }
    }
}

@end
