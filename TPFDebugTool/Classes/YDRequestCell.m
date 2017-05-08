//
//  YDRequestCell.m
//  Pods
//
//  Created by Roc.Tian on 2017/3/16.
//
//

#import "YDRequestCell.h"

@implementation YDRequestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.valueLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark setter
-(void)setHeight:(float)height{

    _height = height;
    
    float valueHeight = _height -8;
    
    self.valueLabel.frame = CGRectMake(self.valueLabel.frame.origin.x, (_height-valueHeight)/2, self.valueLabel.frame.size.width, valueHeight);
    self.nameLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, (_height-self.nameLabel.frame.size.height)/2, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
}
@end
