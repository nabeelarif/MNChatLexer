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
#import "URLTitlesManager.h"
#import "Constants.h"

@interface MNParserAPI ()
{
    dispatch_queue_t _privateQueue;
}
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
        sharedMyManager->_privateQueue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    });
    return sharedMyManager;
}

- (nonnull NSDictionary*)parseText:(nonnull NSString*)text isFinal:(BOOL)isFinal
{
    NSDictionary *result = [self.parser parseText:text];
    NSDictionary *data = [result objectForKey:kParserKeyData];
    return data;
}
- (void)parseText:(nonnull NSString*)text isFinal:(BOOL)isFinal
       completion:(_Nullable ParsingComplete)completion{
    
    dispatch_async(_privateQueue, ^{
        __block NSDictionary *parsedData = [self.parser parseText:text];
        __block NSMutableDictionary *dataResult = [[parsedData objectForKey:kParserKeyData] mutableCopy];
        
        NSDictionary<NSTextCheckingResult*, id> *matchesLinks = [parsedData objectForKey:kParserKeyLinks];
        __block NSMutableArray *arrayURLs = [NSMutableArray new];
        //Get All urls and send for title retrieval
        [matchesLinks enumerateKeysAndObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (key.resultType == NSTextCheckingTypeLink) {
                NSInteger endLocation = key.range.location+key.range.length;
                NSString *title = [URLTitlesKit titleForURL:key.URL];
                if (!title && (endLocation<text.length || isFinal)) {
                    [arrayURLs addObject:key.URL];
                }
            }
        }];
        
        //Fetch titles and update data
        [URLTitlesKit fetchTitleForUrls:arrayURLs completion:^(NSDictionary<NSURL *,NSString *> * _Nonnull result, NSArray<NSURL *> * _Nonnull urls) {
            NSMutableArray *arrayLinks = [NSMutableArray new];
            [matchesLinks enumerateKeysAndObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if (key.resultType == NSTextCheckingTypeLink) {
                    NSString *title = [URLTitlesKit titleForURL:key.URL];
                    NSMutableDictionary *dictionaryValue = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)obj];
                    if (title) {
                        dictionaryValue[kParserKeyTitle] = title;
                    }
                    [arrayLinks addObject:dictionaryValue];
                }
            }];
            [dataResult setObject:arrayLinks forKey:kParserKeyLinks];
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(dataResult,text);
                });
            }
        }];
    });
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
