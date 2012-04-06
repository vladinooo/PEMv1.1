//
//  PEMTextFieldValidation.m
//  PEM
//
//  Created by Vladimir Hartmann on 15/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PEMTextFieldValidation.h"

@implementation PEMTextFieldValidation




// empty textfiled check
- (BOOL)isFieldEmpty: (UITextField *)textField {
    
    if ([textField.text length] == 0) {
        
        return YES;
        
    } else {
        
        return NO;
    }
}


// email validation
- (BOOL)isValidEmail: (NSString *)emailEntry {
    
    NSString *string = emailEntry;
    NSString *expression = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if (match) {
        return YES;
    } else {
        return NO;
    }
    
}


// check if both passwords match
- (BOOL)doPasswordsMatch: (UITextField *)password1: (UITextField *)password2 {
    
    if (([self isFieldEmpty:password1]) || ([self isFieldEmpty:password2])) {
        
        return NO;
        
    }
    
    else if ([password1.text isEqualToString:password2.text]) {
        
        return YES;
        
    }
    
    else {
        
        return NO;
    }
}


@end
