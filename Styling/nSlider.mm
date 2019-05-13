//
//  nSlider.m
//  Infinity Chess iOS
//
//  Created by user on 5/29/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "nSlider.h"

@implementation nSlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (MPVolumeView*) initAsMPVolumeViewWithOptionalImage:(UIImage*)volumeThumbImage
                                 OptionalMinimumImage:(UIImage*)minimumVolumeSliderImage
                                 OptionalMaximumImage:(UIImage*)maximumVolumeSliderImage
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    [volumeView setShowsVolumeSlider:YES];
    [volumeView setShowsRouteButton:YES];
    [volumeView sizeToFit];
    [volumeView setVolumeThumbImage:volumeThumbImage forState:UIControlStateNormal];
    [volumeView setMinimumVolumeSliderImage:minimumVolumeSliderImage forState:UIControlStateNormal];
    [volumeView setMaximumVolumeSliderImage:maximumVolumeSliderImage forState:UIControlStateNormal];
    
    return volumeView;
}


+ (nSlider*)nSliderWithSliderValue:(CGFloat)sliderValue
                 SliderMinimumValue:(CGFloat)sliderMinValue
                 SliderMaximumValue:(CGFloat)sliderMaxValue
            OptionalBackgroundColor:(UIColor*)backgroundColor
                      OptionalImage:(UIImage*)thumbImage
             OptionalImageTintColor:(UIColor*)thumbImageTintColor
          OptionalMinimumTrackImage:(UIImage*)minTrackImage
 OptionalMinimumTrackImageTintColor:(UIColor*)minTrackImageTintColor
          OptionalMaximumTrackImage:(UIImage*)maxTrackImage
 OptionalMaximumTrackImageTintColor:(UIColor*)maxTrackImageTintColor
{
    nSlider *slider = [[nSlider alloc] init];
    [slider sizeToFit];
    slider.minimumValue = (sliderMinValue >= 0.0f && sliderMinValue < 1.0f && sliderMinValue < sliderMaxValue) ?
                            sliderMinValue : 0.0f;
    slider.maximumValue = (sliderMaxValue > 0.0f && sliderMaxValue <= 1.0f && sliderMinValue < sliderMaxValue) ?
                            sliderMaxValue : 1.0f;
    slider.value = (sliderValue >= sliderMinValue && sliderValue <= sliderMaxValue) ? sliderValue : (sliderMaxValue + sliderMinValue) / 2;
    
    slider.continuous = YES;
    
    if (backgroundColor)        [slider setBackgroundColor:backgroundColor];
    if (thumbImage)             [slider setThumbImage:thumbImage forState:UIControlStateNormal];
    if (thumbImageTintColor)    [slider setThumbTintColor:thumbImageTintColor];
    if (minTrackImage)          [slider setMinimumTrackImage:minTrackImage forState:UIControlStateNormal];
    if (minTrackImageTintColor) [slider setMinimumTrackTintColor:minTrackImageTintColor];
    if (maxTrackImage)          [slider setMaximumTrackImage:maxTrackImage forState:UIControlStateNormal];
    if (maxTrackImageTintColor) [slider setMaximumTrackTintColor:maxTrackImageTintColor];
    
    return slider;
}

@end
