//
//  PEMTextFieldSlider.h
//  PEM
//
//  Created by Vladimir Hartmann on 20/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PEMAppDelegate.h"

@interface PEMTextFieldSlider : UIViewController <UITextFieldDelegate>

- (void)slideUp:(UIView *)view: (UITextField *)textField;
- (void)slideDown:(UIView *)view: (UITextField *)textField;

@end
