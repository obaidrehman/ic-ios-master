//
//  nImageTextButtonElegant.m
//  Infinity Chess iOS
//
//  Created by user on 23/06/2015.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "nImageTextButtonElegant.h"

@implementation nImageTextButtonElegant


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//    UIBezierPath *pathBorder = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:self.imageOnLeftSide ? (UIRectCornerBottomRight | UIRectCornerTopRight) : (UIRectCornerBottomLeft | UIRectCornerTopLeft) cornerRadii:CGSizeMake(self.buttonCornerRadius, self.buttonCornerRadius)];
    UIBezierPath *pathBorder = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.buttonCornerRadius];
    [pathBorder setLineWidth:0.5];
    [[UIColor whiteColor] setStroke];
    [pathBorder stroke];
    
    // Drawing code
    if (self.imageName && !self.imageName.isEmptyOrWhiteSpaces)
    {
        CGRect contentRect = CGRectMake(rect.origin.x + self.contentPadding * 2,
                                        rect.origin.y + self.contentPadding,
                                        rect.size.width - self.contentPadding * 4,
                                        rect.size.height - self.contentPadding * 2);
        
        CGFloat imageDimension = MIN(contentRect.size.width, contentRect.size.height) + self.imageScalingValue * 2;
        CGRect imageRect = self.imageOnLeftSide ?
        CGRectMake(contentRect.origin.x - self.imageScalingValue, contentRect.origin.y - self.imageScalingValue, imageDimension, imageDimension) :
        CGRectMake(contentRect.size.width - imageDimension - self.imageScalingValue, contentRect.origin.y - self.imageScalingValue, imageDimension, imageDimension);
     
        
        UIImage *image = [UIImage imageNamed:self.imageName];
        if (!image)
            return;
        image = [image tintedImageWithColor:[UIColor whiteColor]];
        [image drawInRect:imageRect];
        
        
        NSString *text = [NSString stringWithFormat:@"%@", self.titleLabel.text];
        UIFont *textFont = self.titleLabel.font;
        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle alloc] init];
        [textStyle setAlignment:NSTextAlignmentCenter];
        UIColor *textColor = [UIColor whiteColor];
        NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        textFont, NSFontAttributeName,
                                        textColor, NSForegroundColorAttributeName,
                                        textStyle, NSParagraphStyleAttributeName, nil];
        
        self.titleLabel.text = @"";
        
        CGRect textRect = self.imageOnLeftSide ?
        CGRectMake(contentRect.origin.x + imageDimension, CGRectGetMidY(contentRect) - textFont.lineHeight / 2, contentRect.size.width - imageDimension, contentRect.size.height) :
        CGRectMake(contentRect.origin.x, CGRectGetMidY(contentRect) - textFont.lineHeight / 2, contentRect.size.width - imageDimension, contentRect.size.height);
        

        [text drawInRect:textRect withAttributes:textAttributes];
    }
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
}


@end
