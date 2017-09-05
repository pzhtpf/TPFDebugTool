//
//  JxbHttpDatasource.m
//  JxbHttpProtocol
//
//  Created by Peter on 15/11/13.
//  Copyright © 2015年 Peter. All rights reserved.
//

#import "JxbHttpDatasource.h"
#import "YDNameValueModel.h"

@implementation JxbHttpModel
@end

@implementation JxbHttpDatasource

+ (instancetype)shareInstance {
    static JxbHttpDatasource* tool;
    static dispatch_once_t  once;
    dispatch_once(&once, ^{
        tool = [[JxbHttpDatasource alloc] init];
    });
    return tool;
}

- (id)init {
    self = [super init];
    if (self) {
        _httpArray = [NSMutableArray array];
        _arrRequest = [NSMutableArray array];
    }
    return self;
}

- (void)addHttpRequset:(JxbHttpModel*)model {
    @synchronized(self.httpArray) {
        model = [self getCookies:model];
        [self.httpArray insertObject:model atIndex:0];
        
    }
    @synchronized(self.arrRequest) {
        if (model.requestId&& model.requestId.length > 0) {
            [self.arrRequest addObject:model.requestId];
        }
    }
}
-(BOOL)arrRequestContainObject:(NSString *)resquestId{
    @synchronized(self.arrRequest) {
        if (resquestId && resquestId.length > 0) {
           return  [self.arrRequest containsObject:resquestId];
        }
        return NO;
    }
}
-(JxbHttpModel *)getCookies:(JxbHttpModel*)model{

    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookiesForURL:model.url];
    
    NSMutableArray *mutableArray = [NSMutableArray new];
    for (NSHTTPCookie *cookie in cookies) {
        NSString *cookieName =  [cookie.properties valueForKey:NSHTTPCookieName];
        NSString *cookieValue =  [cookie.properties valueForKey:NSHTTPCookieValue];
        YDNameValueModel *model = [YDNameValueModel new];
        model.name = cookieName;
        model.value = cookieValue;
        [mutableArray addObject:model];
    }
    
    model.cookies = mutableArray;
    return model;
}
- (void)clear {
    @synchronized(self.httpArray) {
        [self.httpArray removeAllObjects];
    }
    @synchronized(self.arrRequest) {
        [self.arrRequest removeAllObjects];
    }
}


#pragma mark - parse
+ (NSString *)prettyJSONStringFromData:(NSData *)data error:(NSError *)error
{
    NSString *prettyString = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if ([NSJSONSerialization isValidJSONObject:jsonObject]) {
        prettyString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:NULL] encoding:NSUTF8StringEncoding];
        // NSJSONSerialization escapes forward slashes. We want pretty json, so run through and unescape the slashes.
        prettyString = [prettyString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    } else {
        prettyString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
    }
    
    return prettyString;
}
@end
