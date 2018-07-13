#import "ProgressHUD.h"

#import "RadialGradientLayer.h"
#import "SpinnerView.h"

@interface ProgressHUD ()

@property (nonatomic, weak) UIView* containerView;
@property (nonatomic, strong) RadialGradientLayer* gradientLayer;

@property (nonatomic, strong) SpinnerView* spinnerView;

@property (nonatomic, assign) BOOL active;

@end

@implementation ProgressHUD

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self && ![self.subviews count]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithContainerView:(UIView*)view {
    self = [super initWithFrame:view.bounds];
    if (self) {
        [self commonInit];
        
        self.containerView = view;
        [self.containerView addSubview:self];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0;
    
    self.gradientLayer = [RadialGradientLayer new];
    [self.layer addSublayer:self.gradientLayer];
    
    self.userInteractionEnabled = NO;
    
    self.spinnerView = [[SpinnerView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self addSubview:self.spinnerView];
}

#pragma mark - Getters / Setters

- (void)setGradientCenterColor:(UIColor *)gradientCenterColor {
    _gradientCenterColor = gradientCenterColor;
    self.gradientLayer.centerColor = gradientCenterColor;
}

- (void)setGradientRadialColor:(UIColor *)gradientRadialColor {
    _gradientRadialColor = gradientRadialColor;
    self.gradientLayer.radialColor = gradientRadialColor;
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    
    self.spinnerView.lineColor = indicatorColor;
    self.spinnerView.shadowColor = indicatorColor;
}

#pragma mark - Show / Hide

- (void)show:(BOOL)animated {
    if (!self.active) {
        [self.spinnerView start];
        
        self.active = YES;
        [self.containerView addSubview:self];
        [self setNeedsLayout];
        
        [self.layer removeAllAnimations];
        
        [UIView animateWithDuration:animated ? .35f : 0 animations:^{
            self.alpha = 1.f;
        }];
    }
}

- (void)hide:(BOOL)animated {
    if (self.active) {
        self.active = NO;
        
        [UIView animateWithDuration:animated ? .35f : 0 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            if (!self.active) {
                [self.spinnerView stop];
                [self removeFromSuperview];
            }
        }];
    }
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.gradientLayer.frame = self.bounds;
    self.spinnerView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

@end
