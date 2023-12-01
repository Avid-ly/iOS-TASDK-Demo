//
//  TraceAnalysis.h

//
//  Created by samliu on 2017/7/4.
//  Copyright © 2017年 samliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TraceAnalysisDebug.h"
#import "TraceAnalysisVersion.h"

@interface TraceAnalysis : NSObject

#pragma mark - Init（初始化）

/**
 SDK初始化
 
 @param productId 分配的产品编号
 @param channelId 渠道编号
 @param appId     "id" + Apple ID
 */
+ (void)initWithProductId:(NSString *)productId ChannelId:(NSString *)channelId AppID:(NSString *)appId;

/**
 SDK初始化
 
 @param productId 分配的产品编号
 @param channelId 渠道编号
 @param appId     "id" + Apple ID
 @param completionBlock 初始化完成回调（当error有值或staToken为空时，表示初始化失败）
 */
+ (void)initWithProductId:(NSString *)productId ChannelId:(NSString *)channelId AppID:(NSString *)appId completion:(void (^)(NSError *error, NSString *staToken))completionBlock;

#pragma mark - Privacy

/**
 * This method is called when the user refuses to obtain privacy information.
 */
+ (void)disableAccessPrivacyInformation;

#pragma mark - Util

/**
 获取SDK版本
 
 @return 版本号
 */
+ (NSString *)SDKVersion;

/**
 获取统计包token
 
 @return 统计包token
 */
+ (NSString *)staToken;

/**
 获取统计包OpenId
 
 @return 统计包OpenId
 */
+ (NSString *)getOpenId;

/**
 设置扩展参数
 
 @param ext 扩展参数
 */
+ (void)setExt:(NSDictionary *)ext;


/**
 追加扩展参数
 
 @param addExt 需要追加的扩展参数，如与已有的扩展参数冲突，则覆盖冲突部分
 */
+ (void)addExt:(NSDictionary *)addExt;

/**
 设置appsFlyerId
 
 @param appsFlyerId         appsFlyerId
 */
+ (void)setAppsFlyerId:(NSString *)appsFlyerId;

/**
 设置FirebaseId
 
 @param firebaseId         [FIRAnalytics appInstanceID]
 */
+ (void)setFirebaseId:(NSString *)firebaseId;

#pragma mark - Log（打点）

/**
 keyValue 打点
 以即时发送的方式，实现数据上报一些重要性很高的数据
 @param key   键
 @param value 值，可以是string，array，dictionary
 */
+ (void)logWithKey:(NSString *)key value:(id)value;

/**
 keyValue 打点
 以即时发送的方式，实现数据上报
 主要用于上传一些针对异常情况的打点，例如网络异常，或程序try-catch异常等内容重复率比较大，重要性较低的数据
 @param key   键
 @param value 值，可以是string，array，dictionary
 */
+ (void)logExceptionWithKey:(NSString *)key value:(id)value;

/**
 计数打点
 
 @param key key
 */
+ (void)countWithKey:(NSString *)key;

/**
 自定义keyValue 打点
 
 @param key   键
 @param value 值
 */
+ (void)customLogWithKey:(NSString *)key value:(NSString *)value;

/**
 GAP 打点
 */
+ (void)GAPLog;

#pragma mark - Login log（登录上报）

/**
 游客登录 上报
 
 @param playerId 游戏用户ID
 */
+ (void)guestLoginWithGameId:(NSString *)playerId;

/**
 Facebook登录 上报
 
 @param playerId  游戏用户ID
 @param openId    openId
 @param openToken openToken
 */
+ (void)facebookLoginWithGameId:(NSString *)playerId
                         OpenId:(NSString *)openId
                      OpenToken:(NSString *)openToken;

/**
 twitter登录 上报
 
 @param playerId 游戏用户ID
 @param twitterId 推特用户id
 @param twitterUserName 推特用户Name
 @param twitterAuthToken 推特用户Token
 */
+ (void)twitterLoginWithPlayerId:(NSString *)playerId
                       twitterId:(int64_t)twitterId
                 twitterUserName:(NSString *)twitterUserName
                twitterAuthToken:(NSString *)twitterAuthToken;

/**
 平台登录 上报
 
 @param playerId 游戏用户ID
 @param portalId 平台Id
 */
+ (void)portalLoginWithPlayerId:(NSString *)playerId
                       portalId:(NSString *)portalId;

#pragma mark - New log Login

extern NSString *const TraceAnalysisLoginTypeGuest;
extern NSString *const TraceAnalysisLoginTypeAas;
extern NSString *const TraceAnalysisLoginTypeFacebook;
extern NSString *const TraceAnalysisLoginTypeGoogleplay;
extern NSString *const TraceAnalysisLoginTypeTwitter;
extern NSString *const TraceAnalysisLoginTypeInstagram;
extern NSString *const TraceAnalysisLoginTypeGamecenter;
extern NSString *const TraceAnalysisLoginTypeUlt;
extern NSString *const TraceAnalysisLoginTypeApple;
extern NSString *const TraceAnalysisLoginTypeEmail;
extern NSString *const TraceAnalysisLoginTypeOther;

/*
 通用登录上报
 @param loginType   登录方式
 @param playerId    游戏用户ID
 @param loginToken  登录凭证
 @param extension   扩展参数
 
 说明：
 1、loginType参数值只能从上述定义的extern字符串中选择，未支持的登录方式请使用TraceAnalysisLoginTypeOther
 2、playerId参数为游戏的用户系统中用户唯一标识
 3、loginToken为登录方式对应的校验凭证
 |--3.1）当登录方式为TraceAnalysisLoginTypeGuest时，此值可不传
 |--3.2）当登录方式为TraceAnalysisLoginTypeFacebook时，此值传facebook返回的openToken
 |--3.3）当登录方式为TraceAnalysisLoginTypeTwitter时，此值传twitter返回的信息拼接成的json字符串，格式：{"twitterId":"xx","twitterUserName":"xx","twitterAuthToken":"xx"}
 |--3.4）当登录方式为TraceAnalysisLoginTypeGamecenter时，此值传GameCenter返回的teamPlayerID或playerID
 |--3.5）当登录方式为TraceAnalysisLoginTypeApple时，此值传apple返回的identityToken字符串
 |--3.6）当登录方式为TraceAnalysisLoginTypeOther时，此值传对应的登录方式返回的能校验用户合法性的对应参数
 |--3.7）当登录方式为TraceAnalysisLoginTypeEmail时，此值传email邮箱地址
 4、extension为扩展参数，可扩展一些透传参数，选填，默认填nil
 */
+ (void)logCommonLoginWithType:(NSString *)loginType
                      playerId:(NSString *)playerId
                    loginToken:(NSString *)loginToken
                     extension:(NSDictionary <NSString *, NSString *> *)extension;

/*
 AAS登录上报
 @param loginType   登录方式
 @param playerId    游戏用户ID
 @param loginToken  登录凭证
 @param ggid        AASAccountSDK中的ggid
 @param extension   扩展参数
 
 说明：
 1、loginType参数值只能从上述定义的extern字符串中选择，未支持的登录方式请使用TraceAnalysisLoginTypeOther
 2、playerId参数为游戏的用户系统中用户唯一标识
 3、loginToken为登录方式对应的校验凭证，可以传返回的signedRequest
 4、ggid参数为AASAccount登录完成后返回的ggid字段，必填
 5、extension为扩展参数，可扩展一些透传参数，选填，默认填nil
 */
+ (void)logAASLoginWithType:(NSString *)loginType
                   playerId:(NSString *)playerId
                 loginToken:(NSString *)loginToken
                       ggid:(NSString *)ggid
                  extension:(NSDictionary <NSString *, NSString *> *)extension;

#pragma mark - ZF log（支付上报）

/**
 内购支付 上报
 
 @param playerId          游戏用户ID
 @param receiptDataString 内购收据，将获取到的NSData收据转化为base64字符串
 */
+ (void)LogZFWithPlayerId:(NSString *)playerId receiptDataString:(NSString *)receiptDataString;

+ (void)LogZFWithPlayerId:(NSString *)playerId receiptDataString:(NSString *)receiptDataString extraMap:(NSDictionary *)extraMap;

/**
 内购支付 上报
 
 @param playerId          游戏用户ID
 @param gameAccountServer 游戏区/服ID
 @param receiptDataString 内购收据，将获取到的NSData收据转化为base64字符串
 */
+ (void)LogZFWithPlayerId:(NSString *)playerId gameAccountServer:(NSString *)gameAccountServer receiptDataString:(NSString *)receiptDataString;

+ (void)LogZFWithPlayerId:(NSString *)playerId gameAccountServer:(NSString *)gameAccountServer receiptDataString:(NSString *)receiptDataString extraMap:(NSDictionary *)extraMap;

/**
 第三方支付 上报
 
 @param playerId          游戏用户ID
 @param thirdparty        第三方支付平台名称
 @param receiptDataString 第三方支付平台单据
 */
+ (void)ThirdpartyLogZFWithPlayerId:(NSString *)playerId thirdparty:(NSString *)thirdparty receiptDataString:(NSString *)receiptDataString;

/**
 第三方支付 上报
 
 @param playerId          游戏用户ID
 @param gameAccountServer 游戏区/服ID
 @param thirdparty        第三方支付平台名称
 @param receiptDataString 第三方支付平台单据
 */
+ (void)ThirdpartyLogZFWithPlayerId:(NSString *)playerId gameAccountServer:(NSString *)gameAccountServer thirdparty:(NSString *)thirdparty receiptDataString:(NSString *)receiptDataString;

#pragma mark - Active log（在线时长打点）

/**
 在线时长上报
 
 @param serverName      游戏服务器,可以为空
 @param serverZone      玩家所在区服，可以为空
 @param uid             游戏用户 ID，请传入使用的 player ID（请确认与登录上报的 playerId 保持一致）,不可为空
 @param ggid            登录sdk中的用户ID,可以为空
 */
+ (void)initDurationReportWithServerName:(NSString *)serverName serverZone:(NSString *)serverZone uid:(NSString *)uid ggid:(NSString *)ggid;

/**
 在线时长上报 - 回到前台
 */
+ (void)becomeActive;

/**
 在线时长上报 - 回到后台
 */
+ (void)resignActive;

#pragma mark - 用户标签

/**
 推广用户标签
 
 @param conversionInfo      AppsFlyer返回的conversionInfo
 @param completionBlock     完成回调
 */
+ (void)getConversionData:(NSDictionary *)conversionInfo completion:(void (^)(NSError *error, NSString *campaign))completionBlock;

/**
 付费用户标签
 
 @param completionBlock     完成回调
 */
+ (void)getPayUserLayerWithCmpletion:(void (^)(NSError *error, NSString *payUserLayer))completionBlock;

/**
 广告用户标签
 
 @param completionBlock     完成回调
 */
+ (void)getAdUserLayerWithCmpletion:(void (^)(NSError *error, NSString *adUserLayer))completionBlock;

/**
 deeplink标签
 
 @param conversionInfo      AppsFlyer返回的conversionInfo
 @param completionBlock     完成回调
 */
+ (void)getDeeplink:(NSDictionary *)conversionInfo completion:(void (^)(NSError *error, NSString *deeplink))completionBlock;

/**
 ABTest
 
 @param completionBlock     完成回调
 */
+ (void)getABTestWithCmpletion:(void (^)(NSError *error, NSString *abTest))completionBlock;

/**
 ABTest
 
 @param playerId            游戏用户ID
 @param completionBlock     完成回调
 */
+ (void)getABTestWithPlayerId:(NSString *)playerId completion:(void (^)(NSError *error, NSString *abTest))completionBlock;

/**
 用户度量标签
 
 @param completionBlock     完成回调
 */
+ (void)getMeasureWithCmpletion:(void (^)(NSError *error, NSString *measureJson))completionBlock;

#pragma mark - ATT

/**
 上报ATT授权状态
 */
+ (void)logTrackingAuthorizationStatus;

@end
