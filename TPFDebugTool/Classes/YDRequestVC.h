//
//  YDRequestVC.h
//  Pods
//
//  Created by Roc.Tian on 2017/3/16.
//
//
#import "JxbHttpDatasource.h"

@interface YDRequestVC : UIViewController
@property (nonatomic,copy)NSString  *content;
@property(nonatomic,strong) JxbHttpModel *model;
@property(nonatomic) BOOL isHeader;


@property(strong,nonatomic)NSMutableArray *formData;
@property(strong,nonatomic)NSMutableArray *cookiesData;
@end
