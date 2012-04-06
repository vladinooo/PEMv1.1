//
//  PEMTextFieldSlider.m
//  PEM
//
//  Created by Vladimir Hartmann on 20/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PEMTextFieldSlider.h"

@implementation PEMTextFieldSlider

CGFloat animatedDistance;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 162;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;


- (void)slideUp:(UIView *)view: (UITextField *)textField {
    
    // code implemented by following http://cocoawithlove.com/2008/10/sliding-uitextfields-around-to-avoid.html
    
    // Get the rects of the text field being edited
    CGRect textFieldRect = [view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [view.window convertRect:view.bounds fromView:view];
    
    // Calculate the fraction between the top and bottom of the middle section for the text field's midline
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    // Clamp this fraction
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    // Convert it into an amount to scroll by multiplying by the keyboard height for the current screen orientation
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    // Apply the animation
    CGRect viewFrame = view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


- (void)slideDown:(UIView *)view: (UITextField *)textField {

    CGRect viewFrame = view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

@end
