//
//  JxbResponseVC.m
//  JxbHttpProtocol
//
//  Created by Peter on 16/5/5.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "JxbResponseVC.h"
#import "JxbDebugTool.h"
#import "JxbHttpDatasource.h"
#import "YDHtmlDisplayUtils.h"
@import WebKit;

@interface JxbResponseVC ()<UIScrollViewDelegate>
{
    UIImageView  *img;
    
}
@property (nonatomic, strong) NSString    *contentString;
@property (strong, nonatomic) YDHtmlDisplayUtils  *JSONDisplayUtils;
@end

@implementation JxbResponseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnclose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btnclose.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnclose setTitle:@"Back" forState:UIControlStateNormal];
    [btnclose addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [btnclose setTitleColor:[JxbDebugTool shareInstance].mainColor forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc] initWithCustomView:btnclose];
    self.navigationItem.leftBarButtonItem = btnleft;
    
    if (!self.model.isImage) {
        
        NSData* contentdata = self.model.responseData;
        if ([[JxbDebugTool shareInstance] isHttpResponseEncrypt]) {
            if ([[JxbDebugTool shareInstance] delegate] && [[JxbDebugTool shareInstance].delegate respondsToSelector:@selector(decryptJson:)]) {
                contentdata = [[JxbDebugTool shareInstance].delegate decryptJson:self.model.responseData];
            }
        }
        NSError *error;
        NSDictionary *dataDictionary;
        if([self.model.mineType rangeOfString:@"html"].location != NSNotFound){
            
            dataDictionary = [NSJSONSerialization JSONObjectWithData:self.model.responseData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&error];
            if(!dataDictionary){
                _contentString = [JxbHttpDatasource prettyJSONStringFromData:contentdata error:error];
                [self addWebView];
                return;
            }
        }
        else if([self.model.mineType rangeOfString:@"json"].location != NSNotFound){
            
            dataDictionary = [NSJSONSerialization JSONObjectWithData:self.model.responseData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&error];
        }
        else if([self.model.mineType rangeOfString:@"javascript"].location != NSNotFound){
            
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *content = [[NSString alloc] initWithData:self.model.responseData encoding:gbkEncoding];
            NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
            dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
        }
        else{
            
            _contentString = [JxbHttpDatasource prettyJSONStringFromData:contentdata error:error];
        }
        
        NSMutableAttributedString *mutableAttributedString;
        self.JSONDisplayUtils = [YDHtmlDisplayUtils new];
        if(!error){
            
            if(dataDictionary){
                mutableAttributedString  = [self.JSONDisplayUtils handlerData:dataDictionary];
                _contentString = mutableAttributedString.string;
            }
        }
        else{
            
            // _contentString  = [[self.JSONDisplayUtils handlerData:error.userInfo] string];
            _contentString = nil;
        }
        
        [self addWebView];
    }
    else {
        img = [[UIImageView alloc] initWithFrame:self.view.bounds];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.image = [UIImage imageWithData:self.model.responseData];
        [self.view addSubview:img];
    }
}
-(void)addWebView{
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:wkWebConfig];
    [self.view addSubview:webView];
    
    if(_contentString)
        [webView loadHTMLString:_contentString baseURL:nil];
    else{
        [webView loadData:self.model.responseData MIMEType:self.model.mineType characterEncodingName:@"GBK" baseURL:self.model.url];
    }
    
}
- (void)copyAction {
    // UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    // pasteboard.string = [txt.text copy];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
