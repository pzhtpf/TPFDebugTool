//
//  JxbHttpDatasource.h
//  JxbHttpProtocol
//
//  Created by Peter on 15/11/13.
//  Copyright © 2015年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JxbHttpModel : NSObject
@property (nonatomic,copy)NSString  *requestId;
@property (nonatomic,copy)NSURL     *url;
@property (nonatomic,copy)NSString  *method;
@property (nonatomic,copy)NSString  *requestBody;
@property (nonatomic,copy)NSString  *statusCode;
@property (nonatomic,copy)NSData    *responseData;
@property (nonatomic,assign)BOOL    isImage;
@property (nonatomic,copy)NSString  *mineType;
@property (nonatomic,copy)NSString  *startTime;
@property (nonatomic,copy)NSString  *totalDuration;
@property (nonatomic,copy)NSArray  *cookies;
@property (nonatomic,copy)NSError  *error;
@property (nonatomic,copy)NSDictionary  *requestAllHTTPHeaderFields;
@property (nonatomic,copy)NSDictionary  *responseAllHTTPHeaderFields;

@end

@interface JxbHttpDatasource : NSObject

@property (nonatomic,strong,readonly) NSMutableArray    *httpArray;
@property (nonatomic,strong,readonly) NSMutableArray    *arrRequest;

+ (instancetype)shareInstance;
/**
 *  记录http请求
 *
 *  @param model http
 */
- (void)addHttpRequset:(JxbHttpModel*)model;

- (BOOL)arrRequestContainObject:(NSString *)requestId;
/**
 *  清空
 */
- (void)clear;

/**
 *  解析
 *
 *  @param data
 *
 *  @return 
 */
+ (NSString *)prettyJSONStringFromData:(NSData *)data error:(NSError *)error;
@end
