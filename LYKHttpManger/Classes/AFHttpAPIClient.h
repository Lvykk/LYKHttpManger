//
//  AFHttpAPIClient.h
//  AFNetworking
//
//  Created by Lvyk on 2019/3/19.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

/**网络类型的枚举*/
typedef NS_ENUM(NSUInteger, NetworkStatusType) {
    /// 未知网络
    NetworkStatusUnknown,
    /// 无网络
    NetworkStatusNotReachable,
    /// 手机网络
    NetworkStatusReachableViaWWAN,
    /// WIFI网络
    NetworkStatusReachableViaWiFi
};

/**请求类型的枚举*/
typedef NS_ENUM(NSUInteger, NetworkRequestType) {
    /// Get请求
    NetworkRequestGet,
    /// PUT请求
    NetworkRequestPut,
    /// Head请求,返回的类型是NSURLSessionDataTask
    NetworkRequestHead,
    /// DELEGATE请求
    NetworkRequestDelete,
    /// POST请求
    NetworkRequestPost,
    /// PATCH请求
    NetworkRequestPatch
};

/**请求数据传输方式*/
typedef NS_ENUM(NSInteger,NetworkResponseDataType) {
    NetworkResponseData_JSON,
    NetworkResponseData_Binary,
    NetworkResponseData_XML
};

#pragma mark ----------------block---------------------
/**文件上传对象的Block*/
typedef void (^BodyBlock)(id <AFMultipartFormData> formData);
/**进度的Block*/
typedef void (^ProgressBlock)(NSProgress *downloadProgress);
/**最基本的返回数据,Head请求,返回的类型是NSURLSessionDataTask*/
typedef void (^SucceedBaseBlock)(id resultObj);
/**错误的Block*/
typedef void (^FailureBlock)(NSError *error);
/// 网络状态的Block
typedef void(^NetworkStatus)(NetworkStatusType status);

@interface AFHttpAPIClient : AFHTTPSessionManager
/** 请求数据传输方式,默认是JSON传输  */
@property (nonatomic,assign,class) NetworkResponseDataType responseDataType;
/**获取单例*/
+ (instancetype)sharedClient;
/**有网YES, 无网:NO*/
+ (BOOL)isNetwork;
/** 手机网络:YES, 反之:NO */
+ (BOOL)isWWANNetwork;
/** WiFi网络:YES, 反之:NO */
+ (BOOL)isWiFiNetwork;
/** 实时获取网络状态,通过Block回调实时获取(此方法可多次调用) */
+ (void)networkStatusWithBlock:(NetworkStatus)networkStatus;
/** 设置ContentTypes  */
+ (void)setContentTypes:(NSSet<NSString*>*)contentTypes;
/** 设置请求超时的时间,默认是20s   */
+ (void)setTimeoutInterval:(float)time;
/**
 配置自建证书的Https请求
 @param cerFilePath 自建Https证书的路径
 @param validatesDomainName 是否需要验证域名，默认为YES. 如果证书的域名与请求的域名不一致，需设置为NO; 即服务器使用其他可信任机构颁发
 的证书，也可以建立连接，这个非常危险, 建议打开.validatesDomainName=NO, 主要用于这种情况:客户端请求的是子域名, 而证书上的是另外
 一个域名。因为SSL证书上的域名是独立的,假如证书上注册的域名是www.google.com, 那么mail.google.com是无法验证通过的.
 */
+ (void)setSecurityPolicyWithCerFilePath:(NSString *)cerFilePath ValidatesDomainName:(BOOL)validatesDomainName;

/**
 基础的网络请求
 @param type 请求类型
 url 请求地址
 params 请求参数
 headers 请求头
 succeed 成功的回调
 failure 失败的回调
 */
- (__kindof NSURLSessionTask *)startRequestWithType:(NetworkRequestType)type URL:(NSString*)url Params:(id)params Headers:(nullable NSDictionary<NSString*,NSString*>*)headers Succeed:(SucceedBaseBlock)succeed Failure:(FailureBlock)failure;

/**
 基础的网络请求,需要有进度的回调
 @param type 请求类型
 url 请求地址
 params 请求参数
 headers 请求头
 progress 进度的回调
 succeed 成功的回调
 failure 失败的回调
 */
- (__kindof NSURLSessionTask *)startRequestWithType:(NetworkRequestType)type URL:(NSString*)url Params:(id)params Headers:(NSDictionary<NSString*,NSString*>*)headers Progress:(nullable ProgressBlock)progress Succeed:(SucceedBaseBlock)succeed Failure:(FailureBlock)failure;

/**
 基础的网络请求,需要上传文件
 @param url     请求地址
 params  请求参数
 headers 请求头
 body    设置需要上传文件的回调
 succeed 成功的回调
 failure 失败的回调
 */
- (__kindof NSURLSessionTask *)startRequestWithURL:(NSString*)url Params:(id)params Headers:(NSDictionary<NSString*,NSString*>*)headers Body:(BodyBlock)body Succeed:(SucceedBaseBlock)succeed Failure:(FailureBlock)failure;

/**
 基础的网络请求,需要上传文件
 @param url     请求地址
 params  请求参数
 headers 请求头
 body    设置需要上传文件的回调
 progress 进度的回调
 succeed 成功的回调
 failure 失败的回调
 */
- (__kindof NSURLSessionTask *)startRequestWithURL:(NSString*)url Params:(id)params Headers:(NSDictionary<NSString*,NSString*>*)headers Body:(BodyBlock)body Progress:(nullable ProgressBlock)progress Succeed:(SucceedBaseBlock)succeed Failure:(FailureBlock)failure;

/**
 下载文件的请求
 @param     URL     请求地址
            fileDir  文件存储目录(默认存储目录为Download)
            progress 进度的回调
            succeed 成功的回调,返回的是完整的URL字符串(文件路径)
            failure 失败的回调
 */
- (__kindof NSURLSessionTask *)startDownloadWithURL:(NSString *)URL FileDir:(NSString *)fileDir Progress:(nullable ProgressBlock)progress Success:(SucceedBaseBlock)success Failure:(FailureBlock)failure;

/**
 下载文件的请求
 @param     URL     请求地址
 fileDir  文件存储目录(默认存储目录为Download)
 headers 请求头
 progress 进度的回调
 succeed 成功的回调,返回的是完整的URL字符串(文件路径)
 failure 失败的回调
 */
- (__kindof NSURLSessionTask *)startDownloadWithURL:(NSString *)URL FileDir:(NSString *)fileDir Headers:(nullable NSDictionary<NSString*,NSString*>*)headers Progress:(nullable ProgressBlock)progress Success:(SucceedBaseBlock)success Failure:(FailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
