//
//  ParserManager.h
//  ChatLexer
//
//  Created by Nabeel Arif on 3/5/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MNParser;

@interface ParserManager : NSObject
+(void)setupChatRulesForParser:(MNParser*)parser;
@end
