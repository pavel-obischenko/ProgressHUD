#import <UIKit/UIKit.h>

@interface ProgressHUD : UIView

@property (nonatomic, strong) UIColor* gradientCenterColor;
@property (nonatomic, strong) UIColor* gradientRadialColor;
@property (nonatomic, strong) UIColor* indicatorColor;

- (instancetype)initWithContainerView:(UIView*)view;

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end
