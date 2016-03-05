//
//  MNLexeme.h
//  ChatLexer
//
//  Created by Nabeel Arif on 3/5/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id _Nullable  (^ParseLexeme)(NSTextCheckingResult * _Nonnull match, NSUInteger numberOfComponentToUse, NSString * _Nonnull text, BOOL isFinal);

@interface MNLexeme : NSObject
@property (nonatomic, strong, nonnull) NSRegularExpression *regex;
@property (nonatomic) NSUInteger numberOfComponentToUse;
@property (nonatomic, copy, nullable) ParseLexeme parseLexeme;

-(nullable NSRegularExpression*)setRegexWithQuery:(nonnull NSString*)query;

@end
