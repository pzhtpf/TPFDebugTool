//
//  NSURLSessionTask+Swizzling.m
//  JxbFramework
//
//  Created by Peter on 16/1/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "NSURLSessionTask+Swizzling.h"
#import "JxbHttpDatasource.h"
#import <objc/runtime.h>
#import "JxbDebugTool.h"
#import "NSURLRequest+Identify.h"
#import "NSURLResponse+Data.h"
#import "NSURLSessionTask+Data.h"

@class NSURLSession;

@implementation NSURLSession (Swizzling)

+ (void)load {
    
    // Only allow swizzling once.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Swizzle any classes that implement one of these selectors.
        const SEL selectors[] = {
            @selector(URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:),
            @selector(URLSession:dataTask:didReceiveData:),
            @selector(URLSession:dataTask:didReceiveResponse:completionHandler:),
            @selector(URLSession:task:didCompleteWithError:),
            @selector(URLSession:dataTask:didBecomeDownloadTask:),
            @selector(URLSession:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:),
            @selector(URLSession:downloadTask:didFinishDownloadingToURL:)
        };

        const int numSelectors = sizeof(selectors) / sizeof(SEL);

        Class *classes = NULL;
        int numClasses = objc_getClassList(NULL, 0);

        if (numClasses > 0) {
            classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
            numClasses = objc_getClassList(classes, numClasses);
            for (NSInteger classIndex = 0; classIndex < numClasses; ++classIndex) {
                Class class = classes[classIndex];

                // Use the runtime API rather than the methods on NSObject to avoid sending messages to
                // classes we're not interested in swizzling. Otherwise we hit +initialize on all classes.
                // NOTE: calling class_getInstanceMethod() DOES send +initialize to the class. That's why we iterate through the method list.
                unsigned int methodCount = 0;
                Method *methods = class_copyMethodList(class, &methodCount);
                BOOL matchingSelectorFound = NO;
                for (unsigned int methodIndex = 0; methodIndex < methodCount; methodIndex++) {
                    for (int selectorIndex = 0; selectorIndex < numSelectors; ++selectorIndex) {
                        if (method_getName(methods[methodIndex]) == selectors[selectorIndex]) {
                            [self swizzling_selectors_task:class];
                            matchingSelectorFound = YES;
                            break;
                        }
                    }
                    if (matchingSelectorFound) {
                        break;
                    }
                }
                free(methods);
            }
            
            free(classes);
        }

    });
}

#pragma mark - NSURLSession task delegate with swizzling
+ (void)swizzling_selectors_task:(Class)cls {
    [self swizzling_TaskWillPerformHTTPRedirectionIntoDelegateClass:cls];
    [self swizzling_TaskDidSendBodyDataIntoDelegateClass:cls];
    [self swizzling_TaskDidReceiveDataIntoDelegateClass:cls];
    [self swizzling_TaskDidReceiveChallengeIntoDelegateClass:cls];
    [self swizzling_TaskNeedNewBodyStreamIntoDelegateClass:cls];
    [self swizzling_TaskDidCompleteWithErrorIntoDelegateClass:cls];
}

+ (void)swizzling_TaskWillPerformHTTPRedirectionIntoDelegateClass:(Class)cls {
    SEL selector = @selector(URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:);
    SEL swizzledSelector = @selector(URLSession_swizzling:task:willPerformHTTPRedirection:newRequest:completionHandler:);
    Protocol *protocol = @protocol(NSURLSessionTaskDelegate);
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription];
}

+ (void)swizzling_TaskDidSendBodyDataIntoDelegateClass:(Class)cls {
    SEL selector = @selector(URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:);
    SEL swizzledSelector = @selector(URLSession_swizzling:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:);
    Protocol *protocol = @protocol(NSURLSessionTaskDelegate);

    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription];
    
}
+ (void)swizzling_TaskDidReceiveChallengeIntoDelegateClass:(Class)cls {
    SEL selector = @selector(URLSession:task:didReceiveChallenge:completionHandler:);
    SEL swizzledSelector = @selector(URLSession_swizzling:task:didReceiveChallenge:completionHandler:);
    Protocol *protocol = @protocol(NSURLSessionTaskDelegate);
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription];
}

+ (void)swizzling_TaskNeedNewBodyStreamIntoDelegateClass:(Class)cls {
    SEL selector = @selector(URLSession_swizzling:task:needNewBodyStream:);
    SEL swizzledSelector = @selector(URLSession_swizzling:task:needNewBodyStream:);
    Protocol *protocol = @protocol(NSURLSessionTaskDelegate);
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription];
}
+ (void)swizzling_TaskDidReceiveDataIntoDelegateClass:(Class)cls {
    SEL selector = @selector(URLSession:dataTask:didReceiveData:);
    SEL swizzledSelector = @selector(URLSession_swizzling:dataTask:didReceiveData:);
    Protocol *protocol = @protocol(NSURLSessionDataDelegate);
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription];
}
+ (void)swizzling_TaskDidCompleteWithErrorIntoDelegateClass:(Class)cls {
    SEL selector = @selector(URLSession:task:didCompleteWithError:);
    SEL swizzledSelector = @selector(URLSession_swizzling:task:didCompleteWithError:);
    Protocol *protocol = @protocol(NSURLSessionTaskDelegate);

    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription];

}

#pragma mark - NSURLSession task delegate
- (void)URLSession_swizzling:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler {
    [self URLSession_swizzling:session task:task willPerformHTTPRedirection:response newRequest:request completionHandler:completionHandler];
}

-(void)URLSession_swizzling:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    
    [self URLSession_swizzling:session task:task didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];

    
    NSURLRequest* req = task.originalRequest;
    if ([[JxbHttpDatasource shareInstance] arrRequestContainObject:req.requestId])
         return;

   BOOL canHandle = YES;
   if ([[JxbDebugTool shareInstance] arrOnlyHosts].count > 0) {
       canHandle = NO;
       NSString* url = [req.URL.absoluteString lowercaseString];
       for (NSString* _url in [JxbDebugTool shareInstance].arrOnlyHosts) {
           if ([url rangeOfString:[_url lowercaseString]].location != NSNotFound) {
               canHandle = YES;
               break;
           }
       }
   }

  if(!canHandle)
      return;


    req.requestId = [[NSUUID UUID] UUIDString];
    req.startTime = @([[NSDate date] timeIntervalSince1970]);

   JxbHttpModel* model = [[JxbHttpModel alloc] init];
   model.requestId = req.requestId;
   model.url = req.URL;
   model.method = req.HTTPMethod;
   model.requestAllHTTPHeaderFields = req.allHTTPHeaderFields;
   model.startTime = [NSString stringWithFormat:@"%fs",req.startTime.doubleValue];
   model.statusCode = @"100";
   if (req.HTTPBody) {
       NSData* data = req.HTTPBody;
       if ([[JxbDebugTool shareInstance] isHttpRequestEncrypt]) {
           if ([[JxbDebugTool shareInstance] delegate] && [[JxbDebugTool shareInstance].delegate respondsToSelector:@selector(decryptJson:)]) {
               data = [[JxbDebugTool shareInstance].delegate decryptJson:req.HTTPBody];
           }
       }
       model.requestBody = [JxbHttpDatasource prettyJSONStringFromData:data error:nil];
   }

   [[JxbHttpDatasource shareInstance] addHttpRequset:model];
   [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyKeyReloadHttp object:nil];
     
}

- (void)URLSession_swizzling:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler {
    [self URLSession_swizzling:session task:task didReceiveChallenge:challenge completionHandler:completionHandler];
}

- (void)URLSession_swizzling:(NSURLSession *)session task:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream * __nullable bodyStream))completionHandler {
    [self URLSession_swizzling:session task:task needNewBodyStream:completionHandler];
}

+ (void)replaceImplementationOfSelector:(SEL)selector withSelector:(SEL)swizzledSelector forClass:(Class)cls withMethodDescription:(struct objc_method_description)methodDescription
{
    IMP implementation = class_getMethodImplementation([self class], swizzledSelector);
    Method oldMethod = class_getInstanceMethod(cls, selector);
    if (oldMethod) {
        class_addMethod(cls, swizzledSelector, implementation, methodDescription.types);
        Method newMethod = class_getInstanceMethod(cls, swizzledSelector);
        method_exchangeImplementations(oldMethod, newMethod);
    } else {    // 没有实例方法的话，就不要添加
        class_addMethod(cls, selector, implementation, methodDescription.types);
    }
}


#pragma mark - NSUrlSession delegate

- (void)URLSession_swizzling:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
       NSURLRequest* req = dataTask.originalRequest;
       NSURLResponse* resp = dataTask.response;
       NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)resp;
       NSString *statusCode = [NSString stringWithFormat:@"%d",(int)httpResponse.statusCode];
       
       if ([[JxbHttpDatasource shareInstance] arrRequestContainObject:req.requestId]){
           
           __block JxbHttpModel* model;
           NSMutableArray *httpArray = [[[JxbHttpDatasource shareInstance] httpArray] mutableCopy];
           [httpArray enumerateObjectsUsingBlock:^(JxbHttpModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
               if([obj.requestId isEqualToString:req.requestId]){
                   model = obj;
                   *stop = YES;
               }
           }];
           
           model.statusCode = statusCode;
           model.responseData = dataTask.responseDatas;
           model.responseAllHTTPHeaderFields = httpResponse.allHeaderFields;
           model.mineType = httpResponse.MIMEType;
           model.isImage = [resp.MIMEType rangeOfString:@"image"].location != NSNotFound;
           model.totalDuration = [NSString stringWithFormat:@"%fs",[[NSDate date] timeIntervalSince1970] - model.startTime.doubleValue];
           
           [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyKeyReloadHttp object:model];
       }
    
    [self URLSession_swizzling:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
}

- (void)URLSession_swizzling:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if(!dataTask.responseDatas) {
        dataTask.responseDatas = [NSMutableData data];
        dataTask.taskDataIdentify = NSStringFromClass([self class]);
    }
    if ([dataTask.taskDataIdentify isEqualToString:NSStringFromClass([self class])])
        [dataTask.responseDatas appendData:data];
    
    [self URLSession_swizzling:session dataTask:dataTask didReceiveData:data];
}

- (void)URLSession_swizzling:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    [self URLSession_swizzling:session dataTask:dataTask didBecomeDownloadTask:downloadTask];
}

-(void)URLSession_swizzling:(NSURLSession *)session task:(NSURLSessionTask *)dataTask didCompleteWithError:(nullable NSError *)error {
    
      NSURLRequest* req = dataTask.originalRequest;
      NSURLResponse* resp = dataTask.response;
      NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)resp;
      NSString *statusCode = [NSString stringWithFormat:@"%d",(int)httpResponse.statusCode];
    
      NSString *requestId = req.requestId;
      NSLog(@"结束请求:%@",requestId);
      
      if ([[JxbHttpDatasource shareInstance] arrRequestContainObject:req.requestId]){
          
          __block JxbHttpModel* model;
          NSMutableArray *httpArray = [[[JxbHttpDatasource shareInstance] httpArray] mutableCopy];
          [httpArray enumerateObjectsUsingBlock:^(JxbHttpModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
              
              if([obj.requestId isEqualToString:req.requestId]){
                  model = obj;
                  *stop = YES;
              }
          }];
          
          model.statusCode = statusCode;
          model.responseData = dataTask.responseDatas;
          model.responseAllHTTPHeaderFields = httpResponse.allHeaderFields;
          model.mineType = httpResponse.MIMEType;
          model.isImage = [resp.MIMEType rangeOfString:@"image"].location != NSNotFound;
          model.totalDuration = [NSString stringWithFormat:@"%fs",[[NSDate date] timeIntervalSince1970] - model.startTime.doubleValue];
          
          [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyKeyReloadHttp object:model];
      }
    
    [self URLSession_swizzling:session task:dataTask didCompleteWithError:error];
}

@end
