//
//  URLTitlesManager.h
//  ChatLexer
//
//  Created by Nabeel Arif on 3/5/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <Foundation/Foundation.h>

#define URLTitlesKit [URLTitlesManager sharedInstance]

@interface URLTitlesManager : NSObject

+ (nonnull instancetype)sharedInstance;
- (nullable NSString *)titleForUrlString:(nonnull NSString*)urlStr;
- (nullable NSString *)titleForURL:(nonnull NSURL*)url;
- (void)fetchTitleForUrlString:(nonnull NSString*)urlStr;
- (void)fetchTitleForURL:(nonnull NSURL*)url;

@end
