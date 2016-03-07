//
//  MNLexeme.h
//  ChatLexer
//
//  Created by Nabeel Arif on 3/5/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 User can provide his/her own implementtion while parsing a given lexeme.
 @param match NSTextCheckingResult object within given text.
 @param text Text object under parsing.
 @return Usually returned object will be NSString, NSArray or NSDictionary based on user's
 implementation
 */
typedef id _Nullable  (^ParseLexeme)(NSTextCheckingResult * _Nonnull match, NSUInteger numberOfComponentToUse, NSString * _Nonnull text);

/**
 Lexeme is a single meaningful unit of a language. It can consist on 1 or more words.
 
 In our implementation of MNLexeme, User can define a meaningful unit by specifying MNRegularExpression.
 
 */
@interface MNLexeme : NSObject
/**
 Regular expression to for current lexeme.
 */
@property (nonatomic, strong, nonnull) NSRegularExpression *regex;
/**
 A regular expression can consist on 1 or more groups. If the result of regex consist on more than
 1 groups, you can specify which group should be the part of final parsed object. This value will be 
 ignored if you have provided your own ParseLexeme block and handle parsed data on your own.
 */
@property (nonatomic) NSUInteger numberOfComponentToUse;
/**
 If you want to handle and provide your own parsing structure for a given match in MNLexeme, you can
 implement this block and return your parsed data.
 */
@property (nonatomic, copy, nullable) ParseLexeme parseLexeme;
/**
 A convinient method to setup a regex based on a query or pattern. 
 @param query A query or pattern for regular expression
 @return An NSRegularExpression object based on given query.
 */
-(nullable NSRegularExpression*)setRegexWithQuery:(nonnull NSString*)query;

@end
