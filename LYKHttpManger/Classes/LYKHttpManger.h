//
//  LYKHttpManger.h
//  AFNetworking
//
//  Created by Lvyk on 2019/3/19.
//

#import <Foundation/Foundation.h>
#import "AFHttpAPIClient.h"
#import <YYKit/YYKit.h>

NS_ASSUME_NONNULL_BEGIN

//获取单例
#define HttpToolManger [LYKHttpManger sharedBaseHttpTool]

@protocol LYKHttpMangerProtocol <NSObject>
@required
///模型转换的方法,抽离到协议中,需要自定的只需要继承LYKHttpManger并重写改方法即可
+ (void)networkSuccessWithResultClass:(nullable Class)resultClass JsonData:(id)resultObj Success:(SucceedBaseBlock)success;
@end

@interface LYKHttpManger : NSObject<LYKHttpMangerProtocol>
/**服务器地址*/
@property (nonatomic,copy) NSString *serviceIP;
///获取单例,此处使用单例方式是为方便出现根据条件使用域名情况时方便切换
+ (instancetype)sharedBaseHttpTool;

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
+ (__kindof NSURLSessionTask *)URL:(NSString*)url Params:(id)params RquestType:(NetworkRequestType)type ResultClass:(nullable Class)resultClass Succeed:(nullable SucceedBaseBlock)succeed Failure:(nullable FailureBlock)failure;
+ (__kindof NSURLSessionTask *)URL:(NSString*)url ParamsDic:(nullable NSDictionary*)params RquestType:(NetworkRequestType)type ResultClass:(nullable Class)resultClass Succeed:(nullable SucceedBaseBlock)succeed Failure:(nullable FailureBlock)failure;
+ (__kindof NSURLSessionTask *)URL:(NSString*)url ParamsDic:(nullable NSDictionary*)params RquestType:(NetworkRequestType)type ResultClass:(nullable Class)resultClass Progress:(nullable ProgressBlock)progress Succeed:(nullable SucceedBaseBlock)succeed Failure:(nullable FailureBlock)failure;
+ (__kindof NSURLSessionTask *)URL:(NSString*)url ParamsDic:(nullable NSDictionary*)params RquestType:(NetworkRequestType)type ResultClass:(nullable Class)resultClass Headers:(nullable NSDictionary<NSString*,NSString*>*)headers Progress:(nullable ProgressBlock)progress Succeed:(nullable SucceedBaseBlock)succeed Failure:(nullable FailureBlock)failure;

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
+ (__kindof NSURLSessionTask *)POST:(NSString*)url Params:(id)params ResultClass:(nullable Class)resultClass Body:(BodyBlock)body Progress:(nullable ProgressBlock)progress Succeed:(nullable SucceedBaseBlock)succeed Failure:(nullable FailureBlock)failure;
+ (__kindof NSURLSessionTask *)POST:(NSString*)url ParamsDic:(nullable NSDictionary*)params ResultClass:(nullable Class)resultClass Body:(BodyBlock)body Progress:(nullable ProgressBlock)progress Succeed:(nullable SucceedBaseBlock)succeed Failure:(nullable FailureBlock)failure;
+ (__kindof NSURLSessionTask *)POST:(NSString*)url ParamsDic:(nullable NSDictionary*)params ResultClass:(nullable Class)resultClass Headers:(nullable NSDictionary<NSString*,NSString*>*)headers Body:(BodyBlock)body Progress:(nullable ProgressBlock)progress Succeed:(nullable SucceedBaseBlock)succeed Failure:(nullable FailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
