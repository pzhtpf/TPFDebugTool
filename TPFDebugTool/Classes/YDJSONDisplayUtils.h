//
//  YDJSONDisplayUtils.h
//  YDJSONDisplay
//
//  Created by Roc.Tian on 2017/3/17.
//  Copyright © 2017年 Roc.Tian. All rights reserved.
//

#define kColorWithRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

#define YDFONT  [UIFont systemFontOfSize:15.0f]
#define KEYCOLOR  kColorWithRGB(0xd68432)
#define INTCOLOR  kColorWithRGB(0x999933)
#define OTHERVALUECOLOR  kColorWithRGB(0x3333ee)


@interface YDJSONDisplayUtils : NSObject

@property(strong,nonatomic) NSMutableAttributedString *mutableAttributedString;

@property(nonatomic) float maxWidth;
-(NSMutableAttributedString *)handlerData:(id)object;
@end
