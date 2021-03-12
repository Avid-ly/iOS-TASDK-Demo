//
//  DemoViewController.m
//
//  Created by samliu on 2017/7/7.
//  Copyright © 2017年 samliu. All rights reserved.
//

#import "DemoViewController.h"
#import "AppBasicDefine.h"
#import "NSUtils.h"
//#import "TraceAnalysis.h"
#import <TraceAnalysisSDK/TraceAnalysis.h>
//#import "TraceAnalysisApi.h"
#import "LogEventThread.h"
#import "CustomNavController.h"
#import "LogListView.h"
#import "LogItemData.h"
//#import "TraceDataGlobalParam.h"
//#import "TraceDBServiceImpl.h"
//#import "TraceDBOrder.h"
//#import "TraceAnalysisDebug.h"
//#import <objc/runtime.h>
#import "OtherViewController.h"

#define Test_Zone 0


@interface DemoViewController ()<UITextFieldDelegate, LogEventThreadListener> {
    UITextField *_productField;
    UITextField *_channelField;
    UITextField *_hhhKeyField;
    UITextField *_hhhNumberField;
    UITextField *_hhhThreadField;
    UITextField *_hhhSleepField;
    
    UITextField *_hhhRunStateField;
    UITextField *_hhhRunNumberField;
    float _LableWith;
    
    UIView *_errorView;
    UILabel *_errorMsgView;
    UIButton *_errorCloseButton;
    LogEventThread *_logThreads;
    UIButton *_startBtn;
    NSInteger _sendGroup;
    NSString *_key;
    NSInteger _sendNumber;
    LogListView *_logListView;
    NSDate *_date;
    BOOL _checking;
    BOOL _hasInited;
}


@end

@implementation DemoViewController

#define KPrefer_ProductId @"KP_Demo_ProductID"
#define KPrefer_ChannelId @"KP_Demo_ChannelID"

#define KPrefer_HHH_Key @"KP_Demo_HHH_Key"
#define KPrefer_HHH_Number @"KP_Demo__HHH_Number"

#define KPrefer_HHH_Thread @"KP_Demo_HHH_Thread"
#define KPrefer_HHH_Sleep @"KP_Demo__HHH_Sleep"

#define KPrefer_HHH_Run_Number @"KP_Demo__HHH_Run_Number"

#define kUIView_Field_Pid_Tag  10001
#define kUIView_Field_Cid_Tag  10002

#define kUIView_Field_HKeyid_Tag  11001
#define kUIView_Field_HNuberid_Tag  11002

#define kUIView_Field_HThread_Tag  11003
#define kUIView_Field_HSleep_Tag  11004

#define kUIView_Field_HRunState_Tag  11005
#define kUIView_Field_HRunNumber_Tag  11006



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(bgClick)];
    tap.numberOfTapsRequired = 1;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];

    
    float dis = 5*kScaleX;
    float left = 10*kScaleX;
    float y = 30*kScaleX;
    float x = left;
    _LableWith = 70*kScaleX;
    float liheHt = 45*kScaleX;
    float textWidth = 120 * kScaleX;
    float textHeight = 26 * kScaleX;
    y+=50;
    CGRect frame = CGRectMake(x, y, _LableWith, textHeight);

    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = @"initSDK:";
    lable.textColor = [UIColor whiteColor];
    lable.font = STBoldFont(15*kScaleX);
    lable.textAlignment = NSTextAlignmentRight;
    [NSUtils adjustLabelHeightToFitContent:lable];
    CGRect ff = lable.frame;
    ff.origin.y += (textHeight - ff.size.height)/2;
    lable.frame = ff;
    [self.view addSubview:lable];
    
    frame.size.height = textHeight;
    frame.origin.x += lable.frame.size.width + dis*1.5;
    frame.size.width = textWidth;
    _productField = [self createTextField:frame holder:@"产品Id"];
    _productField.tag = kUIView_Field_Pid_Tag;
    [self.view addSubview:_productField];
    
    frame.origin.x += _productField.frame.size.width + dis;
    lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = @"-";
    lable.textColor = [UIColor whiteColor];
    lable.font = STFont(14*kScaleX);
    [NSUtils adjustLabelWeightToFitContent:lable];
    [self.view addSubview:lable];
    
    frame.size.height = textHeight;
    frame.origin.x += lable.frame.size.width + dis;
    _channelField = [self createTextField:frame holder:@"渠道Id"];
    _channelField.tag = kUIView_Field_Cid_Tag;
    [self.view addSubview:_channelField];
    
    NSString *pid = [[NSUserDefaults standardUserDefaults] objectForKey:KPrefer_ProductId];
    if (pid ) {
        _productField.text = pid;
    }
    
    
    NSString *cid = [[NSUserDefaults standardUserDefaults] objectForKey:KPrefer_ChannelId];
    if (cid ) {
        _channelField.text = cid;
    }
    
    
    // 添加hight event key and number
    y += liheHt;
    x = left;
    frame = CGRectMake(x, y, _LableWith, 24*kScaleX);
    lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = @"HighKey:";
    lable.textColor = [UIColor whiteColor];
    lable.font = STBoldFont(15*kScaleX);
    lable.textAlignment = NSTextAlignmentRight;
    [NSUtils adjustLabelHeightToFitContent:lable];
    ff = lable.frame;
    ff.origin.y += (textHeight - ff.size.height)/2;
    lable.frame = ff;
    [self.view addSubview:lable];
    
    frame.size.height = textHeight;
    frame.origin.x += lable.frame.size.width + dis*1.5;
    frame.size.width = textWidth;
    _hhhKeyField = [self createTextField:frame holder:@"高优先级Key"];
    _hhhKeyField.tag = kUIView_Field_HKeyid_Tag;
    [self.view addSubview:_hhhKeyField];
    
    NSString *hhhkeyid = [[NSUserDefaults standardUserDefaults] objectForKey:KPrefer_HHH_Key];
    if (hhhkeyid ) {
        _hhhKeyField.text = hhhkeyid;
    }
    
    frame.origin.x += _hhhKeyField.frame.size.width + dis;
    lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = @"-";
    lable.textColor = [UIColor whiteColor];
    lable.font = STFont(14*kScaleX);
    [NSUtils adjustLabelWeightToFitContent:lable];
    [self.view addSubview:lable];
    
    frame.size.height = textHeight;
    frame.origin.x += lable.frame.size.width + dis;
    _hhhNumberField = [self createTextField:frame holder:@"发送数量"];
    _hhhNumberField.tag = kUIView_Field_HNuberid_Tag;
    [self.view addSubview:_hhhNumberField];
    
    NSString *hhhnumber = [[NSUserDefaults standardUserDefaults] objectForKey:KPrefer_HHH_Number];
    if (hhhnumber) {
        _hhhNumberField.text = hhhnumber;
    }
    
    //线程数
    y += liheHt;
    x = left;
    frame = CGRectMake(x, y, _LableWith, 24*kScaleX);
    lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = @"Thread:";
    lable.textColor = [UIColor whiteColor];
    lable.font = STBoldFont(15*kScaleX);
    lable.textAlignment = NSTextAlignmentRight;
    [NSUtils adjustLabelHeightToFitContent:lable];
    ff = lable.frame;
    ff.origin.y += (textHeight - ff.size.height)/2;
    lable.frame = ff;
    [self.view addSubview:lable];
    
    frame.size.height = textHeight;
    frame.origin.x += lable.frame.size.width + dis*1.5;
    frame.size.width = textWidth;
    _hhhThreadField = [self createTextField:frame holder:@"Gcd线程数"];
    _hhhThreadField.tag = kUIView_Field_HThread_Tag;
    [self.view addSubview:_hhhThreadField];
    
    NSString *hhhThreadid = [[NSUserDefaults standardUserDefaults] objectForKey:KPrefer_HHH_Thread];
    if (hhhThreadid) {
        _hhhThreadField.text = hhhThreadid;
    }
    
    frame.origin.x += _hhhKeyField.frame.size.width + dis;
    lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = @"-";
    lable.textColor = [UIColor whiteColor];
    lable.font = STFont(14*kScaleX);
    [NSUtils adjustLabelWeightToFitContent:lable];
    [self.view addSubview:lable];
    
    frame.size.height = textHeight;
    frame.origin.x += lable.frame.size.width + dis;
    _hhhSleepField = [self createTextField:frame holder:@"随机休眠上限"];
    _hhhSleepField.tag = kUIView_Field_HSleep_Tag;
    [self.view addSubview:_hhhSleepField];
    
    NSString *hhhsleep = [[NSUserDefaults standardUserDefaults] objectForKey:KPrefer_HHH_Sleep];
    if (hhhsleep) {
        _hhhSleepField.text = hhhsleep;
    }
    
    //程序运行结果
    //线程数
    y += liheHt;
    x = left;
    frame = CGRectMake(x, y, _LableWith, 24*kScaleX);
    lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = @"Running:";
    lable.textColor = [UIColor whiteColor];
    lable.font = STBoldFont(15*kScaleX);
    lable.textAlignment = NSTextAlignmentRight;
    [NSUtils adjustLabelHeightToFitContent:lable];
    ff = lable.frame;
    ff.origin.y += (textHeight - ff.size.height)/2;
    lable.frame = ff;
    [self.view addSubview:lable];
    
    frame.size.height = textHeight;
    frame.origin.x += lable.frame.size.width + dis*1.5;
    frame.size.width = textWidth;
    _hhhRunStateField = [self createTextField:frame holder:@"发送进度"];
    _hhhRunStateField.tag = kUIView_Field_HRunState_Tag;
    _hhhRunStateField.enabled = NO;
    [self.view addSubview:_hhhRunStateField];
    
    
    frame.origin.x += _hhhKeyField.frame.size.width + dis;
    lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = @"-";
    lable.textColor = [UIColor whiteColor];
    lable.font = STFont(14*kScaleX);
    [NSUtils adjustLabelWeightToFitContent:lable];
    [self.view addSubview:lable];
    
    frame.size.height = textHeight;
    frame.origin.x += lable.frame.size.width + dis;
    _hhhRunNumberField = [self createTextField:frame holder:@"发送批数"];
    _hhhRunNumberField.tag = kUIView_Field_HSleep_Tag;
    _hhhRunNumberField.enabled = NO;
    [self.view addSubview:_hhhRunNumberField];
    
    NSString *hhhrungroup = [[NSUserDefaults standardUserDefaults] objectForKey:KPrefer_HHH_Run_Number];
    if (hhhrungroup) {
        _hhhRunNumberField.text = hhhrungroup;
        _sendGroup = [hhhrungroup integerValue];
    }
    
    y += liheHt * 1.0;
    
    float wd = (self.view.frame.size.width - left*4)/3;
    _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _startBtn.layer.borderWidth = 1;
    _startBtn.layer.cornerRadius = 5;
    _startBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    //button2.backgroundColor = [UIColor orangeColor];
    _startBtn.frame = CGRectMake(left, y, wd, textHeight * 1.2);
    [_startBtn setTitle:@"Start" forState:UIControlStateNormal];
    [_startBtn addTarget:self action:@selector(startSend) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startBtn];
    
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.layer.borderWidth = 1;
    checkBtn.layer.cornerRadius = 5;
    checkBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    //button2.backgroundColor = [UIColor orangeColor];
    checkBtn.frame = CGRectMake(left*2+wd, y, wd, textHeight * 1.2);
    [checkBtn setTitle:@"Check" forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(toCheckTheResult) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkBtn];
    
    UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    otherBtn.layer.borderWidth = 1;
    otherBtn.layer.cornerRadius = 5;
    otherBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    //button2.backgroundColor = [UIColor orangeColor];
    otherBtn.frame = CGRectMake(left*3+wd*2, y, wd, textHeight * 1.2);
    [otherBtn setTitle:@"Other" forState:UIControlStateNormal];
    [otherBtn addTarget:self action:@selector(otherBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:otherBtn];
    
    y += otherBtn.frame.size.height + 15*kScaleX;
    
    frame.origin.x = left;
    frame.origin.y = y;
    frame.size.width = self.view.frame.size.width - left*2;
    frame.size.height = self.view.frame.size.height - y - 50*kScaleX;
    _logListView = [[LogListView alloc] initWithFrame:frame];
    _logListView.layer.borderWidth = 1;
    _logListView.layer.cornerRadius = 5;
    _logListView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.view addSubview:_logListView];
    
    
    y = self.view.frame.size.height - textHeight * 1.4;
    
    checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.layer.borderWidth = 1;
    checkBtn.layer.cornerRadius = 5;
    checkBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    //button2.backgroundColor = [UIColor orangeColor];
    checkBtn.frame = CGRectMake(left*3+wd, y, wd, textHeight * 1.2);
    [checkBtn setTitle:@"Exit" forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(toExit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkBtn];
    
    [self createErrorView];
    
    //[[STDebugManager shareDebugManager] setIsDebug:YES];
    //[TraceAnalysisDebug setDebugLevel:TraceAnalysisDebugLevelLog];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(traceActiveTimeLogNotificationFunction:) name:@"TraceActiveTimeLogNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(traceCampaignLogNotificationFunction:) name:@"TraceCampaignLogNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(traceIDFALogNotificationFunction:) name:@"TraceIDFALogNotification" object:nil];
}


- (void)createErrorView{
    float left = 10 * kScaleX;
    CGRect frame = CGRectMake(left, 0, self.view.frame.size.width - left * 2, 20);
    _errorView = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:_errorView];
    _errorView.backgroundColor = UIColorRGBAf(0, 0, 0, 1);
    _errorView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _errorView.layer.borderWidth = 1;
    _errorView.layer.cornerRadius = 5;
    _errorView.center = self.view.center;
    _errorView.hidden = YES;
    
    frame.origin.x = left;
    frame.origin.y = left;
    frame.size.width -= left*2;
    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = @"错误:";
    lable.textColor = [UIColor whiteColor];
    lable.font = STBoldFont(16*kScaleX);
    lable.textAlignment = NSTextAlignmentLeft;
    [NSUtils adjustLabelHeightToFitContent:lable];
    [_errorView addSubview:lable];
    
    CGRect ff = frame;
    ff.origin.y = frame.origin.y + frame.size.height + 7*kScaleX;
    ff.size.height = 0.75;
    UIView *line = [[UIView alloc] initWithFrame:ff];
    line.backgroundColor = [UIColor whiteColor];
    [_errorView addSubview:line];
    
    frame.origin.y = ff.origin.y + ff.size.height + left + 8*kScaleX;
    _errorMsgView = [[UILabel alloc] initWithFrame:frame];
    _errorMsgView.textAlignment = NSTextAlignmentCenter;
    _errorMsgView.textColor = [UIColor redColor];
    _errorMsgView.numberOfLines = 0;
    _errorMsgView.font = STFont(14*kScaleX);
    [_errorView addSubview:_errorMsgView];
    
    _errorCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _errorCloseButton.layer.borderWidth = 1;
    _errorCloseButton.layer.cornerRadius = 5;
    _errorCloseButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    float btnwidth = 100*kScaleX;
    float x = (_errorView.frame.size.width - btnwidth)/2;
    _errorCloseButton.frame = CGRectMake(x, 0, btnwidth, 28*kScaleX);
    [_errorCloseButton setTitle:@"关闭" forState:UIControlStateNormal];
    [_errorCloseButton.titleLabel setFont:STFont(15*kScaleX)];
    [_errorCloseButton addTarget:self action:@selector(CloseError) forControlEvents:UIControlEventTouchUpInside];
    [_errorView addSubview:_errorCloseButton];
    
}

- (void)showError:(NSString*)error{
    if (error) {
        _errorMsgView.text = error;
        [NSUtils adjustLabelHeightToFitContent:_errorMsgView];
        CGRect ff = _errorCloseButton.frame;
        ff.origin.y = _errorMsgView.frame.origin.y + _errorMsgView.frame.size.height;
        ff.origin.y += 20*kScaleX;
        _errorCloseButton.frame = ff;
        ff = _errorView.frame;
        ff.size.height =_errorCloseButton.frame.origin.y + _errorCloseButton.frame.size.height;
        ff.size.height += 15*kScaleX;
        _errorView.frame = ff;
        [_errorView setHidden:NO];
    }
    
}

- (void)CloseError{
    [_errorView setHidden:YES];
}

- (UITextField*)createTextField:(CGRect)frame holder:(NSString*)tip {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = tip;
    textField.font = STFont(14*kScaleX);
    textField.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.84];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.clearsOnBeginEditing = NO;
    textField.delegate = self;
    return textField;
}

- (void)adjustCenterH:(UIView*)v{
    CGPoint center = self.view.center;
    center.y = v.frame.origin.y + v.frame.size.height/2;
    v.center = center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)bgClick{
    [self hideKeyboard];
}

- (void)hideKeyboard {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


- (void)startSend{
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self dostartSend];
    //});
}

- (void)hideBoardInMainThread{
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        // do something  in main thread
        [self hideKeyboard];
    } else {
        // do something in main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideKeyboard];
        });
    }
}

- (void)dostartSend{
    [self addLogi:[NSString stringWithFormat:@"开始检查参数"]];
    [self hideBoardInMainThread];
    NSString * pid = _productField.text;
    if (!pid || pid.length == 0) {
        [self addLogv:[NSString stringWithFormat:@"==> 产品Id未输入"]];
        [self showError:@"必须输入产品Id,例如：999999"];
        return;
    }
    
    NSString * cid = _channelField.text;
    if (!cid || cid.length == 0) {
        [self addLogv:[NSString stringWithFormat:@"==> 渠道号未输入"]];
        [self showError:@"必须输入渠道Id,例如：32407"];
        return;
    }
    
    NSString * hkey = _hhhKeyField.text;
    if (!hkey || hkey.length == 0) {
        [self showError:@"必须输入事件Id,例如：TEST_AAA"];
        [self addLogv:[NSString stringWithFormat:@"==> 事件Key未输入"]];
        return;
    }
    _key = [hkey copy];
    NSString * hnumber = _hhhNumberField.text;
    if (!hnumber || hnumber.length == 0) {
        [self showError:@"必须输入发送数量,例如:200"];
        return;
    }
    
    NSInteger sendNum = [[NSString stringWithFormat:@"%@", hnumber] integerValue];
    if (sendNum <= 0) {
        [self addLogv:[NSString stringWithFormat:@"==> 事件发送数[%ld]低于下限，自动调整为200", sendNum]];
        sendNum = 200;
        _hhhNumberField.text = [NSString stringWithFormat:@"%ld", sendNum];
    }
    else {
        if (sendNum > 50000) {
            sendNum = 50000;
            [self addLogv:[NSString stringWithFormat:@"==> 事件发送数[%ld]高于上限，自动调整为50000", sendNum]];
            _hhhNumberField.text = [NSString stringWithFormat:@"%ld", sendNum];
        }
    }
    
    NSString * hthreadnumber = _hhhThreadField.text;
    if (!hthreadnumber || hthreadnumber.length == 0) {
        [self showError:@"必须输入并发线程数,例如:5，最多20个"];
        return;
    }
    
    NSInteger threadNum = [[NSString stringWithFormat:@"%@", hthreadnumber] integerValue];
    
    if (threadNum <=0) {
        [self addLogv:[NSString stringWithFormat:@"==> 线程并发数[%ld]低于下限，自动调整为5", threadNum]];
        threadNum = 5;
        _hhhThreadField.text = [NSString stringWithFormat:@"%ld", threadNum];
    }
    else if (threadNum > 20) {
        [self addLogv:[NSString stringWithFormat:@"==> 线程并发数[%ld]高于上限，自动调整为20", threadNum]];
        threadNum = 20;
        _hhhThreadField.text = [NSString stringWithFormat:@"%ld", threadNum];
    }
    
    NSString *sleeptime = _hhhSleepField.text;
    if (!sleeptime || sleeptime.length == 0) {
        [self showError:@"必须输入线程休眠最大上限（豪秒）,例如:1000"];
        return;
    }
    
    NSInteger sleep = [[NSString stringWithFormat:@"%@", sleeptime] integerValue];
    if (sleep < 0) {
        [self addLogv:[NSString stringWithFormat:@"==> 线程休眠时间[%ld]低于下限，自动调整为1000", sleep]];
        sleep = 1000;
        _hhhSleepField.text = [NSString stringWithFormat:@"%ld", sleep];
    }
    else if (sleep > 10000) {
        [self addLogv:[NSString stringWithFormat:@"==> 线程休眠时间[%ld]高于上限，自动调整为10000", sleep]];
        sleep = 10000;
        _hhhSleepField.text = [NSString stringWithFormat:@"%ld", sleep];
    }
    NSString *oldkey = [[NSUserDefaults standardUserDefaults] objectForKey:KPrefer_HHH_Key];
    if (oldkey && ![oldkey isEqualToString:hkey]) {
        _sendGroup = 0;
    }
    
    _sendNumber = sendNum;
    _sendGroup ++;
    _hhhRunNumberField.text = [NSString stringWithFormat:@"%ld", _sendGroup];
    
    [[NSUserDefaults standardUserDefaults] setObject:pid forKey: KPrefer_ProductId];
    [[NSUserDefaults standardUserDefaults] setObject:cid forKey: KPrefer_ChannelId];
    [[NSUserDefaults standardUserDefaults] setObject:hkey forKey: KPrefer_HHH_Key];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", sendNum] forKey: KPrefer_HHH_Number];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", threadNum] forKey: KPrefer_HHH_Thread];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", sleep] forKey: KPrefer_HHH_Sleep];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", _sendGroup] forKey: KPrefer_HHH_Run_Number];
    
    [self addLogi:@"----------------------------"];
    
    if (!_hasInited) {
        [self addLogi:@"初始化SDK："];
        [self addLogv:[NSString stringWithFormat:@"==> 产品ID：%@",pid]];
        [self addLogv:[NSString stringWithFormat:@"==> 渠道ID：%@",cid]];
        [self addLogv:[NSString stringWithFormat:@"==>   区域：%d",Test_Zone]];
        
        [TraceAnalysis initWithProductId:pid ChannelId:cid AppID:@"" zone:Test_Zone];
        //[TraceAnalysis initWithProductId:pid ChannelId:cid AppID:@""];
        //[TraceAnalysis disableAccessPrivacyInformation];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *ver = SDKVERSION;
            [self addLogv:[NSString stringWithFormat:@"==> SDKVer：%@",ver]];
        });
        _hasInited = YES;
    }
    
    [TraceAnalysis twitterLoginWithPlayerId:@"playid001" twitterId:1111 twitterUserName:@"name---1" twitterAuthToken:@"token"];
    
    _logThreads = [[LogEventThread alloc] init];
    _logThreads.sleepTime = sleep;
    _logThreads.sendCount = sendNum;
    _logThreads.key = hkey;
    _logThreads.threadCount = threadNum;
    _logThreads.groupId = _sendGroup;
    _logThreads.logEventCallback = self;
    [_logThreads start];
    _date = [NSDate date];
    
    [self addLogi:[NSString stringWithFormat:@"事件[%@]是否被禁止发送:", hkey]];
//    [self addLogv:([self canDispatchKey:hkey]?@"==> 否":@"==> 是")];
    [self addLogi:[NSString stringWithFormat:@"开始第%ld批，%ld条数据发送",_sendGroup, sendNum]];
    [self addLogv:@"前十条数据显示如下："];
    [_startBtn setEnabled:NO];
    
    
}

- (BOOL)canDispatchKey:(NSString*)key{
    
    return NO;
    
//    if (!key) {
//        return NO;
//    }
//    
//    int len = (int)[key length];
//    if (len > 128) {
//        return NO;
//    }
//    
//    const char* chars = [key UTF8String];
//    char *ptr = chars;
//    while (ptr && *ptr != '\0') {
//        char ch = *ptr;
//        if (ch < 32 || ch >= 127) {
//            return NO;
//        }
//        ptr ++;
//    }
//    
//    id value = [[TraceDataGlobalParam sharedInstance] getSendRuleOpenValueOfKey:key];
//    if (!value) {
//        return YES;
//    }
//    if ([value isKindOfClass:[NSString class]]) {
//        return [value isEqualToString:@"1"];
//    }
//    else if ([value isKindOfClass:[NSNumber class]]) {
//        return [value integerValue] == 1;
//    }
//    return NO;
}

- (void)addLogv:(NSString*)log{
    LogItemData *data = [LogItemData LogData:log];
    data.level = LOGLEVEL_v;
    [_logListView addLogData:data];
}

- (void)addLogi:(NSString*)log{
    LogItemData *data = [LogItemData LogData:log];
    data.level = LOGLEVEL_i;
    [_logListView addLogData:data];
}

- (void)addLogd:(NSString*)log{
    LogItemData *data = [LogItemData LogData:log];
    data.level = LOGLEVEL_d;
    [_logListView addLogData:data];
}

- (void)addLogw:(NSString*)log{
    LogItemData *data = [LogItemData LogData:log];
    data.level = LOGLEVEL_w;
    [_logListView addLogData:data];
}

- (void)addLoge:(NSString*)log{
    LogItemData *data = [LogItemData LogData:log];
    data.level = LOGLEVEL_e;
    [_logListView addLogData:data];
}

#pragma mark - text field listener

#define DEFAULT_PID  @"999999"
#define DEFAULT_CID  @"32407"
#define DEFAULT_SEND_NUM  @"20"
#define DEFAULT_THREAD  @"5"
#define DEFAULT_KEY @"event_key_zjy_3"
#define DEFAULT_SLEEP_TIME  @"200"


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == kUIView_Field_Pid_Tag) {
        NSString * t = [_productField text];
        if (!t || t.length == 0) {
            _productField.text=DEFAULT_PID;
        }
        [_productField becomeFirstResponder];
    }
    else if (textField.tag == kUIView_Field_Cid_Tag) {
        NSString * t = [_channelField text];
        if (!t || t.length == 0) {
            _channelField.text=DEFAULT_CID;
        }
    }
    else if (textField.tag == kUIView_Field_HNuberid_Tag) {
        NSString * t = [_hhhNumberField text];
        if (!t || t.length == 0) {
            _hhhNumberField.text=DEFAULT_SEND_NUM;
        }
        [_hhhNumberField becomeFirstResponder];
    }
    else if (textField.tag == kUIView_Field_HThread_Tag) {
        NSString * t = [_hhhThreadField text];
        if (!t || t.length == 0) {
            _hhhThreadField.text=DEFAULT_THREAD;
        }
        [_hhhThreadField becomeFirstResponder];
    }
    else if (textField.tag == kUIView_Field_HSleep_Tag) {
        NSString * t = [_hhhSleepField text];
        if (!t || t.length == 0) {
            _hhhSleepField.text=DEFAULT_SLEEP_TIME;
        }
        [_hhhSleepField becomeFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.tag == kUIView_Field_Pid_Tag) {
        NSString * t = [_channelField text];
        if (!t || t.length == 0) {
            _channelField.text=DEFAULT_CID;
        }
        [_channelField becomeFirstResponder];
    }
    else if (textField.tag == kUIView_Field_Cid_Tag) {
        [_hhhKeyField becomeFirstResponder];
    }
    else if (textField.tag == kUIView_Field_HKeyid_Tag) {
        NSString * t = [_hhhNumberField text];
        if (!t || t.length == 0) {
            _hhhNumberField.text=DEFAULT_SEND_NUM;
        }
        [_hhhNumberField becomeFirstResponder];
    }
    else if (textField.tag == kUIView_Field_HNuberid_Tag) {
        NSString * t = [_hhhThreadField text];
        if (!t || t.length == 0) {
            _hhhThreadField.text=DEFAULT_THREAD;
        }
        [_hhhThreadField becomeFirstResponder];
    }
    else if (textField.tag == kUIView_Field_HThread_Tag) {
        NSString * t = [_hhhSleepField text];
        if (!t || t.length == 0) {
            _hhhSleepField.text=DEFAULT_SLEEP_TIME;
        }
        [_hhhSleepField becomeFirstResponder];
    }
    else if (textField.tag == kUIView_Field_HSleep_Tag) {
        NSString * t = [_hhhSleepField text];
        if (t.length > 0) {
            [self startSend];
        }
        //[_hhhSleepField becomeFirstResponder];
    }
    return [textField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    switch (textField.tag) {
        case kUIView_Field_Pid_Tag:
        case kUIView_Field_Cid_Tag:
            return [toBeString length] < 7;
        case kUIView_Field_HKeyid_Tag:
            return [toBeString length] < 32;
        case kUIView_Field_HNuberid_Tag:
            return [toBeString length] < 6;
        case kUIView_Field_HThread_Tag:
            return [toBeString length] < 3;
        case kUIView_Field_HSleep_Tag:
            return [toBeString length] < 6;
        default:
            break;
    }
    
    return YES;
}

- (void)toExit{
    NSLog(@"will exit app.....");
    NSLog(@"will exit app.....");
    dispatch_async(dispatch_get_main_queue(), ^{
        exit(0);
    });
}


#pragma mark - event log send callback

- (void)eventLogCount:(NSInteger)logCount{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _hhhRunStateField.text = [NSString stringWithFormat:@"%ld", logCount];
    });
    
}

-(void)eventLogValue:(NSString *)value{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addLogv:value];
    });
}

- (void)eventLogFinish:(NSInteger)logCount{
    dispatch_async(dispatch_get_main_queue(), ^{
        _hhhRunStateField.text = [NSString stringWithFormat:@"%ld", logCount];
        [_startBtn setEnabled:YES];
    });
    double dif = [[NSDate date] timeIntervalSinceDate:_date];
    [self addLogi:[NSString stringWithFormat:@"[%ld]条数据已输出，共用时[%0.2lf]秒", _sendNumber, dif]];
    [self addLogi:@"实际数据可能还在后台发送中，请稍后点击‘Check’按钮检查结果"];
//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        [self toCheckTheResult];
//    });
    //
}

- (void)toCheckTheResult{
    if (_checking) {
        return;
    }
    if (!_hasInited) {
        NSString * pid = _productField.text;
        if (!pid || pid.length == 0) {
            [self addLoge:@"必须输入产品Id,例如：999999"];
            return;
        }

        NSString * cid = _channelField.text;
        if (!cid || cid.length == 0) {
            [self addLoge:@"必须输入渠道Id,例如：32407"];
            return;
        }
        [self addLogi:@"初始化SDK："];
        [self addLogv:[NSString stringWithFormat:@"==> 产品ID：%@",pid]];
        [self addLogv:[NSString stringWithFormat:@"==> 渠道ID：%@",cid]];
        [TraceAnalysis initWithProductId:pid ChannelId:cid AppID:@"" zone:Test_Zone];
        _hasInited = YES;
    }

//    _checking = YES;
//    [[TraceDBServiceImpl sharedInstance] sendOrder:[TraceDBOrder initWithExeVoidBlock:^(TraceSingleSafeDataBase *database) {
//        //
//
//        NSLog(@"UserId:%@",[TraceAnalysis staToken]);
////        NSLog(@"UserId:%@",[TraceAnalysis staToken]);
////        NSLog(@"UserId:%@",[TraceAnalysis staToken]);
////        NSLog(@"UserId:%@",[TraceAnalysis staToken]);
////        NSLog(@"UserId:%@",[TraceAnalysis staToken]);
//        if (!_key) {
//            _key = [_hhhKeyField text];
//        }
//        [self addLogi:@"----------------------------"];
//        NSString *sql = @"SELECT name FROM sqlite_master WHERE type='table' AND name='statisticalTable2_Temp';";
//        TraceResultSet *set = [database quaryData:sql];
//        if (!set.success || ![set hasNext]) {
//            [self addLogw:@"检测到发送结果的数据表未创建：statisticalTable2_Temp"];
//        }
//        else {
//            [self addLogi:@"发送备份数据表存在"];
//            [self addLogi:@"开始分析查询已发送数据"];
//
//            sql = [NSString stringWithFormat:@"select count(*) from statisticalTable2 where ei='%@';", _key];
//            set = [database quaryData:sql];
//            int leftNum = 0;
//            if (set.success && [set hasNext]) {
//                [self addLogv:[NSString stringWithFormat:@"==> 事件[%@]剩余发送数：[%d]条", _key, leftNum = [set intForColumnIndex:0]]];
//            }
//
//            //NSInteger date = (NSInteger)([_date timeIntervalSince1970] * 1000)-1000;
//            sql = [NSString stringWithFormat:@"select count(*) from statisticalTable2_Temp where ei='%@';", _key];
//            set = [database quaryData:sql];
//            if (!set.success || ![set hasNext]) {
//                [self addLoge:@"==> 发送数据查询失败，无法分析发送数"];
//            }
//            else{
//                int sendnum = [set intForColumnIndex:0];
//                [self addLogv:[NSString stringWithFormat:@"==> 事件[%@]发送数：[%d]条", _key, sendnum]];
//                [self addLogi:@"开始分析发送数据是否存在重复"];
//                sql = [NSString stringWithFormat:@"select count(dataid) from statisticalTable2_Temp where ei='%@' group by dataid having count(dataid)>1", _key];
//                set = [database quaryData:sql];
//                if (!set.success) {
//                    [self addLoge:@"==> 发送数据查询失败，无法分析重复数"];
//                }
//                else {
//                    int repeatnum = [set hasNext]?[set intForColumnIndex:0]:0;
//                    [self addLogv:[NSString stringWithFormat:@"==> 事件[%@]重复数：[%d]条", _key, repeatnum]];
//                    if (leftNum==0 && repeatnum == 0) {
//                        [self addLogv:[NSString stringWithFormat:@"==> 事件[%@]检测完成，无遗漏无重复", _key]];
//                        [self addLogv:[NSString stringWithFormat:@"==> userid:%@", [TraceAnalysis staToken]]];
//                    }
//                    else{
//                        [self addLogv:[NSString stringWithFormat:@"==> 事件[%@]检测完成，剩余[%d]条，重复[%d]条", _key, leftNum, repeatnum]];
//                        NSString *userid = [TraceAnalysis staToken];
//                        if (!userid){
//                            [self addLogv:[NSString stringWithFormat:@"==> userid:未获取，数据无法发送"]];
//                        }
//                        else{
//                            [self addLogv:[NSString stringWithFormat:@"==> userid:%@", userid]];
//                        }
//                    }
//                }
//            }
//        }
//        [self addLogi:@"----------------------------"];
//        _checking = NO;
//    }]];
}

- (void)otherBtnClick {
    OtherViewController *vc = [[OtherViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark - NSNotification

- (void)traceActiveTimeLogNotificationFunction:(NSNotification *)notification {
    NSString *msg = notification.object;
    [self addLogv:msg];
}

- (void)traceCampaignLogNotificationFunction:(NSNotification *)notification {
    NSString *msg = notification.object;
    [self addLogv:msg];
}

- (void)traceIDFALogNotificationFunction:(NSNotification *)notification {
    NSString *msg = notification.object;
    [self addLogv:msg];
}

@end
