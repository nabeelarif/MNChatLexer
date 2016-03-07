//
//  URLTitlesManager.h
//  ChatLexer
//
//  Created by Nabeel Arif on 3/5/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A shorthand notiation to access URLTitlesManager's singleton object.
 */
#define URLTitlesKit [URLTitlesManager sharedInstance]

/**
 A completion block invoked to inform the caller that URLTitlesKit has completed its task to 
 get titles of associated URLs.
 */
typedef void (^URLFetchCompletion)(NSDictionary<NSURL*,NSString*> * _Nonnull result, NSArray<NSURL *>* _Nonnull urls);

/**
 URLTitlesManager maintains the web-services to get titles of certain URLs. It maintains an NSCache
 of all URLs who's title is already retrieved to avoid retrieving same title multiple times. It also
 maintains an NSSet to hold set of all URLs which are currently under process for title. This way we
 ensure that same url is not hit multiple times.
 */
@interface URLTitlesManager : NSObject
/**
 Single design pattern to return URLTitlesManager's single instance.
 */
+ (nonnull instancetype)sharedInstance;
/**
 This methods looks for the title of given 'url' into cache and returns it.
 @param url An NSURL who's title is required
 @return Title associated with the provided url
 */
- (nullable NSString *)titleForURL:(nonnull NSURL*)url;
/**
 Executes a group of tasks to get titles of given urls. The whole process is asynchronous to avoid,
 blocking main UI thread. Once all tasks are complete client is notified about completion.
 @param urls An array of URLs who's title is required
 @param completion Block which is invoked once all tasks under process are complete adn we have final
 list of titles for given urls
 */
- (void) fetchTitleForUrls:(nonnull NSArray<NSURL *>*)urls completion:(nullable URLFetchCompletion)completion;

@end
