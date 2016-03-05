//
//  Lexer.h
//  ChatLexer
//
//  Created by Nabeel Arif on 3/5/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MNLexeme;

#define MNParserKit [MNParser sharedInstance]

@interface MNParser : NSObject

+ (nonnull id)sharedInstance;
- (nonnull NSDictionary*)parseText:(nonnull NSString*)text;
- (void)setLexeme:(nonnull MNLexeme*)lexeme forKey:(nonnull NSString*)key;
- (nullable MNLexeme*)removeLexemeForKey:(nonnull NSString*)key;
+ (nonnull NSString*)jsonForDictionary:(nonnull NSDictionary*)dictionary prettyPrint:(BOOL)prettyPrint;
@end
