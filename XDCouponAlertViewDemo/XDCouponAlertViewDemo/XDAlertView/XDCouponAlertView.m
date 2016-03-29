//
//  XDCouponAlertView.m
//  XDCouponAlertView
//
//  Created by xiudou on 16/3/24.
//  Copyright © 2016年 xiudo. All rights reserved.
//

#import "XDCouponAlertView.h"
#import <objc/runtime.h>
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
// setting
#define POPUP_VIEW_WIDTH 280    // popupView  宽度
#define BUTTON_TITLES_VIEW_HEIGHT 44   // buttonTitlesView宽度
// 顶部间距
#define TITLELVIEW_TOP_MARGIN 20 // titleView 距离popup顶部距离
#define MESSAGEVIEW_TOP_MARGIN 20 // messageView 顶部距离
#define PHONEVIEW_TOP_MARGIN 20 // phoneView 顶部距离
#define BUTTONTITLE_TOP_MARGIN 10 // button 顶部间距

// 最大宽度
#define TITLELABLE_MAX_WIDTH (POPUP_VIEW_WIDTH - 20) // titleLabel最大宽度
#define MESSAGE_MAX_WIDTH (POPUP_VIEW_WIDTH - 20)
#define PHONE_MAX_WIDTH (POPUP_VIEW_WIDTH - 20)

// 文字行间距
#define TITLE_LINE_SPACE 5
#define MESSAGE_LINE_SPACE 5
#define PHONE_LINE_SPACE 5

// 字体大小
#define TITLE_FONT  12
#define MESSAGE_FONT  12
#define PHONE_FONT  12

@interface XDCouponAlertView ()
// 初始化参数
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) NSString *phone;

// button相关数组
@property (nonatomic,strong) NSMutableArray *buttonTitlesArray;
@property (nonatomic,strong) NSMutableArray *buttonArray;

// 引用UI
@property (nonatomic,weak) UIView *screenView;
@property (nonatomic,weak) UIView *popupView;
@property (nonatomic,weak) UIView *titleView;
@property (nonatomic,weak) UIView *messageView;
@property (nonatomic,weak) UIView *phoneView;
@property (nonatomic,weak) UIView *buttonTitlesView;

// 显示子控件
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UILabel *messageLabel;
@property (nonatomic,weak) UILabel *phoneLabel;

// 尺寸相关
@property (nonatomic,assign) CGFloat popupHeight;
@end
@implementation XDCouponAlertView

- (NSMutableArray *)buttonTitlesArray{
    if (_buttonTitlesArray == nil) {
        _buttonTitlesArray = [NSMutableArray array];
    }
    return _buttonTitlesArray;
}

- (NSMutableArray *)buttonArray{
    if (_buttonArray == nil) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.screenView];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message phone:(NSString *)phone delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)buttonTitles, ...{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _title = title;
        _message = message;
        _phone = phone;
        va_list args;
        va_start(args,buttonTitles);
        if (buttonTitles) {
            [self.buttonTitlesArray addObject:buttonTitles];
            while (1) {
                NSString *otherButtonTitle = va_arg(args, NSString *);
                if (otherButtonTitle == nil) {
                    break;
                }else{
                    [self.buttonTitlesArray addObject:otherButtonTitle];
                }
                
            }
        }
        
        // 创建蒙版
        UIView *screenView = [[UIView alloc] initWithFrame:self.bounds];
        screenView.backgroundColor = [UIColor blackColor];
        screenView.alpha = 0.5;
        [self addSubview:screenView];
        self.screenView = screenView;
        
        // 创建中间弹出框
        [self setUpPopupView];
        // 创建titleView
        [self setUpTitleView];
        // 创建messageView
        [self setUpMessageView];
        // 创建phoneView
        [self setUpPhoneView];
        // 创建buttonTitlesView
        [self setUpButtonTitlesView];
        // 创建线
        [self setUpButtonTitlesViewLine];
        
        self.popupView.frame = CGRectMake(0, 0, POPUP_VIEW_WIDTH, self.popupHeight);
        self.popupView.center = CGPointMake(self.screenView.center.x, self.screenView.center.y);
    }
    
    return self;
}

// SET_UP_VIEW
- (void)setUpPopupView{
    
    self.popupHeight = 0;
    UIView *popupView = [[UIView alloc] init];
    popupView.backgroundColor = [UIColor whiteColor];
    [self addSubview:popupView];
    self.popupView = popupView;
}

- (void)setUpTitleView{
    if (_title != nil) {
        UIView *titleView = [[UIView alloc] init];
        titleView.backgroundColor = [UIColor redColor];
        [self.popupView addSubview:titleView];
        self.titleView = titleView;
        
        CGRect titleRect = [self getRectWithFont:[UIFont systemFontOfSize:TITLE_FONT] lineSpacing:TITLE_LINE_SPACE maxWidth:TITLELABLE_MAX_WIDTH title:self.title];
        self.titleLabel.frame = CGRectMake((POPUP_VIEW_WIDTH - titleRect.size.width) * 0.5, 0, titleRect.size.width, titleRect.size.height);
        
        // 更新titleView的frame
        self.titleView.frame = CGRectMake(0, TITLELVIEW_TOP_MARGIN, POPUP_VIEW_WIDTH, CGRectGetHeight(self.titleLabel.frame));
        
        self.popupHeight += self.titleView.frame.size.height + TITLELVIEW_TOP_MARGIN;
        
        NSLog(@"%f",self.popupHeight);
    }
    
}

- (void)setUpMessageView{
    if (_message != nil) {
        UIView *messageView = [[UIView alloc] init];
        messageView.backgroundColor = [UIColor yellowColor];
        [self.popupView addSubview:messageView];
        self.messageView = messageView;
        
        CGRect messaageRect = [self getRectWithFont:[UIFont systemFontOfSize:MESSAGE_FONT] lineSpacing:MESSAGE_LINE_SPACE maxWidth:TITLELABLE_MAX_WIDTH title:self.title];
        self.messageLabel.frame = CGRectMake((POPUP_VIEW_WIDTH - messaageRect.size.width) * 0.5, 0, messaageRect.size.width, messaageRect.size.height);
        
        // 更新messageView的frame
        self.messageView.frame = CGRectMake(0,MESSAGEVIEW_TOP_MARGIN + CGRectGetMaxY(self.titleView.frame) , POPUP_VIEW_WIDTH, CGRectGetHeight(self.messageLabel.frame));
        
        self.popupHeight += self.messageView.frame.size.height + MESSAGEVIEW_TOP_MARGIN;
        
    }
    
}

- (void)setUpPhoneView{
    if (_phone != nil) {
        UIView *phoneView = [[UIView alloc] init];
        phoneView.backgroundColor = [UIColor blueColor];
        [self.popupView addSubview:phoneView];
        self.phoneView = phoneView;
        
        CGRect phoneRect = [self getRectWithFont:[UIFont systemFontOfSize:PHONE_FONT]  lineSpacing:PHONE_LINE_SPACE maxWidth:TITLELABLE_MAX_WIDTH title:self.phone];
        self.phoneLabel.frame = CGRectMake((POPUP_VIEW_WIDTH - phoneRect.size.width) * 0.5, 0, phoneRect.size.width, phoneRect.size.height);
        
        // 更新phoneView的frame
        CGFloat margin = 0;
        if (_message != nil) {
            margin = CGRectGetMaxY(self.messageView.frame);
        }else{
            margin = CGRectGetMaxY(self.titleView.frame);
        }
        self.phoneView.frame = CGRectMake(0,PHONEVIEW_TOP_MARGIN + margin, POPUP_VIEW_WIDTH, phoneRect.size.height);
        
        self.popupHeight += self.phoneView.frame.size.height + PHONEVIEW_TOP_MARGIN;
    }
    
    
}

- (void)setUpButtonTitlesView{
    
    if (self.buttonTitlesArray.count) {
        UIView *buttonTitlesView = [[UIView alloc] init];
        buttonTitlesView.backgroundColor = [UIColor redColor];
        [self.popupView addSubview:buttonTitlesView];
        self.buttonTitlesView = buttonTitlesView;
        
        self.popupHeight += BUTTON_TITLES_VIEW_HEIGHT + BUTTONTITLE_TOP_MARGIN;
        self.buttonTitlesView.frame = CGRectMake(0, self.popupHeight - BUTTON_TITLES_VIEW_HEIGHT, POPUP_VIEW_WIDTH, BUTTON_TITLES_VIEW_HEIGHT);
        

        for (int i = 0; i < self.buttonTitlesArray.count; i ++) {
            UIButton *button = [[UIButton alloc] init];
            NSString *buttonTitle = self.buttonTitlesArray[i];
            button.tag = i;
            [button setTitle:buttonTitle forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonArray addObject:button];
            [self.buttonTitlesView addSubview:button];
        }
        
        NSInteger buttonCount = self.buttonArray.count;
        CGFloat buttonWidth = self.buttonTitlesView.frame.size.width / buttonCount;
        for (int index = 0; index < buttonCount;index++) {
            UIButton *button = self.buttonArray[index];
            
            button.frame = CGRectMake(index * buttonWidth, 0, buttonWidth, BUTTON_TITLES_VIEW_HEIGHT);
        }
    }
}

- (void)setUpButtonTitlesViewLine{
    NSInteger buttonCount = self.buttonArray.count;
    if (buttonCount) {
        UIButton *button = self.buttonArray[0];
        CGFloat lineView_Y = 0;
        CGFloat lineView_W = 0.5;
        CGFloat lineView_H = self.buttonTitlesView.frame.size.height;
        for (int i = 0; i < buttonCount; i ++) {
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = [UIColor blackColor];
            CGFloat lineView_X = 0;
            if (i == 0) {
                lineView_W = 0;
            }else{
                lineView_W = 0.5;
                
            }
            lineView_X = button.frame.size.width * i;
            
            lineView.frame = CGRectMake(lineView_X, lineView_Y, lineView_W, lineView_H);
            [self.buttonTitlesView addSubview:lineView];
        }
    }

}

// SET_UP_SUBVIEW
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.backgroundColor = [UIColor grayColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;  // 默认居中对齐
        titleLabel.textColor = [UIColor blackColor];  // 默认黑色
        titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT]; // 默认系统12号字体
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = TITLE_LINE_SPACE;
        NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle};
        titleLabel.attributedText = [[NSAttributedString alloc]initWithString:self.title attributes:attributes];

        [self.titleView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel{
    if (_messageLabel == nil) {
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = 0;
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.backgroundColor = [UIColor grayColor];
//        messageLabel.text = _message;
        messageLabel.textAlignment = NSTextAlignmentCenter;  // 默认居中对齐
        messageLabel.textColor = [UIColor blackColor];  // 默认黑色
        messageLabel.font = [UIFont systemFontOfSize:MESSAGE_FONT]; // 默认系统12号字体
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = MESSAGE_LINE_SPACE;
        NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle};
        messageLabel.attributedText = [[NSAttributedString alloc]initWithString:self.message attributes:attributes];

        [self.messageView addSubview:messageLabel];
        self.messageLabel = messageLabel;
    }
    return _messageLabel;
}

- (UILabel *)phoneLabel{
    if (_phoneLabel == nil) {
        UILabel *phoneLabel = [[UILabel alloc] init];
        phoneLabel.numberOfLines = 0;
        phoneLabel.lineBreakMode = NSLineBreakByWordWrapping;
        phoneLabel.backgroundColor = [UIColor grayColor];
        phoneLabel.textAlignment = NSTextAlignmentCenter;  // 默认居中对齐
        phoneLabel.textColor = [UIColor blackColor];  // 默认黑色
        phoneLabel.font = [UIFont systemFontOfSize:PHONE_FONT]; // 默认系统12号字体
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = PHONE_LINE_SPACE;
        NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle};
        phoneLabel.attributedText = [[NSAttributedString alloc]initWithString:self.phone attributes:attributes];

        [self.phoneView addSubview:phoneLabel];
        self.phoneLabel = phoneLabel;
    }
    return _phoneLabel;
}

// 计算文字frame
- (CGRect)getRectWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing maxWidth:(CGFloat)maxWidth title:(NSString *)title{
    UIFont *titleFont = font; // 默认系统12号字体
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle  alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;  // line spacing
    NSDictionary *attributes = [NSDictionary dictionary];
    attributes = @{NSFontAttributeName : titleFont,
                   NSParagraphStyleAttributeName : paragraphStyle.copy
                   };
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    return titleRect;
}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    [window addSubview:self];
    [self showBackground];
    [self showAlertAnimation];
}

- (void)dismis{
    [self dismissAlertAnimation];
    [self removeFromSuperview];
}
-(void)showAlertAnimation
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.30;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.popupView.layer addAnimation:animation forKey:nil];
}

- (void)showBackground
{
    self.screenView.alpha = 0;
    [UIView beginAnimations:@"screenViewID" context:nil];
    [UIView setAnimationDuration:0.35];
    self.screenView.alpha = 0.6;
    [UIView commitAnimations];
}

- (void)dismissAlertAnimation{
    [UIView beginAnimations:@"screenViewID" context:nil];
    [UIView setAnimationDuration:0.35];
    self.screenView.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)buttonAction:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:button.tag];
        
    }
    [self dismis];
}
@end
