//
//  CustomNavController.m
//  Recipe
//
//  Created by samliu on 2017/2/15.
//  Copyright © 2017年 Tasty Story. All rights reserved.
//

#import "CustomNavController.h"
#import "AppBasicDefine.h"
#import "NSUtils.h"

@interface CustomNavController (){
  
}
@property(nonatomic)UIView *overlay;
@end



@implementation CustomNavController

#define STATUS_DEFAULT_HEIGHT 64

typedef NS_ENUM(NSInteger, NAVBARSTYLE) {
    NAV_TRANPARENT = 0,
    NAV_ONLY_COLOR,
    NAV_ONLY_IMAGE
};

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGRect frame = self.view.frame;
    if(frame.size.width != kDeviceWidth){
        frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
        self.view.frame = frame;
    }
}


//- (BOOL)shouldAutorotate{
//    if(isPadDevice){
//        return YES;
//    }
//    else{
//        return NO;
//    }
//}
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskLandscape;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
//    if(isPadDevice){
//        return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
//    }
//    else{
//        return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
//    }
//}

+ (void) setStatusBarTransparent:(UIViewController*) vc{
    [self changeStatusBar:vc withDrawable: nil type:NAV_TRANPARENT];
}

+ (void) setStatusBar:(UIViewController*) vc withColor:(UIColor*) color {
    [self changeStatusBar: vc withDrawable:color type:NAV_ONLY_COLOR];
}

+ (void) setStatusBar:(UIViewController*) vc withImage:(UIImage*) image {
    [self changeStatusBar: vc withDrawable:image type:NAV_ONLY_IMAGE];
}

- (void)initOverlayerView{
  self.initedOverlayerView = YES;
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  
  // insert an overlay into the view hierarchy
  self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20,
                                                          self.view.frame.size.width, self.view.frame.size.height + 20)];
  self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  
  [self.navigationController.navigationBar insertSubview:self.overlay atIndex:0];
}

- (void)setOverlayerViewBackground:(UIColor *)color{
  self.overlay.backgroundColor = color;
}

+(void) changeStatusBar:(UIViewController*) vc withDrawable:(id) drawable type:(NAVBARSTYLE) type {
    vc.navigationController.navigationBarHidden = NO;
    vc.navigationItem.hidesBackButton = YES;
    vc.navigationController.navigationBar.translucent = type == NAV_TRANPARENT;
    if (type != NAV_ONLY_IMAGE) {
      UIColor *color = type == NAV_TRANPARENT?[UIColor clearColor]:(UIColor*)drawable;
      //UINavigationController *nvc = vc.navigationController;
      if([vc.navigationController isKindOfClass:[CustomNavController class]]){
        CustomNavController *selfnav = (CustomNavController*)vc.navigationController;
        if (!selfnav.initedOverlayerView) {
          [selfnav initOverlayerView];
        }
        [selfnav setOverlayerViewBackground:color];
      }
      else{
        CGRect rect = CGRectMake(0, 0, vc.view.frame.size.width, STATUS_DEFAULT_HEIGHT);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [vc.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        if (type == NAV_ONLY_COLOR) {
          vc.navigationController.navigationBar.backgroundColor = (UIColor*)drawable;
        }
      }
      

        [vc.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
        
      
    }
    else {
        [vc.navigationController.navigationBar setBackgroundImage:(UIImage*)drawable forBarMetrics:UIBarMetricsDefault];
    }
    vc.navigationController.navigationBar.clipsToBounds = YES;
}

+ (void)setStatusBarTile:(UIViewController*) vc withTitle:(NSString*)title{
    vc.navigationItem.title = title;
}

+ (void) setStatusBarTile:(UIViewController*) vc withTitle:(NSString*) title height:(CGFloat) height color:(UIColor*) color font:(UIFont*)font; {
    CGRect frame = CGRectMake(0, 0, kDeviceWidth - 250, height);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = color;
    label.text = title;
    //label.center = CGPointMake(kDeviceWidth / 2, height / 2);
    // emboss in the same way as the native title
    [label setShadowColor:[UIColor darkGrayColor]];
    [label setShadowOffset:CGSizeMake(0, -0.5)];
    [NSUtils adjustLabelHeightToFitContent:label];
    vc.navigationItem.titleView = label;
}

+ (void)setStatusBarTile:(UIViewController*) vc withImage:(NSString*) name width:(CGFloat) width height:(CGFloat) height{
    CGRect frame = CGRectMake(0, 0, width, height);
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:frame];
    imgview.image = [UIImage imageNamed:name];
    imgview.contentMode = UIViewContentModeScaleAspectFit;
    vc.navigationItem.titleView = imgview;
}

+ (void)setStatusBarItem:(UIViewController*) vc withView:(UIView*) view leftitem:(BOOL) left action:(SEL) action {
  
  UIView * group = [[UIView alloc] initWithFrame:view.bounds];
  [group addSubview:view];
  UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
  backBtn.frame = view.bounds;
  backBtn.backgroundColor = [UIColor clearColor];
  [backBtn addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
  
  [group addSubview:backBtn];
  
  UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:group];
  
  if (left)
    vc.navigationItem.leftBarButtonItem = barItem;
  else
    vc.navigationItem.rightBarButtonItem = barItem;
}

+ (void)setStatusBarItem:(UIViewController*) vc withImage:(NSString*) name frame:(CGRect) frame leftitem:(BOOL) left action:(SEL) action {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = frame;
    [backBtn setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [backBtn addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

    if (left)
        vc.navigationItem.leftBarButtonItem = barItem;
    else
        vc.navigationItem.rightBarButtonItem = barItem;
}

+ (void)setStatusLeftItemArrowCircleBack:(UIViewController*)vc action:(SEL)action{
    //arrow-title-leftback
    CGRect frame = CGRectMake(0, 0, 30, 40);
    UIView *group = [[UIView alloc] initWithFrame:frame];
    
    CGFloat wd = 30;
    frame = CGRectMake(0, 0, wd, wd);
    UIView *circle = [[UIView alloc] initWithFrame:frame];
    circle.backgroundColor = [UIColor blackColor];
    circle.layer.cornerRadius = wd/2;
    [group addSubview:circle];
    frame = circle.frame;
    CGPoint center = CGPointMake(group.frame.size.width/2, group.frame.size.height/2);
    circle.center = center;
    
    frame = CGRectMake(0, 0, 10, 12);
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:frame];
    imageview.image = [UIImage imageNamed:@"back_left"];
    [group addSubview:imageview];
    center = CGPointMake(group.frame.size.width/2, group.frame.size.height/2);
    imageview.center = center;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = group.bounds;
    [group addSubview:btn];
    [btn addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:group];
    vc.navigationItem.leftBarButtonItem = barItem;
}

+ (void)setStatusLeftItemArrowBack:(UIViewController*)vc action:(SEL)action{
    //arrow-title-leftback
    CGRect frame = CGRectMake(0, 0, 20, 40);
    UIView *group = [[UIView alloc] initWithFrame:frame];
    
    frame = CGRectMake(0, 0, 20, 20);
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:frame];
    imageview.image = [UIImage imageNamed:@"arrow-title-leftback"];
    [group addSubview:imageview];
    CGPoint center = CGPointMake(frame.size.width/2, group.frame.size.height/2);
    imageview.center = center;
    
    frame = CGRectMake(20, 0, 45, 20);
    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    //lable.text = NSLocalized(@"lefBarItemBack");
    lable.font = STBoldFont(16*kScaleX);
    [NSUtils adjustLabelWeightToFitContent:lable];
    [group addSubview:lable];
    frame = lable.frame;
    center = CGPointMake(frame.origin.x + frame.size.width/2, group.frame.size.height/2);
    lable.center = center;
    
    frame = group.frame;
    frame.size.width = lable.frame.origin.x + lable.frame.size.width;
    group.frame = frame;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = group.bounds;
    [group addSubview:btn];
    [btn addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:group];
    vc.navigationItem.leftBarButtonItem = barItem;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
