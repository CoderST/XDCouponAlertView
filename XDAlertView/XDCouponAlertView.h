//
//  XDCouponAlertView.h
//  XDCouponAlertView
//
//  Created by xiudou on 16/3/24.
//  Copyright © 2016年 xiudo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDCouponAlertView;
@protocol XDCouponAlertViewDelegate <NSObject>

- (void)alertView:(XDCouponAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
@interface XDCouponAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message phone:(NSString *)phone delegate:(id /*<XDCouponAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)show;

@property (nonatomic,weak) id<XDCouponAlertViewDelegate> delegate;

@end
