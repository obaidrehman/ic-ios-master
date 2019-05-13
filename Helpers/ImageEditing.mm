//
//  ImageEditing.m
//  Infinity Chess iOS
//
//  Created by user on 5/27/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "ImageEditing.h"

@implementation ImageEditing

+ (CGFloat) DegreesToRadians:(CGFloat)degrees { return degrees * M_PI / 180; }
+ (CGFloat) RadiansToDegrees:(CGFloat)radians { return radians * 180 / M_PI; }


+ (UIImage *)ImageByScalingImage:(UIImage *)image ByValue:(CGFloat)scaleValue
{
    if (image)
    {
        // scaling
        UIImage *scaledImage = [UIImage imageWithCGImage:[image CGImage]
                                                   scale:(image.scale * scaleValue)
                                             orientation:(image.imageOrientation)];
        return scaledImage;
    }
    
    return nil;
}


+ (UIImage *)ImageByScalingImage:(UIImage*)image ProportionallyToMinimumSize:(CGSize)targetSize
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}


+ (UIImage *)ImageByScalingImage:(UIImage*)image ProportionallyToSize:(CGSize)targetSize
{
    
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}


+ (UIImage *)ImageByScalingImage:(UIImage*)image ToSize:(CGSize)targetSize
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    //   CGSize imageSize = sourceImage.size;
    //   CGFloat width = imageSize.width;
    //   CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    //   CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}


+ (UIImage *)ImageByRotatingImage:(UIImage*)image ByDegrees:(CGFloat)degrees
{
    return [ImageEditing ImageByRotatingImage:image ByRadians:[ImageEditing DegreesToRadians:degrees]];
}


+ (UIImage *)ImageByRotatingImage:(UIImage*)image ByRadians:(CGFloat)radians
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, radians);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}


+ (UIImage *)ImageByCroppingImage:(UIImage *)image ByDimensions:(NSArray *)topLeftBottomRight
{
    @try
    {
        CGSize imageSize = [ImageEditing ImageGetDimensionsForImage:image];
        
        BOOL validCropDimensions = YES;
        if ([topLeftBottomRight[0] floatValue] < 0 ||
            [topLeftBottomRight[1] floatValue] < 0 ||
            [topLeftBottomRight[2] floatValue] < 0 ||
            [topLeftBottomRight[3] floatValue] < 0 ||
            [topLeftBottomRight[0] floatValue] > imageSize.height ||
            [topLeftBottomRight[1] floatValue] > imageSize.width ||
            [topLeftBottomRight[2] floatValue] > imageSize.height ||
            [topLeftBottomRight[3] floatValue] > imageSize.width ||
            [topLeftBottomRight[0] floatValue] + [topLeftBottomRight[2] floatValue] > imageSize.height ||
            [topLeftBottomRight[1] floatValue] + [topLeftBottomRight[3] floatValue] > imageSize.width)
                validCropDimensions = NO;
        if (!validCropDimensions) return nil;
        
        
        
        CGRect cropRect = CGRectMake([topLeftBottomRight[1] floatValue],
                                     [topLeftBottomRight[0] floatValue],
                                     imageSize.width - [topLeftBottomRight[3] floatValue],
                                     imageSize.height - [topLeftBottomRight[2] floatValue]);
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
        
        UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:image.imageOrientation];
        CGImageRelease(imageRef);
        return croppedImage;
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception.description);
    }
   
    return nil;
}

+ (UIImage *)ImageByCroppingImageWithName:(NSString *)imageName ByDimensions:(NSArray *)topLeftBottomRight
{
    @try
    {
        UIImage *image = [UIImage imageNamed:imageName];
        CGSize imageSize = [ImageEditing ImageGetDimensionsForImage:image];
        
        BOOL validCropDimensions = YES;
        if ([topLeftBottomRight[0] floatValue] < 0 ||
            [topLeftBottomRight[1] floatValue] < 0 ||
            [topLeftBottomRight[2] floatValue] < 0 ||
            [topLeftBottomRight[3] floatValue] < 0 ||
            [topLeftBottomRight[0] floatValue] > imageSize.height ||
            [topLeftBottomRight[1] floatValue] > imageSize.width ||
            [topLeftBottomRight[2] floatValue] > imageSize.height ||
            [topLeftBottomRight[3] floatValue] > imageSize.width ||
            [topLeftBottomRight[0] floatValue] + [topLeftBottomRight[2] floatValue] > imageSize.height ||
            [topLeftBottomRight[1] floatValue] + [topLeftBottomRight[3] floatValue] > imageSize.width)
            validCropDimensions = NO;
        if (!validCropDimensions) return nil;
        
        
        
        CGRect cropRect = CGRectMake([topLeftBottomRight[1] floatValue],
                                     [topLeftBottomRight[0] floatValue],
                                     imageSize.width - [topLeftBottomRight[3] floatValue],
                                     imageSize.height - [topLeftBottomRight[2] floatValue]);
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
        
        UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:image.imageOrientation];
        CGImageRelease(imageRef);
        return croppedImage;
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception.description);
    }
    
    return nil;
}

+ (UIImage *)ImageByCroppingImage:(UIImage *)image toSize:(CGSize)size
{
    double x = (image.size.width - size.width) / 2.0;
    double y = (image.size.height - size.height) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, size.height, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return croppedImage;
}

+ (UIImage *)ImageByCroppingImageWithName:(NSString *)imageName toSize:(CGSize)size
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    double x = (image.size.width - size.width) / 2.0;
    double y = (image.size.height - size.height) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, size.height, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

+ (UIImage *)ImageByCroppingImage:(UIImage *)image toRectangle:(CGRect)cropRect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

+ (UIImage *)ImageByCroppingImageWithName:(NSString *)imageName toRectangle:(CGRect)cropRect
{
    UIImage *image = [UIImage imageNamed:imageName];
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

+ (CGSize)ImageGetDimensionsForImage:(UIImage *)image
{
    return image.size;
}

+ (CGSize)ImageGetDimensionsForImageWithName:(NSString *)imageName
{
    UIImage* image = [UIImage imageNamed:imageName];
    if (image)
        return image.size;
    return CGSizeMake(0.0f, 0.0f);
}

+ (void) ImageApplyTintColorToImageView:(UIImageView*)imageView TintColor:(UIColor*)tintColor
{
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imageView setTintColor:tintColor];
}

@end

@implementation UIImage (tint)

- (UIImage *)tintedImageWithColor:(UIColor *)tintColor
{
    // It's important to pass in 0.0f to this function to draw the image to the scale of the screen
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end