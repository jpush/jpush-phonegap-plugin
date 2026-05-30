//
//  JGInforCollectionAuth.h
//  JCore
//
//  Created by 豆瓣 on 2021/10/27.
//  Copyright © 2021 jiguang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 合规接口，是否授权极光采集一定的设备信息
@interface JGInforCollectionAuthItems : NSObject
/// 是否授权，默认YES
@property(nonatomic,assign)BOOL isAuth;
@end

@interface JGInforCollectionAuth : NSObject

/// 设备信息采集授权接口（合规接口）
/// 请务必在调用初始化、功能性接口前调用此接口进行合规授权
/// @param authBlock auth:YES 则极光认为您同意极光采集一定的设备信息
+(void)JCollectionAuth:(void(^_Nullable)(JGInforCollectionAuthItems *authInfo))authBlock;
@end

NS_ASSUME_NONNULL_END
