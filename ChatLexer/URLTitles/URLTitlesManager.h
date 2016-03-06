//
//  URLTitlesManager.h
//  ChatLexer
//
//  Created by Nabeel Arif on 3/5/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <Foundation/Foundation.h>

#define URLTitlesKit [URLTitlesManager sharedInstance]

typedef void (^URLFetchCompletion)(NSDictionary<NSURL*,NSString*> * _Nonnull result, NSArray<NSURL *>* _Nonnull urls);

@interface URLTitlesManager : NSObject

+ (nonnull instancetype)sharedInstance;
- (nullable NSString *)titleForUrlString:(nonnull NSString*)urlStr;
- (nullable NSString *)titleForURL:(nonnull NSURL*)url;
- (void) fetchTitleForUrls:(nonnull NSArray<NSURL *>*)urls completion:(nullable URLFetchCompletion)completion;

@end
