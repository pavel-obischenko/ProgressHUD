#import "SpinnerView.h"

#define RGB_COLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface SpinnerView ()

@property (nonatomic, strong) CAShapeLayer* progressLayer;
@property (nonatomic, assign) BOOL active;

@end

@implementation SpinnerView

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

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    self.animationDuration = 2.f;
 
    self.progressLayer = [CAShapeLayer new];
    
    self.progressLayer.fillColor = nil;
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.strokeStart = 0;
    self.progressLayer.strokeEnd = 0;
    
    [self.layer addSublayer:self.progressLayer];
    
    self.lineWidth = 2;
    
    self.lineColor = RGB_COLOR(71, 215, 254);
    self.shadowColor = RGB_COLOR(71, 215, 254);
    
    self.shadowRadius = 2.0f;
    self.shadowOpacity = 1.0f;
    self.shadowOffset = CGSizeZero;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(self.bounds, self.progressLayer.frame)) {
        [self layoutProgressLayer];
    }
}

- (void)layoutProgressLayer {
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
    CGFloat radius = CGRectGetHeight(self.bounds) / 2 - self.progressLayer.lineWidth;
    CGFloat startAngle = 0;
    CGFloat endAngle = 2.f * M_PI;
    
    self.progressLayer.path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES].CGPath;
    
    self.progressLayer.frame = self.bounds;
}

#pragma mark - Getters / Setters

- (void)setProgress:(CGFloat)progress {
    _progress = MAX(MIN(progress, 1.f), 0);
    
    if (progress > 0) {
        self.progressLayer.strokeStart = 0;
        self.progressLayer.strokeEnd = progress;
    }
    else {
        [self stop];
    }
}

- (void)setAngle:(CGFloat)angle {
    _angle = angle;
    self.progress = MAX(MIN(angle / (2 * M_PI), 1.f), 0);
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    self.progressLayer.lineWidth = lineWidth;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    self.progressLayer.strokeColor = lineColor.CGColor;
}

- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    self.progressLayer.shadowColor = shadowColor.CGColor;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    _shadowRadius = shadowRadius;
    self.progressLayer.shadowRadius = shadowRadius;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    _shadowOpacity = shadowOpacity;
    self.progressLayer.shadowOpacity = shadowOpacity;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    _shadowOffset = shadowOffset;
    self.progressLayer.shadowOffset = shadowOffset;
}

#pragma mark - Stop / Start

- (void)start {
    if (!self.active) {
        [self stop];
        
        self.active = YES;
        [self startInfinityAnimation];
    }
}

- (void)stop {
    self.active = NO;
    
    _progress = 0;
    _angle = 0;
    
    [self.progressLayer removeAllAnimations];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    self.progressLayer.strokeStart = 0;
    self.progressLayer.strokeEnd = 0;
    
    [CATransaction commit];
}

#pragma mark - Animations

- (void)startInfinityAnimation {
    CAKeyframeAnimation* rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.values = @[@(0), @(M_PI), @(2.f * M_PI)];
    
    CABasicAnimation* headAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    headAnimation.duration = self.animationDuration / 2.f;
    headAnimation.fromValue = @(0);
    headAnimation.toValue = @(.25f);
    
    CABasicAnimation* tailAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    tailAnimation.duration = self.animationDuration / 2.f;
    tailAnimation.fromValue = @(0);
    tailAnimation.toValue = @(1.f);
    
    CABasicAnimation* endHeadAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    endHeadAnimation.beginTime = self.animationDuration / 2.f;
    endHeadAnimation.duration = self.animationDuration / 2.f;
    endHeadAnimation.fromValue = @(.25f);
    endHeadAnimation.toValue = @(1.f);
    
    CABasicAnimation* endTailAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endTailAnimation.beginTime = self.animationDuration / 2.f;
    endTailAnimation.duration = self.animationDuration / 2.f;
    endTailAnimation.fromValue = @(1.f);
    endTailAnimation.toValue = @(1.f);
    
    CAAnimationGroup* animations = [CAAnimationGroup new];
    animations.duration = self.animationDuration;
    animations.animations = @[rotateAnimation, headAnimation, tailAnimation, endHeadAnimation, endTailAnimation];
    animations.repeatCount = INFINITY;
    animations.removedOnCompletion = YES;
    
    [self.progressLayer addAnimation:animations forKey:@"infinity"];
}

@end
