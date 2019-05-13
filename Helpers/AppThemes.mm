//
//  ThemeTemplate.m
//  Infinity Chess iOS
//
//  Created by user on 3/17/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "AppThemes.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@implementation AppThemes

- (id)init
{
    self = [super init];
    if (self)
    {
        self.currentTheme = 0;
    }
    return self;
}

- (void)MainMenuBackGround:(UIView*)view { }
- (void)PlayOfflineBackground:(UIView*)view { }
- (void)PlayOnlineBackGround:(UIView*)view { }
- (void)AboutInfinityChessBackground:(UIView*)view
{
    switch (self.currentTheme)
    {
        case themeAllIsBlack:
            view.backgroundColor = [UIColor blackColor];
            break;
            
        case themeAllIsWhite:
            view.backgroundColor = [UIColor whiteColor];
            break;
            
        case themeDefault:
        {
            NSString *imageName = @"White_blank.png";
            UIGraphicsBeginImageContext(view.frame.size);
            [[UIImage imageNamed:imageName] drawInRect:view.bounds];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            image = [image applyLightEffect];
            UIColor *backGroundImage = [UIColor colorWithPatternImage:image];
            
            view.backgroundColor = backGroundImage;
        }
            break;
            
        default:
            break;
    }
}
- (void)OptionsBackground:(UIView*)view
{
    switch (self.currentTheme)
    {
        case themeAllIsBlack:
            view.backgroundColor = [UIColor blackColor];
            break;
            
        case themeAllIsWhite:
            view.backgroundColor = [UIColor whiteColor];
            break;
            
        case themeDefault:
        {
            NSString *imageName = @"White_blank.png";
            UIGraphicsBeginImageContext(view.frame.size);
            [[UIImage imageNamed:imageName] drawInRect:view.bounds];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            image = [image applyLightEffect];
            UIColor *backGroundImage = [UIColor colorWithPatternImage:image];
            
            view.backgroundColor = backGroundImage;
        }
            break;
            
        default:
            break;
    }
}

- (void)DefaultBackground:(UIView*)view
{
    switch (self.currentTheme)
    {
        case themeAllIsBlack:
            view.backgroundColor = [UIColor blackColor];
            break;
            
        case themeAllIsWhite:
            view.backgroundColor = [UIColor whiteColor];
            break;
            
        case themeDefault:
        {
            NSString *imageName = @"White_blank.png";
            UIGraphicsBeginImageContext(view.frame.size);
            [[UIImage imageNamed:imageName] drawInRect:view.bounds];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UIColor *backGroundImage = [UIColor colorWithPatternImage:image];
            
            view.backgroundColor = backGroundImage;
        }
            break;
            
        default:
            break;
    }
}


- (void)DefaultButton:(UIButton *)button
{
    button.layer.sublayers = nil;
    CALayer *layer = [CALayer layer];
    layer.frame = button.layer.bounds;
    layer.shadowRadius = 4.0f;
    layer.shadowOpacity = 0.15f;
    layer.shadowOffset = CGSizeZero;
    layer.cornerRadius = 15.0f;
    layer.masksToBounds = NO;
    
    switch (self.currentTheme)
    {
        case themeAllIsBlack:
            layer.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f].CGColor;
            layer.shadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f].CGColor;
            break;
            
        case themeAllIsWhite:
            layer.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f].CGColor;
            layer.shadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f].CGColor;
            layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.7f].CGColor;
            layer.borderWidth = 1.0f;
            break;
            
        case themeDefault:
            layer.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.7f].CGColor;
            layer.shadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f].CGColor;
            break;
            
        default:
            break;
    }

    [button.layer addSublayer:layer];
}

- (void)DefaultLabel:(UILabel *)label
{
    label.layer.shadowColor = label.textColor.CGColor;
    label.layer.shadowRadius = 2.0f;
    label.layer.shadowOpacity = 0.9f;
    label.layer.shadowOffset = CGSizeZero;
    label.layer.masksToBounds = NO;
}

- (void)DefaultTextField:(UITextField *)textField
{
    // for this plz add border style line to UI design first!
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, textField.layer.bounds.size.height -1, textField.layer.bounds.size.width, 1);
    layer.backgroundColor = [UIColor colorWithRed:19/255.0 green:144/255.0 blue:255/255.0 alpha:1.0].CGColor;
    layer.masksToBounds = NO;
    [textField.layer addSublayer:layer];
    textField.borderStyle = UITextBorderStyleNone;
}




- (void)ThemeBackGround:(UIView *)view IsOptional:(BOOL)optional
{
    switch (self.currentTheme)
    {
        case themeBlackAndYellow:
                [self BackGroundBlackAndYellow:view IsOptional:optional];
            break;
            
        default:
            break;
    }
}

- (void)ThemeButton:(UIButton *)button
{
    switch (self.currentTheme)
    {
        case themeBlackAndYellow:
            [self ButtonBlackAndYellow:button];
            break;
            
        default:
            break;
    }
}

- (void)ThemeLabel:(UILabel *)label
{
    switch (self.currentTheme)
    {
        case themeBlackAndYellow:
            [self LabelBlackAndYellow:label];
            break;
            
        default:
            break;
    }
}

- (void)ThemeTextField:(UITextField *)textField
{
    switch (self.currentTheme)
    {
        case themeBlackAndYellow:
            [self TextFieldBlackAndYellow:textField];
            break;
            
        default:
            break;
    }
}


- (void)BackGroundBlackAndYellow:(UIView *)view IsOptional:(BOOL)optional
{
    if (optional)
        view.backgroundColor = [UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
    else
        view.backgroundColor = [UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f];
}
- (void)ButtonBlackAndYellow:(UIButton *)button
{
    [button setTitleColor:[UIColor colorWithRed:1.0f green:1.0f blue:0.0f alpha:1.0f] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithRed:191.0f/255.0f green:193.0f/255.0f blue:183.0f/255.0f alpha:1.0f] forState:UIControlStateDisabled];
}
- (void)LabelBlackAndYellow:(UILabel *)label
{
    [label setTextColor:[UIColor colorWithRed:1.0f green:1.0f blue:0.0f alpha:1.0f]];
}
- (void)TextFieldBlackAndYellow:(UITextField *)textField
{
    // for this plz add border style line to UI design first!
    textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //textField.textAlignment = NSTextAlignmentCenter;
    
    textField.borderStyle = UITextBorderStyleLine;
    textField.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:0.0f alpha:1.0f];
    textField.backgroundColor = [UIColor clearColor];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0.0f, textField.layer.bounds.size.height - 1.0f, textField.layer.bounds.size.width, 1.0f);
    layer.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:0.0f alpha:1.0f].CGColor;
    layer.masksToBounds = NO;
    [textField.layer addSublayer:layer];
    textField.borderStyle = UITextBorderStyleNone;
}

@end





// image effects
@implementation UIView (ImageEffects)

-(UIImage *)convertViewToImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end


@implementation UIImage (ImageEffects)

- (UIImage *)applyLightEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [self applyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

- (UIImage *)applyExtraLightEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
    return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

- (UIImage *)applyDarkEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor
{
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    int componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2) {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    }
    else {
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return [self applyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                static_cast<CGFloat>(0.0722 + 0.9278 * s),  static_cast<CGFloat>(0.0722 - 0.0722 * s),  static_cast<CGFloat>(0.0722 - 0.0722 * s),  0,
                static_cast<CGFloat>(0.7152 - 0.7152 * s),  static_cast<CGFloat>(0.7152 + 0.2848 * s),  static_cast<CGFloat>(0.7152 - 0.7152 * s),  0,
                static_cast<CGFloat>(0.2126 - 0.2126 * s),  static_cast<CGFloat>(0.2126 - 0.2126 * s),  static_cast<CGFloat>(0.2126 + 0.7873 * s),  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

@end
