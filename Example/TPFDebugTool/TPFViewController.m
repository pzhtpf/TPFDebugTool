//
//  TPFViewController.m
//  TPFDebugTool
//
//  Created by pzhtpf on 05/08/2017.
//  Copyright (c) 2017 pzhtpf. All rights reserved.
//

#import "TPFViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface TPFViewController ()

@end

@implementation TPFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self testNetworkingDebugTool];
}

- (void)testNetworkingDebugTool {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 15;
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    // app版本
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//
//    NSString *urlString = @"http://api.yaduo.com/atourlife/app/checkUpdate";
//    NSDictionary *params = @{
//            @"appVer": app_Version,
//            @"channelId": @"20001",
//            @"platType": @"2"
//    };

    NSString *baseUrl = @"http://10.0.22.149:7002/self/";
    NSString *urlString = [NSString stringWithFormat:@"%@%@", baseUrl, @"secRe/mobile/getEmpInfo"];
    NSDictionary *params = @{
    };

    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:params error:nil];
    [request setTimeoutInterval:15];
    [request setValue:@"3c62d60f8fb155fd339c413c3646cf59d25c6b66b8203600ef57f997fb740d46" forHTTPHeaderField:@"access_token"];

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress *_Nonnull uploadProgress) {
    } downloadProgress:^(NSProgress *_Nonnull downloadProgress) {
    } completionHandler:^(NSURLResponse *_Nonnull response, id _Nullable responseObject, NSError *_Nullable error) {
        if (error) {
            NSLog(@"网络错误🙅🙅🙅: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];

    [dataTask resume];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
