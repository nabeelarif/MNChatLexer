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
#import "URLTitlesManager.h"

@implementation ParserManager
+(void)setupChatRulesForParser:(MNParser *)parser
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
        
//        if ([match resultType] == NSTextCheckingTypeLink) {
//            if (([[match.URL scheme] isEqualToString:@"mailto"]==NO)) {
//                urlDictionary = [NSMutableDictionary new];
//                [urlDictionary setObject:[text substringWithRange:match.range] forKey:@"url"];
//                
//                NSInteger endLocation = match.range.location+match.range.length;
//                NSString *title = [URLTitlesKit titleForURL:match.URL];
//                if (title.length==0 && (endLocation<text.length || isFinal)) {
//                    [URLTitlesKit fetchTitleForURL:match.URL];
//                }
//                [urlDictionary setObject:title?title:@"" forKey:@"title"];
//            }
//        }
        return urlDictionary;
    };
    [parser setLexeme:lexemeMention forKey:@"mentions"];
    [parser setLexeme:lexemeEmoticon forKey:@"emoticons"];
    [parser setLexeme:lexemeUrl forKey:@"links"];
    
}
@end
