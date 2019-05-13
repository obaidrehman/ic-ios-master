//
//  ImageEditing.h
//  Infinity Chess iOS
//
//  Created by user on 5/27/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HexColor.h"

@interface ImageEditing : NSObject



/// @description convert degrees to radians
/// @param degrees the value in degrees
/// @returns value in radians
+ (CGFloat) DegreesToRadians:(CGFloat)degrees;

/// @description convert radians to degrees
/// @param degrees the value in radians
/// @returns value in degrees
+ (CGFloat) RadiansToDegrees:(CGFloat)radians;

/// @description scales an image to the value specified
/// @param image the image that is to be scaled
/// @param scaleValue the value to which the image should be scaled, +ve values decreases size
/// @returns the scaled image
+ (UIImage *)ImageByScalingImage:(UIImage *)image ByValue:(CGFloat)scaleValue;

/// @description scales an image propotionally to the minimum size specified
/// @param image the image that is to be scaled
/// @param targetSize the value to which the image should be scaled
/// @returns the scaled image
+ (UIImage *)ImageByScalingImage:(UIImage*)image ProportionallyToMinimumSize:(CGSize)targetSize;

/// @description scales an image propotionally to the size specified
/// @param image the image that is to be scaled
/// @param targetSize the value to which the image should be scaled
/// @returns the scaled image
+ (UIImage *)ImageByScalingImage:(UIImage*)image ProportionallyToSize:(CGSize)targetSize;

/// @description scales an image unpropotionally to the size specified
/// @param image the image that is to be scaled
/// @param targetSize the value to which the image should be scaled
/// @returns the scaled image
+ (UIImage *)ImageByScalingImage:(UIImage*)image ToSize:(CGSize)targetSize;

/// @description rotate an image by an angle in degrees
/// @param image the image to rotate
/// @param degrees the angle in degrees to rotate by
/// @returns the rotated image
+ (UIImage *)ImageByRotatingImage:(UIImage*)image ByDegrees:(CGFloat)degrees;

/// @description rotate an image by an angle in radians
/// @param image the image to rotate
/// @param radians the angle in radians to rotate by
/// @returns the rotated image
+ (UIImage *)ImageByRotatingImage:(UIImage*)image ByRadians:(CGFloat)radians;

/// @description crop an image by top-right-bottom-left dimensions
/// @param image the image to crop
/// @param topRightBottomLeft the dimensions in int/float to crop by, specify as @[ @(0), @(0), @(0), @(0) ]
/// @returns the crop image
+ (UIImage *)ImageByCroppingImage:(UIImage *)image ByDimensions:(NSArray *)topRightBottomLeft;

/// @description crop an image to the size specified
/// @param image the image to crop
/// @param size the cropping size
/// @returns the crop image
+ (UIImage *)ImageByCroppingImage:(UIImage *)image toSize:(CGSize)size;

/// @description crop an image to the rectangle specified
/// @param image the image to crop
/// @param cropRect the cropping rectangle
/// @returns the crop image
+ (UIImage *)ImageByCroppingImage:(UIImage *)image toRectangle:(CGRect)cropRect;

/// @description gets the size i.e. width and height of the image
/// @returns the size of the image
+ (CGSize)ImageGetDimensionsForImage:(UIImage *)image;

/// @description this applies a tint color to an image and returns a uiimageview
/// @param imageView the reference image
/// @param tintColor the color to apply
+ (void) ImageApplyTintColorToImageView:(UIImageView*)imageView TintColor:(UIColor*)tintColor;


@end

@interface UIImage (tint)

- (UIImage *)tintedImageWithColor:(UIColor *)tintColor;
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;

@end
