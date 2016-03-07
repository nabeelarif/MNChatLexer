//
//  Lexer.h
//  ChatLexer
//
//  Created by Nabeel Arif on 3/5/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MNLexeme;
/**
 The class to parse the provided text based on a set of rules i.e MNLexeme objects.
 */
@interface MNParser : NSObject
/**
 It is the main method to parse the provided text based on set rules.
 @param text Any text which needs to be parsed
 @return An NSDictionary object after parsing is complete.
 */
- (nonnull NSDictionary*)parseText:(nonnull NSString*)text;
/**
 Add rules to the parser using this method.
 @param lexeme An object of MNLexeme.
 @param key Key against which the parsed data is added.
 */
- (void)setLexeme:(nonnull MNLexeme*)lexeme forKey:(nonnull NSString*)key;
/**
 Remove a specified rule or MNLexeme based on its key.
 @param key Key for which you need to remove an MNLexeme object.
 @return Removed MNLexeme object
 */
- (nullable MNLexeme*)removeLexemeForKey:(nonnull NSString*)key;
@end
