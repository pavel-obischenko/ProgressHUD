#import "RadialGradientLayer.h"

@implementation RadialGradientLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.centerColor = [UIColor clearColor];
        self.radialColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
    }
    return self;
}

- (void)setCenterColor:(UIColor *)centerColor {
    _centerColor = centerColor;
    [self setNeedsDisplay];
}

- (void)setRadialColor:(UIColor *)radialColor {
    _radialColor = radialColor;
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx {
    size_t gradLocationsNum = 2;
    
    CGFloat gradLocations[2] = {
        0.0f, 1.0f
    };
    
    CGFloat gradColors[8] = {
        0, 0, 0, 0,
        0, 0, 0, 0
    };
    
    if (self.centerColor) {
        [self.centerColor getRed:&gradColors[0] green:&gradColors[1] blue:&gradColors[2] alpha:&gradColors[3]];
    }
    
    if (self.radialColor) {
        [self.radialColor getRed:&gradColors[4] green:&gradColors[5] blue:&gradColors[6] alpha:&gradColors[7]];
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint gradCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
    
    CGContextDrawRadialGradient (ctx, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
}

@end
