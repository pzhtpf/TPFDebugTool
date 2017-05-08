//
//  YDJSONDisplayUtils.m
//  YDJSONDisplay
//
//  Created by Roc.Tian on 2017/3/17.
//  Copyright © 2017年 Roc.Tian. All rights reserved.
//

#import "YDJSONDisplayUtils.h"
@interface YDJSONDisplayUtils()

@property(strong,nonatomic) NSString *placeholder;

@end

@implementation YDJSONDisplayUtils
-(id)init{

    self = [super init];
    if(self){
    
        _placeholder = @"  ";
    }
    return self;
}
-(NSMutableAttributedString *)handlerData:(id)object{

    NSMutableAttributedString *mutableAttributedString  = [self deliver:object placeholder:@"  "];
    [self calculationMaxWidth:mutableAttributedString];
    
    return mutableAttributedString;
}
-(void)calculationMaxWidth:(NSMutableAttributedString *)mutableAttributedString{

    NSString *string = [mutableAttributedString string];
    NSArray *array = [string componentsSeparatedByString:@"\r\n"];
    for (NSString *tempString in array) {
        
        float tempWidth = [self maxWidth:tempString];
        if(tempWidth>self.maxWidth)
            self.maxWidth = tempWidth;
    }
    
    self.maxWidth += 50;
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

    NSString *dictionaryString = @"{\r\n";
    NSMutableAttributedString *mutableAttributedString = [self handlerPunctuation:dictionaryString];
    
    NSArray *allKeys = [dictionary allKeys];
    for (int i =0;i<allKeys.count;i++) {
        
        NSString *key = allKeys[i];
        
        //处理占位符
        
        NSMutableAttributedString *placeholderAttributedString = [[NSMutableAttributedString alloc] initWithString:placeholder];
        [placeholderAttributedString setAttributes:@{
                                                 NSFontAttributeName:YDFONT,
                                                 NSForegroundColorAttributeName:[UIColor whiteColor]
                                                 } range:NSMakeRange(0, placeholderAttributedString.length)];
        
        [mutableAttributedString appendAttributedString:placeholderAttributedString];
        
        //处理key
        
        [mutableAttributedString appendAttributedString:[self handlerKey:key]];
        
        //处理value，递归调用
        
         [mutableAttributedString appendAttributedString:[self deliver:[dictionary valueForKey:key] placeholder:[NSString stringWithFormat:@"%@%@    ",placeholder,key]]];
        
        //一行结束，添加换行符
        
        NSString *returnString;
        if(i==allKeys.count-1)
            returnString = @"\r\n";
        else
            returnString = @",\r\n";
        
        NSMutableAttributedString *returnAttributedString = [self handlerPunctuation:returnString];
        
        [mutableAttributedString appendAttributedString:returnAttributedString];

    }
    
    NSMutableAttributedString *placeholderAttributedString = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [placeholderAttributedString setAttributes:@{
                                                 NSFontAttributeName:YDFONT,
                                                 NSForegroundColorAttributeName:[UIColor whiteColor]
                                                 } range:NSMakeRange(0, placeholderAttributedString.length)];
    
    [mutableAttributedString appendAttributedString:placeholderAttributedString];
    [mutableAttributedString appendAttributedString:[self handlerPunctuation:@"}"]];
    
    return mutableAttributedString;
}
-(NSMutableAttributedString *)handlerArray:(NSArray *)array placeholder:(NSString *)placeholder{
    
    NSString *dictionaryString = @"[\r\n";
    NSMutableAttributedString *mutableAttributedString = [self handlerPunctuation:dictionaryString];
    
    for (int i =0;i<array.count;i++) {
        
        id object = array[i];
        
        //处理占位符
        
        NSMutableAttributedString *placeholderAttributedString = [[NSMutableAttributedString alloc] initWithString:placeholder];
        [placeholderAttributedString setAttributes:@{
                                                     NSFontAttributeName:YDFONT,
                                                     NSForegroundColorAttributeName:[UIColor whiteColor]
                                                     } range:NSMakeRange(0, placeholderAttributedString.length)];
        
        [mutableAttributedString appendAttributedString:placeholderAttributedString];
        
        //处理value，递归调用
        
        [mutableAttributedString appendAttributedString:[self deliver:object placeholder:placeholder]];
        
        //一行结束，添加换行符
        
        NSString *returnString;
        if(i==array.count-1)
            returnString = @"\r\n";
        else
            returnString = @",\r\n";
        
        NSMutableAttributedString *returnAttributedString = [self handlerPunctuation:returnString];
        
        [mutableAttributedString appendAttributedString:returnAttributedString];
        
        
        
    }
    
    NSMutableAttributedString *placeholderAttributedString = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [placeholderAttributedString setAttributes:@{
                                                 NSFontAttributeName:YDFONT,
                                                 NSForegroundColorAttributeName:[UIColor whiteColor]
                                                 } range:NSMakeRange(0, placeholderAttributedString.length)];
    
    [mutableAttributedString appendAttributedString:placeholderAttributedString];
    [mutableAttributedString appendAttributedString:[self handlerPunctuation:@"]"]];
    
    return mutableAttributedString;
}
-(NSMutableAttributedString *)handlerOther:(id)object{

    NSString *string;
    NSMutableAttributedString *mutableAttributedString;
    if([object isKindOfClass:[NSNumber class]]){
    
        string = [NSString stringWithFormat:@"%@",object];
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [mutableAttributedString setAttributes:@{
                                                 NSFontAttributeName:[self ssMediumFont:15.0f],
                                                 NSForegroundColorAttributeName:INTCOLOR
                                                 } range:NSMakeRange(0, string.length)];
    }
    else if([object isKindOfClass:[NSString class]]){
    
        string = [NSString stringWithFormat:@"\"%@\"",object];
        string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [mutableAttributedString setAttributes:@{
                                                 NSFontAttributeName:YDFONT,
                                                 NSForegroundColorAttributeName:KEYCOLOR
                                                 } range:NSMakeRange(0, string.length)];
    }
    else{
    
        string = [NSString stringWithFormat:@"%@",object];
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [mutableAttributedString setAttributes:@{
                                                 NSFontAttributeName:YDFONT,
                                                 NSForegroundColorAttributeName:OTHERVALUECOLOR
                                                 } range:NSMakeRange(0, string.length)];
    }
    
    return mutableAttributedString;
}
-(NSMutableAttributedString *)handlerKey:(NSString *)key{

    NSString *keyString = [NSString stringWithFormat:@"\"%@\"",key];
    NSMutableAttributedString *keyAttributedString = [[NSMutableAttributedString alloc] initWithString:keyString];
    [keyAttributedString setAttributes:@{
                                                 NSFontAttributeName:YDFONT,
                                                 NSForegroundColorAttributeName:KEYCOLOR
                                                 } range:NSMakeRange(0, keyString.length)];
    
    [keyAttributedString appendAttributedString:[self handlerPunctuation:@" : "]];
    
    return keyAttributedString;

}
-(NSMutableAttributedString *)handlerPunctuation:(NSString *)punctuation{

    NSMutableAttributedString *punctuationAttributedString = [[NSMutableAttributedString alloc] initWithString:punctuation];
    [punctuationAttributedString setAttributes:@{
                                         NSFontAttributeName:YDFONT,
                                         NSForegroundColorAttributeName:[UIColor blackColor]
                                         } range:NSMakeRange(0, punctuation.length)];
    
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
