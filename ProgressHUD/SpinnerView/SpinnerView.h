#import <UIKit/UIKit.h>

@interface SpinnerView : UIView

@property (nonatomic, assign, readonly) BOOL active;
@property (nonatomic, assign) NSTimeInterval animationDuration;

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor* lineColor;

@property (nonatomic, strong) UIColor* shadowColor;
@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, assign) CGFloat shadowOpacity;
@property (nonatomic, assign) CGSize shadowOffset;

@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat progress;

- (void)start;
- (void)stop;

@end
