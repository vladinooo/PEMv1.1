//
//  PEMTextFieldValidation.h
//  PEM
//
//  Created by Vladimir Hartmann on 15/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//



@interface PEMTextFieldValidation : NSObject

- (BOOL)isFieldEmpty: (UITextField *)textField;
- (BOOL)isValidEmail: (NSString *)emailEntry;
- (BOOL)doPasswordsMatch: (UITextField *)password1: (UITextField *)password2;

@end
