//
//  MNParserAPI.h
//  ChatLexer
//
//  Created by Nabeel Arif on 3/6/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ParserKit [MNParserAPI sharedInstance]
typedef void (^ParsingComplete)(NSDictionary * _Nonnull result);

@interface MNParserAPI : NSObject

+ (nonnull instancetype)sharedInstance;
- (nonnull NSDictionary*)parseText:(nonnull NSString*)text isFinal:(BOOL)isFinal;
- (void)parseText:(nonnull NSString*)text isFinal:(BOOL)isFinal
       completion:(_Nullable ParsingComplete)completion;
+ (nonnull NSString*)jsonForDictionary:(nonnull NSDictionary*)dictionary
                           prettyPrint:(BOOL)prettyPrint;

@end
