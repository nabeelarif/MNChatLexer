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
@end

@implementation MNParser

-(instancetype)init{
    self = [super init];
    if (self) {
        self.dictionaryLexemes = @{};
    }
    return self;
}
#pragma mark - Lexeme Methods
-(void)setLexeme:(MNLexeme *)lexeme forKey:(NSString *)key
{
    @synchronized(self) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:self.dictionaryLexemes];
        [dictionary setObject:lexeme forKey:key];
        self.dictionaryLexemes = [NSDictionary dictionaryWithDictionary:dictionary];
    }
}
-(MNLexeme*)removeLexemeForKey:(NSString *)key{
    MNLexeme *lexeme;
    @synchronized(self) {
        lexeme = [self.dictionaryLexemes valueForKey:key];
        if (lexeme) {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:self.dictionaryLexemes];
            [dictionary removeObjectForKey:key];
            self.dictionaryLexemes = [NSDictionary dictionaryWithDictionary:dictionary];
        }
    }
    return lexeme;
}
-(NSDictionary*)parseText:(NSString*)text
{
    __block NSMutableDictionary *outputDictionary = [NSMutableDictionary new];
    __block NSMutableDictionary *dataDictionary = [NSMutableDictionary new];
    [outputDictionary setValue:dataDictionary forKey:@"data"];
    [self.dictionaryLexemes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, MNLexeme * _Nonnull obj, BOOL * _Nonnull stop) {
        NSArray *matches;
        NSArray *value = [self lexAndParseText:text forLexeme:obj matches:&matches];
        if (value.count>0) {
            [outputDictionary setObject:matches forKey:key];
            [dataDictionary setObject:value forKey:key];
        }
    }];
    return outputDictionary;
}
-(NSArray*)lexAndParseText:(NSString*)text forLexeme:(MNLexeme*)lexeme matches:(NSArray **)matches
{
    NSMutableSet *setResults = [NSMutableSet new];
    *matches = [lexeme.regex matchesInString:text options:0
                                        range:NSMakeRange(0, [text length])];
    for (NSTextCheckingResult *match in *matches) {
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
@end
