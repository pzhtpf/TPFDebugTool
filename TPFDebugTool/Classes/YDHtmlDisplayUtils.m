//
//  YDJSONDisplayUtils.m
//  YDJSONDisplay
//
//  Created by Roc.Tian on 2017/3/17.
//  Copyright © 2017年 Roc.Tian. All rights reserved.
//

#import "YDHtmlDisplayUtils.h"
@interface YDHtmlDisplayUtils()

@property(strong,nonatomic) NSString *placeholder;

@end

@implementation YDHtmlDisplayUtils
-(id)init{

    self = [super init];
    if(self){
    
        _placeholder = @"  ";
    }
    return self;
}
-(NSMutableAttributedString *)handlerData:(id)object{

    NSMutableAttributedString *mutableAttributedString  = [self deliver:object placeholder:@"  "];
    
    NSString *divString = [NSString stringWithFormat:@"<div style=\"line-height: 1.3;font-size:35px\">%@</div>",mutableAttributedString.string];
    
    return [[NSMutableAttributedString alloc] initWithString:divString];
}
-(NSMutableAttributedString *)deliver:(id)object placeholder:(NSString *)placeholder{

    if([object isKindOfClass:[NSDictionary class]]){
    
        return [self handlerDictionary:object placeholder:placeholder];
    }
    else if([object isKindOfClass:[NSArray class]]){
        
        return  [self handlerArray:object placeholder:placeholder];
    }
    else{
    
        return [self handlerOther:object];
    }
    
    return nil;
}
-(NSMutableAttributedString *)handlerDictionary:(NSDictionary *)dictionary placeholder:(NSString *)placeholder{

    NSString *dictionaryString = @"{<br />";
    NSMutableAttributedString *mutableAttributedString = [self handlerPunctuation:dictionaryString];
    
    NSArray *allKeys = [dictionary allKeys];
    for (int i =0;i<allKeys.count;i++) {
        
        NSString *key = allKeys[i];
        
        //处理占位符
        NSString *htmlPlaceholder = [NSString stringWithFormat:@"<nobr><span style=\"color: white;\">%@</span>",placeholder];
        
        NSMutableAttributedString *placeholderAttributedString = [[NSMutableAttributedString alloc] initWithString:htmlPlaceholder];
        
        [mutableAttributedString appendAttributedString:placeholderAttributedString];
        
        //处理key
        
        [mutableAttributedString appendAttributedString:[self handlerKey:key]];
        
        //处理value，递归调用
        
         [mutableAttributedString appendAttributedString:[self deliver:[dictionary valueForKey:key] placeholder:[NSString stringWithFormat:@"%@%@    ",placeholder,key]]];
        
          [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"</nobr>"]];
        
        //一行结束，添加换行符
        
        NSString *returnString;
        if(i==allKeys.count-1)
            returnString = @"<br />";
        else
            returnString = @",<br />";
        
        NSMutableAttributedString *returnAttributedString = [self handlerPunctuation:returnString];
        
        [mutableAttributedString appendAttributedString:returnAttributedString];

    }
    
    NSString *htmlPlaceholder = [NSString stringWithFormat:@"<span style=\"color: white;\">%@</span>",placeholder];
    NSMutableAttributedString *placeholderAttributedString = [[NSMutableAttributedString alloc] initWithString:htmlPlaceholder];
    
    [mutableAttributedString appendAttributedString:placeholderAttributedString];
    [mutableAttributedString appendAttributedString:[self handlerPunctuation:@"}"]];
    
    return mutableAttributedString;
}
-(NSMutableAttributedString *)handlerArray:(NSArray *)array placeholder:(NSString *)placeholder{
    
    NSString *dictionaryString = @"[<br />";
    NSMutableAttributedString *mutableAttributedString = [self handlerPunctuation:dictionaryString];
    
    for (int i =0;i<array.count;i++) {
        
        id object = array[i];
        
        //处理占位符
        
        NSString *htmlPlaceholder = [NSString stringWithFormat:@"<nobr><span style=\"color: white;\">%@</span>",placeholder];
        
        NSMutableAttributedString *placeholderAttributedString = [[NSMutableAttributedString alloc] initWithString:htmlPlaceholder];
        [mutableAttributedString appendAttributedString:placeholderAttributedString];
        
        //处理value，递归调用
        
        [mutableAttributedString appendAttributedString:[self deliver:object placeholder:placeholder]];
        
         [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"</nobr>"]];
        
        //一行结束，添加换行符
        
        NSString *returnString;
        if(i==array.count-1)
            returnString = @"<br />";
        else
            returnString = @",<br />";
        
        NSMutableAttributedString *returnAttributedString = [self handlerPunctuation:returnString];
        
        [mutableAttributedString appendAttributedString:returnAttributedString];
        
        
        
    }
    
    NSString *htmlPlaceholder = [NSString stringWithFormat:@"<nobr><span style=\"color: white;\">%@</span>",placeholder];
    NSMutableAttributedString *placeholderAttributedString = [[NSMutableAttributedString alloc] initWithString:htmlPlaceholder];
    
    [mutableAttributedString appendAttributedString:placeholderAttributedString];
    [mutableAttributedString appendAttributedString:[self handlerPunctuation:@"]"]];
    
    return mutableAttributedString;
}
-(NSMutableAttributedString *)handlerOther:(id)object{

    NSString *string;
    NSMutableAttributedString *mutableAttributedString;
    if([object isKindOfClass:[NSNumber class]]){
    
        string = [NSString stringWithFormat:@"<span style=\"color: #999933;font-weight: 800;\">%@</span>",object];
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
    }
    else if([object isKindOfClass:[NSString class]]){
    
        string = [NSString stringWithFormat:@"<span style=\"color: #d68432;\">\"%@\"</span>",object];
        string = [string stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
    }
    else{
    
        NSString *showString = [NSString stringWithFormat:@"%@",object];
        showString = [showString stringByReplacingOccurrencesOfString:@"<" withString:@"&lt"];
        showString = [showString stringByReplacingOccurrencesOfString:@">" withString:@"&gt"];
        string = [NSString stringWithFormat:@"<span style=\"color: #3333ee;\">%@</span>",showString];
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
    }
    
    return mutableAttributedString;
}
-(NSMutableAttributedString *)handlerKey:(NSString *)key{

    NSString *keyString = [NSString stringWithFormat:@"<span style=\"color: #d68432;\">\"%@\"</span>",key];
    NSMutableAttributedString *keyAttributedString = [[NSMutableAttributedString alloc] initWithString:keyString];
    
    [keyAttributedString appendAttributedString:[self handlerPunctuation:@" : "]];
    
    return keyAttributedString;

}
-(NSMutableAttributedString *)handlerPunctuation:(NSString *)punctuation{

    NSString *htmlPunctuation = [NSString stringWithFormat:@"<span style=\"color: black;\">%@</span>",punctuation];
    NSMutableAttributedString *punctuationAttributedString = [[NSMutableAttributedString alloc] initWithString:htmlPunctuation];
    
    return punctuationAttributedString;

}
-(float)maxWidth:(NSString *)text{

    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attributes = @{NSFontAttributeName : YDFONT,
                                 NSParagraphStyleAttributeName : style};
    CGRect r = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:option attributes:attributes context:nil];
    
    
    return r.size.width;
}
-(UIFont *)ssMediumFont:(float)size{
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.2f){
        
        return [UIFont systemFontOfSize:size weight:UIFontWeightMedium];  // NS_AVAILABLE_IOS(8_2)
    }
    else{
        
        return [UIFont systemFontOfSize:size];
        
    }
}
@end
