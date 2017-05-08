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
      //  UIButton *btnCopy = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
      //  btnCopy.titleLabel.font = [UIFont systemFontOfSize:13];
     //   [btnCopy setTitle:@"Copy" forState:UIControlStateNormal];
      //  [btnCopy addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
      //  [btnCopy setTitleColor:[JxbDebugTool shareInstance].mainColor forState:UIControlStateNormal];
      //  UIBarButtonItem *btnright = [[UIBarButtonItem alloc] initWithCustomView:btnCopy];
     //   self.navigationItem.rightBarButtonItem = btnright;
        
        NSData* contentdata = self.model.responseData;
        if ([[JxbDebugTool shareInstance] isHttpResponseEncrypt]) {
            if ([[JxbDebugTool shareInstance] delegate] && [[JxbDebugTool shareInstance].delegate respondsToSelector:@selector(decryptJson:)]) {
                contentdata = [[JxbDebugTool shareInstance].delegate decryptJson:self.model.responseData];
            }
        }
        NSError *error;
        NSDictionary *dataDictionary;
        if([self.model.mineType rangeOfString:@"html"].location != NSNotFound){
            
            _contentString = [JxbHttpDatasource prettyJSONStringFromData:contentdata error:error];
            if(_contentString)
            [self addWebView];
            return;
           
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
        
             _contentString  = [[self.JSONDisplayUtils handlerData:error.userInfo] string];
        }
    
        if(_contentString)
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

    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    [webView loadHTMLString:_contentString baseURL:nil];
}
- (void)copyAction {
   // UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
   // pasteboard.string = [txt.text copy];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)aScrollView {
    return  [aScrollView.subviews objectAtIndex:0];
}
@end
