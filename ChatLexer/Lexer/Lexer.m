//
//  Lexer.m
//  ChatLexer
//
//  Created by Nabeel Arif on 3/5/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import "Lexer.h"

@implementation Lexer

NSString *const kRegexMention = @"(\\W+(@+[\\w]+)|^(@+[\\w]+))";
NSString *const kRegexEmoticon = @"\\((\\w+)\\)";

+(NSDictionary*)dictionaryForChatText:(NSString*)chatText
{
    NSMutableDictionary *outputDictionary = [NSMutableDictionary new];
    NSArray *array = [self arrayMentionsFromChatText:chatText];
    if (array.count>0) {
        [outputDictionary setObject:array forKey:@"mentions"];
    }
    array = [self arrayEmoticonsFromChatText:chatText];
    if (array.count>0) {
        [outputDictionary setObject:array forKey:@"emoticons"];
    }
    array = [self arrayUrlsFromChatText:chatText];
    if (array.count>0) {
        [outputDictionary setObject:array forKey:@"links"];
    }
    return outputDictionary;
}
+(NSString*)jsonStringForChatText:(NSString*)chatText prettyPrint:(BOOL)prettyPrint
{
    NSDictionary *outputDictionary = [self dictionaryForChatText:chatText];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:outputDictionary
                        options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                        error:&error];
    if (! jsonData) {
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
+(NSArray*)arrayUrlsFromChatText:(NSString*)chatText
{
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSMutableSet *setResults = [NSMutableSet new];
    NSArray *matches = [linkDetector matchesInString:chatText options:0
                                               range:NSMakeRange(0, [chatText length])];
    for (NSTextCheckingResult *match in matches) {
        if ([match resultType] == NSTextCheckingTypeLink) {
            if (([[match.URL scheme] isEqualToString:@"mailto"]==NO)) {
                NSMutableDictionary *urlDictionary = [NSMutableDictionary new];
                [urlDictionary setObject:[chatText substringWithRange:match.range] forKey:@"url"];
                [urlDictionary setObject:@"" forKey:@"title"];
                [setResults addObject:urlDictionary];
            }
        }
    }
    return [setResults allObjects];
}
+(NSArray*)arrayMentionsFromChatText:(NSString*)chatText{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:kRegexMention
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    NSMutableSet *setResults = [NSMutableSet new];
    NSArray *matches = [regex matchesInString:chatText options:0
                                               range:NSMakeRange(0, [chatText length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *mention = [chatText substringWithRange:match.range];
        mention = [mention substringFromIndex:[mention rangeOfString:@"@"].location+1];
        [setResults addObject:mention];
    }
    return [setResults allObjects];
}
+(NSArray*)arrayEmoticonsFromChatText:(NSString*)chatText{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:kRegexEmoticon
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    NSMutableSet *setResults = [NSMutableSet new];
    NSArray *matches = [regex matchesInString:chatText options:0
                                        range:NSMakeRange(0, [chatText length])];
    for (NSTextCheckingResult *match in matches) {
        NSRange range = NSMakeRange(match.range.location+1, match.range.length-2);
        [setResults addObject:[chatText substringWithRange:range]];
    }
    return [setResults allObjects];
}
@end
