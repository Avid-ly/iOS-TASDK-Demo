//
//  Created by samliu on 2017/7/10.
//  Copyright © 2017年 samliu. All rights reserved.
//

#import "LogListView.h"
#import "LogItemData.h"
#import "LogCellView.h"
#import "AppBasicDefine.h"
@interface LogListView()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_heightAry;
    NSMutableArray *_dataSource;
    UITableView *_logTableView;
    NSDate *date;
    BOOL _waitFresh;
}

@end

@implementation LogListView

- (LogListView*)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        [self createTableView];
    }
    return self;
}

- (void)createTableView{
    _dataSource = [[NSMutableArray alloc] initWithCapacity:4];
    _heightAry = [[NSMutableArray alloc] initWithCapacity:4];
    CGRect newframe = self.bounds;
    _logTableView = [[UITableView alloc]initWithFrame:newframe style:UITableViewStylePlain];
    _logTableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _logTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //set degate and data source
    _logTableView.dataSource = self;
    _logTableView.delegate = self;
    //  _logTableView.sectionHeaderHeight = 0;
    //  _logTableView.sectionFooterHeight = 0;
    
    
    
    //_tableScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, self.view.bounds.size.height - 7.0);
    //_logTableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    //_logTableView.showsVerticalScrollIndicator = YES;
    _logTableView.showsHorizontalScrollIndicator = NO;
    
    //_logTableView.pagingEnabled = YES;
    _logTableView.userInteractionEnabled = YES;
    
    _logTableView.clipsToBounds = YES;
    
    //无分隔线
    _logTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //set edit operation
    _logTableView.allowsSelection = NO;
    _logTableView.allowsSelectionDuringEditing = NO;
    _logTableView.allowsMultipleSelection = NO;
    _logTableView.allowsMultipleSelectionDuringEditing = NO;
    
    //_logTableView.scrollEnabled = YES;
    
    [self addSubview: _logTableView];
    
}

#pragma mark - add data 

- (void)addLogData:(LogItemData*)data{
    if (_dataSource) {
        [_dataSource addObject:data];
        if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
            // do something  in main thread
            [_logTableView reloadData];
            _waitFresh = YES;
        } else {
            // do something in main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [_logTableView reloadData];
                _waitFresh = YES;
            });
        }
        
    }
}

#pragma mark - UITableViewDataSource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _dataSource?_dataSource.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    
    NSString *UICellIdentifier = @"LogData_Item_Cell";
    
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:UICellIdentifier];
    //NSLog(@"tableview cell for sh = %lf, h = %ld",tableView.contentSize.height, indexPath.row);
    if (!cell) {
        
        cell = [[LogCellView alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:UICellIdentifier];
        CGRect frame = cell.frame;
        frame.size.width = self.frame.size.width;
        cell.frame = frame;
        
    }
    
    if (cell) {
        // 从重用队列中取出cell对象
        LogItemData *curitem = [_dataSource objectAtIndex:indexPath.row];
        LogCellView *lc = (LogCellView*)cell;
        lc.item = curitem;
        [lc loadView];
    }
    
    //reload data for view
    NSInteger row = indexPath.row;
    
    CGFloat cellHt = 0;
    cellHt = cell.frame.size.height;
    //[cell freshViewWho:[NSString stringWithFormat:@"Who - %ld",(row+1)]];
    //cell.backgroundColor = [UIColor colorWithRed:(row+1)/9.0 green:(row+1)/8.0 blue:1 alpha:0.7];
    NSInteger size = _heightAry.count;
    if(row < size) {
        [_heightAry replaceObjectAtIndex:row withObject:[NSNumber numberWithFloat:cellHt]];
    }
    else{
        [_heightAry addObject:[NSNumber numberWithFloat:cellHt]];
    }
    
      //if (row > _dataSource.count - 5){
    if (_waitFresh && (!date || [[NSDate date] timeIntervalSinceDate:date] > 0.2)) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(requestLayoutView) withObject:nil afterDelay:0.0];
        [self performSelector:@selector(requestLayoutView) withObject:nil afterDelay:0.3];
        
    }
  
      //}
    
    //NSLog(@"total cell:[%ld] = %lf",row,[[_heightAry objectAtIndex:row] floatValue]);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
#ifdef DEBUG
    //NSLog(@"tableview heightForRowAtIndexPath: height = %d, row = %ld", Recipe_Comment_Height, indexPath.row);
#endif
    NSInteger row = indexPath.row;
    NSInteger size = _heightAry.count;
    if(row < size) {
        NSNumber *number = [_heightAry objectAtIndex:row];
        return [number floatValue];
    }
    else{
        CGFloat ht = 24*kScaleX;
        [_heightAry addObject:[NSNumber numberWithFloat:ht]];
        return ht;
    }
}
- (void)requestLayoutView {
    _waitFresh = NO;
    date = [NSDate date];
    NSUInteger rowCount = [_logTableView numberOfRowsInSection:0];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:rowCount-1 inSection:0];
    
    [_logTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)requestLayoutView1 {
    _waitFresh = NO;
    date = [NSDate date];
    //if (_logTableView.frame.size.height < 0 || _logTableView.contentSize.height < _logTableView.frame.size.height) return;//开始内容的大小没有超过tableView的高时不需要滚动
    
//    [UIView animateWithDuration:0.6 animations:^{
//
//        _logTableView.contentOffset = CGPointMake(0, _logTableView.contentSize.height - _logTableView.frame.size.height);
//        _waitFresh = NO;
//    }];
    CGFloat dify = _logTableView.contentSize.height - _logTableView.frame.size.height;
    if (dify > 0) {
        [_logTableView setContentOffset:CGPointMake(0, dify) animated:YES];
    }
    
}

- (void)requestLayoutView2 {
    CGFloat ht = [self subAllCellViewHeight];
    CGSize size = _logTableView.contentSize;
    //NSLog(@"total :%lf, %lf",ht,_logTableView.contentSize.height);
    size.height = ht;
    _logTableView.contentSize = size;
    
    //CGFloat offsety = _logTableView.contentOffset.y;
    CGFloat dify = size.height - self.frame.size.height;
    if (dify > 0) {
        //_logTableView.contentOffset = CGPointMake(_logTableView.contentOffset.x, dify);
        date = [NSDate date];
        //[_logTableView setContentOffset:CGPointMake(0, dify) animated:YES];
        
        [UIView animateWithDuration:0.6 animations:^{
            
            _logTableView.contentOffset = CGPointMake(0, dify);
            
        }];
    }
    _waitFresh = NO;
    
    
}

- (CGFloat)subAllCellViewHeight{
    NSInteger size = _heightAry.count;
    CGFloat ht = 0.0;
    for (NSInteger i = 0; i < size; i++) {
        ht += [_heightAry[i] floatValue];
        //NSLog(@"total:%fl, ht[%ld]:%lf",ht,i,[_heightAry[i] floatValue]);
    }
    return ht + 5*kScaleX;
}

@end
