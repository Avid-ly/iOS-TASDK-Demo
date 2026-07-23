//
//  Created by samliu on 2017/7/10.
//  Copyright © 2017年 samliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogItemData.h"
@interface LogCellView : UITableViewCell

@property (nonatomic) LogItemData *item;

- (void)loadView;

@end
