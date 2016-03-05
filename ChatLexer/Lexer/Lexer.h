//
//  Lexer.h
//  ChatLexer
//
//  Created by Nabeel Arif on 3/5/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lexer : NSObject
+(NSDictionary*)dictionaryForChatText:(NSString*)chatText;
+(NSString*)jsonStringForChatText:(NSString*)chatText prettyPrint:(BOOL)prettyPrint;
@end
