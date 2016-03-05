//
//  ParserManager.m
//  ChatLexer
//
//  Created by Nabeel Arif on 3/5/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import "ParserManager.h"
#import "Constants.h"
#import "MNParser.h"
#import "MNLexeme.h"

@implementation ParserManager
+(void)setupParserForChatRules
{
    //Lexeme for @mention
    MNLexeme *lexemeMention = [[MNLexeme alloc] init];
    [lexemeMention setRegexWithQuery:kRegexMention];
    lexemeMention.numberOfComponentToUse = 1;
    
    //Lexeme for @emoticon
    MNLexeme *lexemeEmoticon = [[MNLexeme alloc] init];
    [lexemeEmoticon setRegexWithQuery:kRegexEmoticon];
    lexemeEmoticon.numberOfComponentToUse = 1;
    
    //Lexeme for URLs
    MNLexeme *lexemeUrl = [[MNLexeme alloc] init];
    lexemeUrl.regex = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    lexemeUrl.parseLexeme = ^id(NSTextCheckingResult * match,NSUInteger numberOfComponentToUse, NSString *text)
    {
        NSMutableDictionary *urlDictionary;
        if ([match resultType] == NSTextCheckingTypeLink) {
            if (([[match.URL scheme] isEqualToString:@"mailto"]==NO)) {
                urlDictionary = [NSMutableDictionary new];
                [urlDictionary setObject:[text substringWithRange:match.range] forKey:@"url"];
                [urlDictionary setObject:@"" forKey:@"title"];
            }
        }
        return urlDictionary;
    };
    [MNParserKit setLexeme:lexemeMention forKey:@"mentions"];
    [MNParserKit setLexeme:lexemeEmoticon forKey:@"emoticons"];
    [MNParserKit setLexeme:lexemeUrl forKey:@"links"];
    
}
@end
