//
//  YDJSONDisplayUtils.h
//  YDJSONDisplay
//
//  Created by Roc.Tian on 2017/3/17.
//  Copyright © 2017年 Roc.Tian. All rights reserved.
//

#define YDFONT  [UIFont systemFontOfSize:15.0f]
#define KEYCOLOR  TPFColorWithRGB(0xd68432)
#define INTCOLOR  TPFColorWithRGB(0x999933)
#define OTHERVALUECOLOR  TPFColorWithRGB(0x3333ee)


@interface YDJSONDisplayUtils : NSObject

@property(strong,nonatomic) NSMutableAttributedString *mutableAttributedString;

@property(nonatomic) float maxWidth;
-(NSMutableAttributedString *)handlerData:(id)object;
@end
