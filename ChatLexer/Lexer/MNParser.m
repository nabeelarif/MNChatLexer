//
//  Lexer.m
//  ChatLexer
//
//  Created by Nabeel Arif on 3/5/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import "MNParser.h"
#import "Constants.h"
#import "MNLexeme.h"

@interface MNParser ()
@property (nonatomic, strong) NSDictionary<NSString*,MNLexeme*> *dictionaryLexemes;
-(nonnull NSDictionary*)parseForText:(nonnull NSString*)text;
@end

@implementation MNParser

+ (id)sharedInstance {
    static MNParser *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        sharedMyManager.dictionaryLexemes = @{};
    });
    return sharedMyManager;
}
#pragma mark - Lexeme Methods
-(void)setLexeme:(MNLexeme *)lexeme forKey:(NSString *)key
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:self.dictionaryLexemes];
    [dictionary setObject:lexeme forKey:key];
    self.dictionaryLexemes = [NSDictionary dictionaryWithDictionary:dictionary];
}
-(MNLexeme*)removeLexemeForKey:(NSString *)key{
    
    MNLexeme *lexeme = [self.dictionaryLexemes valueForKey:key];
    if (lexeme) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:self.dictionaryLexemes];
        [dictionary removeObjectForKey:key];
        self.dictionaryLexemes = [NSDictionary dictionaryWithDictionary:dictionary];
    }
    return lexeme;
}
-(NSDictionary*)parseText:(NSString*)text
{
    __block NSMutableDictionary *outputDictionary = [NSMutableDictionary new];
    [self.dictionaryLexemes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, MNLexeme * _Nonnull obj, BOOL * _Nonnull stop) {
        NSArray *value = [self lexAndParseText:text forLexeme:obj];
        if (value.count>0) {
            [outputDictionary setObject:value forKey:key];
        }
    }];
    return outputDictionary;
}
-(NSArray*)lexAndParseText:(NSString*)text forLexeme:(MNLexeme*)lexeme
{
    NSMutableSet *setResults = [NSMutableSet new];
    NSArray *matches = [lexeme.regex matchesInString:text options:0
                                        range:NSMakeRange(0, [text length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *result;
        if (lexeme.parseLexeme) {
            result = lexeme.parseLexeme(match,lexeme.numberOfComponentToUse, text);
        }else{
            NSInteger rangeNumber = 0;
            if (lexeme.numberOfComponentToUse < match.numberOfRanges) {
                rangeNumber = lexeme.numberOfComponentToUse;
            }
            result = [text substringWithRange:[match rangeAtIndex:rangeNumber]];
        }
        if(result){
            [setResults addObject:result];
        }
    }
    return [setResults allObjects];
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
