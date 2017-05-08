//
//  YDNameValueModel.m
//  Pods
//
//  Created by tianpengfei on 2017/3/19.
//
//

#import "YDNameValueModel.h"

@implementation YDNameValueModel

-(void)setName:(NSString *)name{

    _name = [name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
}
-(void)setValue:(NSString *)value{

    _value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    self.height = [self maxHeight:_value];
}


-(float)maxHeight:(NSString *)text{
    
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                 NSParagraphStyleAttributeName : style};
    CGRect r = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width/2-12, MAXFLOAT) options:option attributes:attributes context:nil];
    
    float height = r.size.height + 18;
    
    return height<=35?35:height+15;
}
@end
