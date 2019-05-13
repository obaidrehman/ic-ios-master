//
//  nSlider.h
//  Infinity Chess iOS
//
//  Created by user on 5/29/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface nSlider : UISlider

@property (strong) NSString* tagString;
@property (strong) NSObject* extraInfo;

+ (MPVolumeView*) initAsMPVolumeViewWithOptionalImage:(UIImage*)volumeThumbImage
                            OptionalMinimumImage:(UIImage*)MinimumVolumeSliderImage
                            OptionalMaximumImage:(UIImage*)MaximumVolumeSliderImage;

+ (nSlider*)nSliderWithSliderValue:(CGFloat)sliderValue
                SliderMinimumValue:(CGFloat)sliderMinValue
                SliderMaximumValue:(CGFloat)sliderMaxValue
           OptionalBackgroundColor:(UIColor*)backgroundColor
                     OptionalImage:(UIImage*)thumbImage
            OptionalImageTintColor:(UIColor*)thumbImageTintColor
         OptionalMinimumTrackImage:(UIImage*)minTrackImage
OptionalMinimumTrackImageTintColor:(UIColor*)minTrackImageTintColor
         OptionalMaximumTrackImage:(UIImage*)maxTrackImage
OptionalMaximumTrackImageTintColor:(UIColor*)maxTrackImageTintColor;

@end
