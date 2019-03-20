//
//  LYKHttpBaseModel.h
//  LYKHttpManger_Example
//
//  Created by Lvyk on 2019/3/19.
//  Copyright © 2019 kkk901029@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYKHttpBaseModel : NSObject

/**NSString: 状态*/
@property(nonatomic, copy) NSString *code;
/**NSString: 信息*/
@property(nonatomic, copy) NSString *message;
/**NSDictionary: 数据*/
@property(nonatomic, weak) id data;

@end

NS_ASSUME_NONNULL_END
