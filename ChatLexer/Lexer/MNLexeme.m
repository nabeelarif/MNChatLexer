//
//  MNLexeme.m
//  ChatLexer
//
//  Created by Nabeel Arif on 3/5/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import "MNLexeme.h"

@implementation MNLexeme

#pragma mark - Utility Methods
-(NSRegularExpression*)setRegexWithQuery:(NSString*)query{
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:query
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    if (error) {
        NSLog(@"Error: %@",error);
    }
    self.regex = regex;
    return regex;
}
@end
