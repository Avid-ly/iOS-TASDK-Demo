//
//  CustomNavController.h
//  Recipe
//
//  Created by samliu on 2017/2/15.
//  Copyright © 2017年 Tasty Story. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavController : UINavigationController

@property(nonatomic) BOOL initedOverlayerView;

- (void)initOverlayerView;
- (void)setOverlayerViewBackground:(UIColor*)color;

+ (void)setStatusBarTransparent:(UIViewController*) vc;
+ (void)setStatusBar:(UIViewController*) vc withColor:(UIColor*) color;
+ (void)setStatusBar:(UIViewController*) vc withImage:(UIImage*) image;

+ (void)setStatusBarTile:(UIViewController*) vc withTitle:(NSString*)title;
+ (void)setStatusBarTile:(UIViewController*) vc withTitle:(NSString*) title height:(CGFloat) height color:(UIColor*) color font:(UIFont*)font;

+ (void)setStatusBarTile:(UIViewController*) vc withImage:(NSString*) name width:(CGFloat) width height:(CGFloat) height;

+ (void)setStatusBarItem:(UIViewController*) vc withView:(UIView*) view leftitem:(BOOL) left action:(SEL) action;
+ (void)setStatusBarItem:(UIViewController*) vc withImage:(NSString*) name frame:(CGRect) frame leftitem:(BOOL) left action:(SEL) action;

//just for iphone sencode view back
+ (void)setStatusLeftItemArrowCircleBack:(UIViewController*)vc action:(SEL)action;
+ (void)setStatusLeftItemArrowBack:(UIViewController*)vc action:(SEL)action;
@end
