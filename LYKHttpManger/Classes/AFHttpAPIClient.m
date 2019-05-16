//
//  AFHttpAPIClient.m
//  AFNetworking
//
//  Created by Lvyk on 2019/3/19.
//

#import "AFHttpAPIClient.h"

static AFHttpAPIClient *_sharedClient = nil;

@implementation AFHttpAPIClient

/**获取单例*/
+ (instancetype)sharedClient {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [super manager];
        //设置contentTypes
        NSSet <NSString*>* set = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
        _sharedClient.responseSerializer.acceptableContentTypes = set;
        //设置请求数据为JSON格式传输
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置超时时间
        [_sharedClient.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _sharedClient.requestSerializer.timeoutInterval = 20.f;
        [_sharedClient.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        // 启动网络检测
        [_sharedClient.reachabilityManager startMonitoring];
    });
    return _sharedClient;
}

/**有网YES, 无网:NO*/
+ (BOOL)isNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

/** 手机网络:YES, 反之:NO */
+ (BOOL)isWWANNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

/** WiFi网络:YES, 反之:NO */
+ (BOOL)isWiFiNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

#pragma mark - 开始监听网络
+ (void)networkStatusWithBlock:(NetworkStatus)networkStatus {
    
    [[[self sharedClient] reachabilityManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                networkStatus ? networkStatus(NetworkStatusUnknown) : nil;
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus ? networkStatus(NetworkStatusNotReachable) : nil;
                NSLog(@"无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus ? networkStatus(NetworkStatusReachableViaWWAN) : nil;
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus ? networkStatus(NetworkStatusReachableViaWiFi) : nil;
                NSLog(@"WIFI");
                break;
        }
    }];
}

#pragma mark ----------------Set Method---------------------

/** 设置ContentTypes  */
+ (void)setContentTypes:(NSSet<NSString*>*)contentTypes {
    [AFHttpAPIClient sharedClient].responseSerializer.acceptableContentTypes = contentTypes;
}

/** 请求数据传输方式,默认是JSON传输*/
+ (void)transferParamsType:(NetworkTransferType)type {
    if (type == NetworkTransferJSON) {
        //JSON格式
        [AFHttpAPIClient sharedClient].requestSerializer = [AFJSONRequestSerializer serializer];
    } else if (type == NetworkTransferBinary) {
        //二进制
        [AFHttpAPIClient sharedClient].requestSerializer = [AFHTTPRequestSerializer serializer];
    }
}

/** 设置请求超时的时间   */
+ (void)setTimeoutInterval:(float)time {
    [[AFHttpAPIClient sharedClient].requestSerializer willChangeValueForKey:@"timeoutInterval"];
    [AFHttpAPIClient sharedClient].requestSerializer.timeoutInterval = time;
    [[AFHttpAPIClient sharedClient].requestSerializer didChangeValueForKey:@"timeoutInterval"];
}

/**
 配置自建证书的Https请求
 @param cerFilePath 自建Https证书的路径
 @param validatesDomainName 是否需要验证域名，默认为YES. 如果证书的域名与请求的域名不一致，需设置为NO; 即服务器使用其他可信任机构颁发
 的证书，也可以建立连接，这个非常危险, 建议打开.validatesDomainName=NO, 主要用于这种情况:客户端请求的是子域名, 而证书上的是另外
 一个域名。因为SSL证书上的域名是独立的,假如证书上注册的域名是www.google.com, 那么mail.google.com是无法验证通过的.
 */
+ (void)setSecurityPolicyWithCerFilePath:(NSString *)cerFilePath ValidatesDomainName:(BOOL)validatesDomainName {
    NSData *cerData = [NSData dataWithContentsOfFile:cerFilePath];
    // 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 如果需要验证自建证书(无效证书)，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    // 是否需要验证域名，默认为YES;
    securityPolicy.validatesDomainName = validatesDomainName;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    [_sharedClient setSecurityPolicy:securityPolicy];
}

#pragma mark ----------------Request Method---------------------
/**
 基础的网络请求
 @param type 请求类型
 url 请求地址
 params 请求参数
 headers 请求头
 succeed 成功的回调
 failure 失败的回调
 */
- (__kindof NSURLSessionTask *)startRequestWithType:(NetworkRequestType)type URL:(NSString*)url Params:(id)params Headers:(nullable NSDictionary<NSString*,NSString*>*)headers Succeed:(SucceedBaseBlock)succeed Failure:(FailureBlock)failure {
    return [self startRequestWithType:type URL:url Params:params Headers:headers Progress:nil Succeed:succeed Failure:failure];
}

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
- (__kindof NSURLSessionTask *)startRequestWithType:(NetworkRequestType)type URL:(NSString*)url Params:(id)params Headers:(NSDictionary<NSString*,NSString*>*)headers Progress:(nullable ProgressBlock)progress Succeed:(SucceedBaseBlock)succeed Failure:(FailureBlock)failure {
    if (!([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"])) {
        NSLog(@"域名不是以'http://'或'https://'开头,请检查是否设置了域名");
        failure([NSError errorWithDomain:NSURLErrorDomain code:1009 userInfo:@{NSLocalizedDescriptionKey:@"域名错误,请检查域名"}]);
        return nil;
    }
    //添加请求头
    [self addHeaders:headers];
    NSURLSessionTask *task = nil;
    //开始请求
    switch (type) {
        case NetworkRequestGet:
            //Get请求
            task =[self GETWithURL:url Params:params Progress:progress Succeed:succeed Failure:failure];
            break;
            
        case NetworkRequestPut:
            //Put请求
            task =[self PUTWithURL:url Params:params Succeed:succeed Failure:failure];
            break;
            
        case NetworkRequestHead:
            //Head请求
            task =[self HEADWithURL:url Params:params Succeed:succeed Failure:failure];
            break;
            
        case NetworkRequestDelete:
            //Delete请求
            task =[self DELETEWithURL:url Params:params Progress:progress Succeed:succeed Failure:failure];
            break;
            
        case NetworkRequestPost:
            //Post请求
            task =[self POSTWithURL:url Params:params Progress:progress Succeed:succeed Failure:failure];
            break;
            
        default:
            break;
    }
    return task;
}

/**
 基础的网络请求,需要上传文件
 @param url     请求地址
 params  请求参数
 headers 请求头
 body    设置需要上传文件的回调
 succeed 成功的回调
 failure 失败的回调
 */
- (__kindof NSURLSessionTask *)startRequestWithURL:(NSString*)url Params:(id)params Headers:(NSDictionary<NSString*,NSString*>*)headers Body:(BodyBlock)body Succeed:(SucceedBaseBlock)succeed Failure:(FailureBlock)failure {
    return [self startRequestWithURL:url Params:params Headers:headers Body:body Progress:nil Succeed:succeed Failure:failure];
}

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
- (__kindof NSURLSessionTask *)startRequestWithURL:(NSString*)url Params:(id)params Headers:(NSDictionary<NSString*,NSString*>*)headers Body:(BodyBlock)body Progress:(nullable ProgressBlock)progress Succeed:(SucceedBaseBlock)succeed Failure:(FailureBlock)failure {
    //添加请求头
    [self addHeaders:headers];
    return [self POSTWithURL:url Params:params Progress:progress Body:body Succeed:succeed Failure:failure];
}

/**
 下载文件的请求
 @param     URL     请求地址
 fileDir  文件存储目录(默认存储目录为Download)
 headers 请求头
 progress 进度的回调
 succeed 成功的回调
 failure 失败的回调
 */
- (__kindof NSURLSessionTask *)startDownloadWithURL:(NSString *)URL FileDir:(NSString *)fileDir Progress:(nullable ProgressBlock)progress Success:(SucceedBaseBlock)success Failure:(FailureBlock)failure {
    return [self startDownloadWithURL:URL FileDir:fileDir Headers:nil Progress:progress Success:success Failure:failure];
}

- (__kindof NSURLSessionTask *)startDownloadWithURL:(NSString *)URL FileDir:(NSString *)fileDir Headers:(nullable NSDictionary<NSString*,NSString*>*)headers Progress:(nullable ProgressBlock)progress Success:(SucceedBaseBlock)success Failure:(FailureBlock)failure {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    NSURLSessionTask *task = [_sharedClient downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (failure && error) {
            failure(error);
            [self logAddress:URL parameters:nil];
            return;
        }
        if (success && filePath) {
            success(filePath.absoluteString);
        }
    }];
    //开始下载
    [task resume];
    return task;
}



#pragma mark ----------------Get请求---------------------
- (__kindof NSURLSessionTask *)GETWithURL:(NSString*)url Params:(id)params Progress:(ProgressBlock)progress Succeed:(SucceedBaseBlock)succeed Failure:(FailureBlock)failure {
    NSURLSessionTask *task = [self GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (succeed) {
            succeed(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        [self logAddress:url parameters:params];
    }];
    return task;
}

#pragma mark ----------------Put请求---------------------
- (__kindof NSURLSessionTask *)PUTWithURL:(NSString*)url Params:(id)params Succeed:(SucceedBaseBlock)succeed Failure:(FailureBlock)failure {
    NSURLSessionTask *task = [self PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (succeed) {
            succeed(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        [self logAddress:url parameters:params];
    }];
    return task;
}

#pragma mark ----------------Header请求---------------------
- (__kindof NSURLSessionTask *)HEADWithURL:(NSString*)url Params:(id)params Succeed:(SucceedBaseBlock)succeed Failure:(FailureBlock)failure {
    NSURLSessionTask *task = [self HEAD:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task) {
        if (succeed) {
            succeed(task);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        [self logAddress:url parameters:params];
    }];
    return task;
}

#pragma mark ----------------Delate请求---------------------
- (__kindof NSURLSessionTask *)DELETEWithURL:(NSString*)url Params:(id)params Progress:(ProgressBlock)progress Succeed:(SucceedBaseBlock)succeed Failure:(FailureBlock)failure {
    NSURLSessionTask *task = [self DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (succeed) {
            succeed(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        [self logAddress:url parameters:params];
    }];
    return task;
}

#pragma mark ----------------Post请求---------------------
- (__kindof NSURLSessionTask *)POSTWithURL:(NSString*)url Params:(id)params Progress:(ProgressBlock)progress Succeed:(SucceedBaseBlock)succeed Failure:(FailureBlock)failure {
    NSURLSessionTask *task = [self POST:url parameters:params progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (succeed) {
            succeed(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        [self logAddress:url parameters:params];
    }];
    return task;
}

- (__kindof NSURLSessionTask *)POSTWithURL:(NSString*)url Params:(id)params Progress:(ProgressBlock)progress Body:(BodyBlock)body Succeed:(SucceedBaseBlock)succeed Failure:(FailureBlock)failure {
    if (!([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"])) {
        NSLog(@"域名不是以'http://'或'https://'开头,请检查是否设置了域名");
        failure([NSError errorWithDomain:NSURLErrorDomain code:1009 userInfo:@{NSLocalizedDescriptionKey:@"域名错误,请检查域名"}]);
        return nil;
    }
    NSURLSessionTask *task = [self POST:url parameters:params constructingBodyWithBlock:body progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (succeed) {
            succeed(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        [self logAddress:url parameters:params];
    }];
    return task;
}

#pragma mark ----------------添加请求头---------------------
- (void)addHeaders:(NSDictionary<NSString*,NSString*>*)headers {
    for (NSString *key in headers) {
        [self.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
    }
}

//error失败打印
-(void)logAddress:(NSString *)url parameters:(NSDictionary *)params{
    NSMutableString *string=[[NSMutableString alloc] initWithString:url];
    [string appendString:@"?"];
    NSEnumerator *enumerator=[params keyEnumerator];
    id key=[enumerator nextObject];
    while (key) {
        id obj=[params objectForKey:key];
        [string appendFormat:@"%@=%@&",key,obj];
        key=[enumerator nextObject];
    }
    
    [string deleteCharactersInRange:NSMakeRange(string.length-1, 1)];
    NSLog(@"请求失败》地址:%@",string);
}

@end
