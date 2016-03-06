//
//  MNParserAPI.m
//  ChatLexer
//
//  Created by Nabeel Arif on 3/6/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import "MNParserAPI.h"
#import "MNParser.h"
#import "ParserManager.h"

@interface MNParserAPI ()
@property (nonatomic, strong, nonnull) MNParser *parser;
@end

@implementation MNParserAPI

+ (instancetype)sharedInstance {
    static MNParserAPI *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        sharedMyManager.parser = [[MNParser alloc] init];
        [ParserManager setupChatRulesForParser:sharedMyManager.parser];
    });
    return sharedMyManager;
}

- (nonnull NSDictionary*)parseText:(nonnull NSString*)text isFinal:(BOOL)isFinal
{
    NSDictionary *result = [self.parser parseText:text];
    NSDictionary *data = [result objectForKey:@"data"];
    return data;
}
- (void)parseText:(nonnull NSString*)text isFinal:(BOOL)isFinal
       completion:(_Nullable ParsingComplete)completion{
    
}
+(NSString*)jsonForDictionary:(NSDictionary *)dictionary prettyPrint:(BOOL)prettyPrint
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:dictionary
                        options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                        error:&error];
    if (! jsonData) {
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
