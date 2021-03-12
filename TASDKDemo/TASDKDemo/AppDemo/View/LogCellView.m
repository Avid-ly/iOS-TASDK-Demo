//
//
//  Created by samliu on 2017/7/10.
//  Copyright © 2017年 samliu. All rights reserved.
//

#import "LogCellView.h"
#import "AppBasicDefine.h"
#import "NSUtils.h"
@interface LogCellView() {
    UILabel *_lblView;
    float _paddingTop;
    BOOL _inited;
}

@end

@implementation LogCellView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void)createView{
    _paddingTop = 5*kScaleX;
    
    CGRect frame = CGRectMake(_paddingTop*2, _paddingTop, self.frame.size.width-_paddingTop*4, 24*kScaleX);
    
    
    //frame.origin.x = 10*kScaleX;
    _lblView = [[UILabel alloc] initWithFrame:frame];
    _lblView.font = STFont(14*kScaleX);
    _lblView.backgroundColor = [UIColor clearColor];
    _lblView.numberOfLines = 0;
    _lblView.lineBreakMode=NSLineBreakByCharWrapping;
    [self addSubview:_lblView];
    self.backgroundColor = [UIColor clearColor];
    
//    frame = self.frame;
//    frame.size.height = _boderView.frame.origin.y + _boderView.frame.size.height;
//    self.frame = frame;
    
    _inited = YES;
    
}

- (void)freshView{
    _lblView.text = _item.log;
    [NSUtils adjustLabelHeightToFitContent:_lblView];
    //[NSUtils adjustLabelWeightToFitContent:_lblView];
    
    switch (self.item.level) {
        case LOGLEVEL_i:
            [_lblView setTextColor:[UIColor greenColor]];
            break;
        case LOGLEVEL_d:
            [_lblView setTextColor:[UIColor blueColor]];
            break;
        case LOGLEVEL_w:
            [_lblView setTextColor:[UIColor orangeColor]];
            break;
        case LOGLEVEL_e:
            [_lblView setTextColor:[UIColor redColor]];
            break;
        default:
            [_lblView setTextColor:[UIColor whiteColor]];
            break;
    }
    CGRect frame = self.frame;
    frame.size.height = _lblView.frame.origin.y + _lblView.frame.size.height + 0;
    self.frame = frame;
}

- (void)loadView{
    if(!_inited){
        [self createView];
    }
    
    [self freshView];
    
}

@end
