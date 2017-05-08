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
-(void)testNetworkingDebugTool{
    
    //    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // app版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSString *urlString = @"http://api.yaduo.com/atourlife/app/checkUpdate";
    NSDictionary *params = @{
                             @"appVer":app_Version,
                             @"channelId":@"20001",
                             @"platType":@"2"
                             };
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:params error:nil];
    
    
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        
        //        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //        NSString *content = [[NSString alloc] initWithData:responseObject encoding:gbkEncoding];
        //        NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
        //        NSError *jsonParserError;
        //        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonParserError];
        //        NSLog(@"%@",responseDic);
    }];
    [dataTask resume];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
