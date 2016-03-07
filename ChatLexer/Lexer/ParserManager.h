//
//  ParserManager.h
//  ChatLexer
//
//  Created by Nabeel Arif on 3/5/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MNParser;

/**
 This class separates initialization and setting phase from Parser and accomodates it into a single
 place. It is done to make MNParser a more general class which could be configured for any set of 
 rules.
 */
@interface ParserManager : NSObject
/**
 Set parser rules for Chat text.
 @param parser  MNParser object, which will be added with some set of rules for parsing.
 */
+(void)setupChatRulesForParser:(MNParser*)parser;
@end
